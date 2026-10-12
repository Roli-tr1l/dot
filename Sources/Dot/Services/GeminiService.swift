import Foundation
import AppKit

public class GeminiService {
    public static let shared = GeminiService()

    private let session = URLSession(configuration: .default)

    private init() {}

    public func sendMessage(
        prompt: String,
        image: NSImage? = nil,
        conversationHistory: [ChatMessage] = []
    ) async throws -> (response: String, action: ActionRecord?) {
        let apiKey = DotConfig.shared.apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !apiKey.isEmpty else {
            throw NSError(
                domain: "DotGemini",
                code: 401,
                userInfo: [NSLocalizedDescriptionKey: "Gemini API Key is missing. Please set it in Settings (Gear icon)!"]
            )
        }

        let model = DotConfig.shared.model
        let urlString = "https://generativelanguage.googleapis.com/v1beta/models/\(model):generateContent?key=\(apiKey)"

        guard let url = URL(string: urlString) else {
            throw NSError(domain: "DotGemini", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid API URL"])
        }

        // Build contents payload
        var contents: [[String: Any]] = []

        // Append recent history (up to last 10 messages for context)
        let recentMessages = conversationHistory.suffix(10)
        for msg in recentMessages {
            let role = msg.role == .user ? "user" : "model"
            contents.append([
                "role": role,
                "parts": [["text": msg.text]]
            ])
        }

        // Build new user prompt part
        var userParts: [[String: Any]] = [
            ["text": prompt]
        ]

        if let image = image, let base64Data = imageToBase64(image) {
            userParts.append([
                "inlineData": [
                    "mimeType": "image/png",
                    "data": base64Data
                ]
            ])
        }

        contents.append([
            "role": "user",
            "parts": userParts
        ])

        let effectiveSystemPrompt = """
\(DotConfig.shared.systemPrompt)

\(DotConfig.shared.language.promptInstruction)
"""

        let requestBody: [String: Any] = [
            "contents": contents,
            "systemInstruction": [
                "parts": [
                    ["text": effectiveSystemPrompt]
                ]
            ],
            "generationConfig": [
                "temperature": 0.7,
                "maxOutputTokens": 2048
            ]
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])

        let (data, httpResponse) = try await session.data(for: request)

        guard let http = httpResponse as? HTTPURLResponse else {
            throw NSError(domain: "DotGemini", code: -1, userInfo: [NSLocalizedDescriptionKey: "No response from Gemini"])
        }

        if http.statusCode != 200 {
            if let errorObj = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let errorDict = errorObj["error"] as? [String: Any],
               let message = errorDict["message"] as? String {
                throw NSError(domain: "DotGemini", code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: "Gemini API Error (\(http.statusCode)): \(message)"])
            }
            let rawStr = String(data: data, encoding: .utf8) ?? "HTTP \(http.statusCode)"
            throw NSError(domain: "DotGemini", code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: rawStr])
        }

        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let candidates = json["candidates"] as? [[String: Any]],
              let firstCandidate = candidates.first,
              let content = firstCandidate["content"] as? [String: Any],
              let parts = content["parts"] as? [[String: Any]],
              let firstPart = parts.first,
              let responseText = firstPart["text"] as? String else {
            throw NSError(domain: "DotGemini", code: -2, userInfo: [NSLocalizedDescriptionKey: "Failed to parse Gemini response"])
        }

        // Process any embedded system commands
        let (cleanedResponse, action) = await processEmbeddedCommands(responseText)
        return (cleanedResponse, action)
    }

    private func processEmbeddedCommands(_ text: String) async -> (String, ActionRecord?) {
        var processedText = text
        var actionRecord: ActionRecord?

        // Check for shell execution: <<<EXEC: cmd>>>
        if let match = text.range(of: "<<<EXEC:\\s*([^>]+)>>>", options: .regularExpression) {
            let commandString = text[match]
                .replacingOccurrences(of: "<<<EXEC:", with: "")
                .replacingOccurrences(of: ">>>", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)

            let result = await SystemService.shared.executeCommand(commandString)
            let isSuccess = result.exitCode == 0
            let output = isSuccess ? (result.stdout.isEmpty ? "Done (exit code 0)" : result.stdout) : result.stderr
            actionRecord = ActionRecord(
                command: commandString,
                output: output.trimmingCharacters(in: .whitespacesAndNewlines),
                isSuccess: isSuccess
            )

            processedText = processedText.replacingCharacters(in: match, with: "\n*Executed `\(commandString)`*\n```\n\(output.trimmingCharacters(in: .whitespacesAndNewlines))\n```")
        }

        // Check for notification: <<<NOTIFY: title | message>>>
        if let match = text.range(of: "<<<NOTIFY:\\s*([^>]+)>>>", options: .regularExpression) {
            let content = text[match]
                .replacingOccurrences(of: "<<<NOTIFY:", with: "")
                .replacingOccurrences(of: ">>>", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)

            let parts = content.components(separatedBy: "|")
            let title = parts.first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Dot"
            let msg = parts.count > 1 ? parts[1].trimmingCharacters(in: .whitespacesAndNewlines) : title
            SystemService.shared.postNotification(title: title, message: msg)
            processedText = processedText.replacingCharacters(in: match, with: "")
        }

        // Check for volume: <<<VOLUME: 40>>>
        if let match = text.range(of: "<<<VOLUME:\\s*(\\d+)>>>", options: .regularExpression) {
            let numStr = text[match]
                .replacingOccurrences(of: "<<<VOLUME:", with: "")
                .replacingOccurrences(of: ">>>", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            if let percent = Int(numStr) {
                SystemService.shared.setVolume(percent: percent)
            }
            processedText = processedText.replacingCharacters(in: match, with: "")
        }

        // Check for battery: <<<BATTERY>>>
        if text.contains("<<<BATTERY>>>") {
            let status = SystemService.shared.getBatteryStatus()
            processedText = processedText.replacingOccurrences(of: "<<<BATTERY>>>", with: "\n*Mac Battery*: \(status)")
        }

        return (processedText.trimmingCharacters(in: .whitespacesAndNewlines), actionRecord)
    }

    private func imageToBase64(_ image: NSImage) -> String? {
        guard let tiffData = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData),
              let pngData = bitmap.representation(using: .png, properties: [:]) else {
            return nil
        }
        return pngData.base64EncodedString()
    }
}
