import Foundation

public struct WebSearchResult: Identifiable, Codable {
    public var id: UUID = UUID()
    public let title: String
    public let snippet: String
    public let url: String
}

public class WebResearchService {
    public static let shared = WebResearchService()

    private let session: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 12.0
        config.timeoutIntervalForResource = 15.0
        self.session = URLSession(configuration: config)
    }

    /// Searches DuckDuckGo HTML / API for queries without requiring an external API key
    public func search(query: String) async -> [WebSearchResult] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return [] }

        guard let encoded = trimmed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://html.duckduckgo.com/html/?q=\(encoded)") else {
            return []
        }

        var request = URLRequest(url: url)
        request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36", forHTTPHeaderField: "User-Agent")

        do {
            let (data, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                return []
            }

            guard let html = String(data: data, encoding: .utf8) else {
                return []
            }

            return parseDuckDuckGoHTML(html)
        } catch {
            return []
        }
    }

    /// Fetches and cleans textual content from any given URL
    public func fetchPageContent(urlString: String) async -> String? {
        guard let url = URL(string: urlString) else { return nil }
        var request = URLRequest(url: url)
        request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)", forHTTPHeaderField: "User-Agent")

        do {
            let (data, resp) = try await session.data(for: request)
            guard let http = resp as? HTTPURLResponse, http.statusCode == 200 else { return nil }
            guard let html = String(data: data, encoding: .utf8) else { return nil }
            return stripHTMLTags(html).prefix(1500).description
        } catch {
            return nil
        }
    }

    private func parseDuckDuckGoHTML(_ html: String) -> [WebSearchResult] {
        var results: [WebSearchResult] = []

        // Extract result snippet chunks
        let snippetPattern = "<a class=\"result__snippet[^>]*>([\\s\\S]*?)<\\/a>"
        let titlePattern = "<a class=\"result__url[^>]*href=\"([^\"]+)\"[^>]*>([\\s\\S]*?)<\\/a>"

        if let snippetRegex = try? NSRegularExpression(pattern: snippetPattern, options: []),
           let titleRegex = try? NSRegularExpression(pattern: titlePattern, options: []) {
            let nsHtml = html as NSString
            let snippetMatches = snippetRegex.matches(in: html, options: [], range: NSRange(location: 0, length: nsHtml.length))
            let titleMatches = titleRegex.matches(in: html, options: [], range: NSRange(location: 0, length: nsHtml.length))

            let count = min(5, min(snippetMatches.count, titleMatches.count))
            for i in 0..<count {
                let snippetRaw = nsHtml.substring(with: snippetMatches[i].range(at: 1))
                let urlRaw = nsHtml.substring(with: titleMatches[i].range(at: 1))
                let titleRaw = nsHtml.substring(with: titleMatches[i].range(at: 2))

                let cleanTitle = stripHTMLTags(titleRaw)
                let cleanSnippet = stripHTMLTags(snippetRaw)

                if !cleanTitle.isEmpty && !cleanSnippet.isEmpty {
                    results.append(WebSearchResult(
                        title: cleanTitle,
                        snippet: cleanSnippet,
                        url: urlRaw
                    ))
                }
            }
        }

        return results
    }

    private func stripHTMLTags(_ str: String) -> String {
        return str
            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
            .replacingOccurrences(of: "&nbsp;", with: " ")
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&quot;", with: "\"")
            .replacingOccurrences(of: "&#39;", with: "'")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&gt;", with: ">")
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
