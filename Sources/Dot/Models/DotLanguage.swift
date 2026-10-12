import Foundation
import SwiftUI

public enum DotLanguage: String, CaseIterable, Identifiable, Codable {
    case russian    = "ru"
    case english    = "en"
    case chinese    = "zh"
    case japanese   = "ja"
    case spanish    = "es"
    case german     = "de"
    case french     = "fr"
    case korean     = "ko"

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .russian:  return "Русский 🇷🇺"
        case .english:  return "English 🇺🇸"
        case .chinese:  return "中文 (简体) 🇨🇳"
        case .japanese: return "日本語 🇯🇵"
        case .spanish:  return "Español 🇪🇸"
        case .german:   return "Deutsch 🇩🇪"
        case .french:   return "Français 🇫🇷"
        case .korean:   return "한국어 🇰🇷"
        }
    }

    public var defaultVoice: String {
        switch self {
        case .russian:  return "Milena"
        case .english:  return "Samantha"
        case .chinese:  return "Tingting"
        case .japanese: return "Kyoko"
        case .spanish:  return "Monica"
        case .german:   return "Anna"
        case .french:   return "Aurelie"
        case .korean:   return "Yuna"
        }
    }

    public var promptInstruction: String {
        switch self {
        case .russian:
            return "LANGUAGE & TONE INSTRUCTION: Общайся максимально по-человечески, живо, тепло и с душой! Не будь сухим роботом или шаблоном. Отвечай развёрнуто, подробно, интересно и с реальной пользой. Не обрывай ответы на 1-2 коротких предложениях — объясняй тему основательно, приводи понятные примеры, делись мыслями и поддерживай естественную дружескую беседу."
        case .english:
            return "LANGUAGE & TONE INSTRUCTION: Speak naturally, warmly, and authentically like a real human friend! Never sound like a robotic corporate assistant. Provide rich, detailed, comprehensive, and helpful answers without cutting them short into 1-2 sentence brush-offs. Explain things thoroughly with clear reasoning and practical depth."
        case .chinese:
            return "LANGUAGE & TONE INSTRUCTION: 请用自然、生动、温暖且富有人情味的中文交流！不要像冰冷的机器人那样生硬。请提供详细、充实且有深度的完整解答，不要只回复简短的一两句话，要详尽解释并举例说明。"
        case .japanese:
            return "LANGUAGE & TONE INSTRUCTION: ロボットのような冷たい定型文ではなく、親しみやすく自然で温かい人間の言葉遣いで話してください！短すぎる一言で終わらせず、詳しく丁寧で役立つ回答をしっかりと届けてください。"
        case .spanish:
            return "LANGUAGE & TONE INSTRUCTION: ¡Habla de manera cálida, humana, animada y cercana! No suenes como un robot frío. Da respuestas completas, detalladas y bien explicadas, sin limitarte a frases cortas."
        case .german:
            return "LANGUAGE & TONE INSTRUCTION: Sprich warmherzig, lebendig und menschlich wie ein guter Freund! Vermeide roboterhafte Standardfloskeln. Gib ausführliche, fundierte und gründliche Antworten statt knapper Sätze."
        case .french:
            return "LANGUAGE & TONE INSTRUCTION: Parlez de manière chaleureuse, vivante et humaine, comme un véritable ami ! Évitez le ton robotique. Donnez des réponses riches, complètes et bien détaillées sans les écourter."
        case .korean:
            return "LANGUAGE & TONE INSTRUCTION: 로봇 같은 딱딱한 말투 대신, 따뜻하고 친근하며 자연스러운 한국어로 대화해 주세요! 1~2문장으로 짧게 끊지 말고, 자세하고 풍부하며 유익한 설명을 정성껏 제공해 주세요."
        }
    }

    public func localized(_ key: LocalizationKey) -> String {
        switch key {
        case .chatPlaceholder:
            switch self {
            case .russian:  return "Спроси меня о чём угодно..."
            case .english:  return "Ask me anything..."
            case .chinese:  return "向我提问任何问题..."
            case .japanese: return "何でも聞いてください..."
            case .spanish:  return "Pregúntame lo que sea..."
            case .german:   return "Frag mich etwas..."
            case .french:   return "Demandez-moi n'importe quoi..."
            case .korean:   return "무엇이든 물어보세요..."
            }

        case .screenAction:
            switch self {
            case .russian:  return "Экран"
            case .english:  return "Screen"
            case .chinese:  return "查看屏幕"
            case .japanese: return "画面"
            case .spanish:  return "Pantalla"
            case .german:   return "Bildschirm"
            case .french:   return "Écran"
            case .korean:   return "화면"
            }

        case .clipboardAction:
            switch self {
            case .russian:  return "Буфер"
            case .english:  return "Clipboard"
            case .chinese:  return "剪贴板"
            case .japanese: return "クリップボード"
            case .spanish:  return "Portapapeles"
            case .german:   return "Zwischenablage"
            case .french:   return "Presse-papiers"
            case .korean:   return "클립보드"
            }

        case .clearAction:
            switch self {
            case .russian:  return "Очистить"
            case .english:  return "Clear"
            case .chinese:  return "清空"
            case .japanese: return "クリア"
            case .spanish:  return "Limpiar"
            case .german:   return "Löschen"
            case .french:   return "Effacer"
            case .korean:   return "지우기"
            }

        case .goalsAction:
            switch self {
            case .russian:  return "Цели"
            case .english:  return "Goals"
            case .chinese:  return "目标"
            case .japanese: return "目標"
            case .spanish:  return "Objetivos"
            case .german:   return "Ziele"
            case .french:   return "Objectifs"
            case .korean:   return "목표"
            }

        case .settingsTitle:
            switch self {
            case .russian:  return "Настройки Dot"
            case .english:  return "Dot Preferences"
            case .chinese:  return "Dot 设置"
            case .japanese: return "Dot 設定"
            case .spanish:  return "Preferencias de Dot"
            case .german:   return "Dot Einstellungen"
            case .french:   return "Préférences Dot"
            case .korean:   return "Dot 설정"
            }

        case .tabAI:
            switch self {
            case .russian:  return "AI и Язык"
            case .english:  return "AI & Language"
            case .chinese:  return "语言与 AI"
            case .japanese: return "言語と AI"
            case .spanish:  return "Idioma e IA"
            case .german:   return "Sprache & KI"
            case .french:   return "Langue & IA"
            case .korean:   return "언어 및 AI"
            }

        case .tabAvatar:
            switch self {
            case .russian:  return "Аватар"
            case .english:  return "Avatar"
            case .chinese:  return "形象"
            case .japanese: return "アバター"
            case .spanish:  return "Avatar"
            case .german:   return "Avatar"
            case .french:   return "Avatar"
            case .korean:   return "아바타"
            }

        case .tabVoice:
            switch self {
            case .russian:  return "Голос"
            case .english:  return "Voice"
            case .chinese:  return "声音"
            case .japanese: return "音声"
            case .spanish:  return "Voz"
            case .german:   return "Stimme"
            case .french:   return "Voix"
            case .korean:   return "음성"
            }

        case .languageLabel:
            switch self {
            case .russian:  return "Язык общения и интерфейса"
            case .english:  return "Language & Interaction"
            case .chinese:  return "交互语言与界面"
            case .japanese: return "対話言語とインターフェース"
            case .spanish:  return "Idioma de interacción"
            case .german:   return "Interaktionssprache"
            case .french:   return "Langue d'interaction"
            case .korean:   return "대화 언어 설정"
            }

        case .apiKeyLabel:
            switch self {
            case .russian:  return "Ключ Google Gemini API"
            case .english:  return "Google Gemini API Key"
            case .chinese:  return "Google Gemini API 密钥"
            case .japanese: return "Google Gemini API キー"
            case .spanish:  return "Clave de API Google Gemini"
            case .german:   return "Google Gemini API-Schlüssel"
            case .french:   return "Clé API Google Gemini"
            case .korean:   return "Google Gemini API 키"
            }

        case .apiKeyPlaceholder:
            switch self {
            case .russian:  return "Вставь Gemini API ключ"
            case .english:  return "Paste Gemini API Key"
            case .chinese:  return "粘贴 Gemini API 密钥"
            case .japanese: return "Gemini API キーを貼り付け"
            case .spanish:  return "Pega la clave de Gemini"
            case .german:   return "Gemini API-Schlüssel einfügen"
            case .french:   return "Coller la clé API Gemini"
            case .korean:   return "Gemini API 키 붙여넣기"
            }

        case .apiKeyHelp:
            switch self {
            case .russian:  return "Получить бесплатный ключ в Google AI Studio ↗"
            case .english:  return "Get free Gemini API Key from Google AI Studio ↗"
            case .chinese:  return "前往 Google AI Studio 获取免费密钥 ↗"
            case .japanese: return "Google AI Studio で無料キーを取得 ↗"
            case .spanish:  return "Obtener clave gratis en Google AI Studio ↗"
            case .german:   return "Kostenlosen Schlüssel bei Google AI Studio holen ↗"
            case .french:   return "Obtenir une clé gratuite sur Google AI Studio ↗"
            case .korean:   return "Google AI Studio에서 무료 키 받기 ↗"
            }

        case .modelLabel:
            switch self {
            case .russian:  return "Модель Gemini"
            case .english:  return "Gemini Model"
            case .chinese:  return "Gemini 模型"
            case .japanese: return "Gemini モデル"
            case .spanish:  return "Modelo Gemini"
            case .german:   return "Gemini Modell"
            case .french:   return "Modèle Gemini"
            case .korean:   return "Gemini 모델"
            }

        case .presetsLabel:
            switch self {
            case .russian:  return "Пресеты аватара"
            case .english:  return "Avatar Presets"
            case .chinese:  return "伴侣预设"
            case .japanese: return "アバタープリセット"
            case .spanish:  return "Preajustes de avatar"
            case .german:   return "Avatar-Voreinstellungen"
            case .french:   return "Préréglages d'avatar"
            case .korean:   return "아바타 프리셋"
            }

        case .speechEnabledLabel:
            switch self {
            case .russian:  return "Голосовое озвучивание"
            case .english:  return "Voice Speech (TTS)"
            case .chinese:  return "语音朗读 (TTS)"
            case .japanese: return "音声読み上げ (TTS)"
            case .spanish:  return "Voz hablada (TTS)"
            case .german:   return "Sprachausgabe (TTS)"
            case .french:   return "Synthèse vocale (TTS)"
            case .korean:   return "음성 읽기 (TTS)"
            }

        case .voiceLabel:
            switch self {
            case .russian:  return "Системный голос"
            case .english:  return "System Voice"
            case .chinese:  return "系统语音"
            case .japanese: return "システム音声"
            case .spanish:  return "Voz del sistema"
            case .german:   return "Systemstimme"
            case .french:   return "Voix système"
            case .korean:   return "시스템 음성"
            }

        case .speechRateLabel:
            switch self {
            case .russian:  return "Скорость речи"
            case .english:  return "Speech Rate"
            case .chinese:  return "语速"
            case .japanese: return "話す速度"
            case .spanish:  return "Velocidad de voz"
            case .german:   return "Sprechgeschwindigkeit"
            case .french:   return "Vitesse de parole"
            case .korean:   return "말하기 속도"
            }

        case .soundEffectsLabel:
            switch self {
            case .russian:  return "Звуковые эффекты"
            case .english:  return "Sound Effects"
            case .chinese:  return "音效反馈"
            case .japanese: return "効果音"
            case .spanish:  return "Efectos de sonido"
            case .german:   return "Soundeffekte"
            case .french:   return "Effets sonores"
            case .korean:   return "효과음"
            }

        case .moodIdle:
            switch self {
            case .russian:  return "Отдыхает"
            case .english:  return "Chilling"
            case .chinese:  return "待命中"
            case .japanese: return "待機中"
            case .spanish:  return "Esperando"
            case .german:   return "Bereit"
            case .french:   return "En attente"
            case .korean:   return "대기 중"
            }

        case .moodThinking:
            switch self {
            case .russian:  return "Думает..."
            case .english:  return "Thinking..."
            case .chinese:  return "思考中..."
            case .japanese: return "思考中..."
            case .spanish:  return "Pensando..."
            case .german:   return "Denkt nach..."
            case .french:   return "Réflexion..."
            case .korean:   return "생각 중..."
            }

        case .moodSpeaking:
            switch self {
            case .russian:  return "Говорит..."
            case .english:  return "Speaking..."
            case .chinese:  return "说话中..."
            case .japanese: return "発話中..."
            case .spanish:  return "Hablando..."
            case .german:   return "Spricht..."
            case .french:   return "Parle..."
            case .korean:   return "말하는 중..."
            }

        case .moodSuccess:
            switch self {
            case .russian:  return "Готово!"
            case .english:  return "Success!"
            case .chinese:  return "完成！"
            case .japanese: return "完了！"
            case .spanish:  return "¡Listo!"
            case .german:   return "Fertig!"
            case .french:   return "Terminé !"
            case .korean:   return "완료!"
            }

        case .moodError:
            switch self {
            case .russian:  return "Ошибка"
            case .english:  return "Error"
            case .chinese:  return "错误"
            case .japanese: return "エラー"
            case .spanish:  return "Error"
            case .german:   return "Fehler"
            case .french:   return "Erreur"
            case .korean:   return "오류"
            }

        case .moodSleeping:
            switch self {
            case .russian:  return "Спит zZz"
            case .english:  return "Sleeping zZz"
            case .chinese:  return "休眠中 zZz"
            case .japanese: return "睡眠中 zZz"
            case .spanish:  return "Durmiendo zZz"
            case .german:   return "Schläft zZz"
            case .french:   return "Dort zZz"
            case .korean:   return "수면 중 zZz"
            }
        }
    }
}

public enum LocalizationKey {
    case chatPlaceholder
    case screenAction
    case clipboardAction
    case clearAction
    case goalsAction
    case settingsTitle
    case tabAI
    case tabAvatar
    case tabVoice
    case languageLabel
    case apiKeyLabel
    case apiKeyPlaceholder
    case apiKeyHelp
    case modelLabel
    case presetsLabel
    case speechEnabledLabel
    case voiceLabel
    case speechRateLabel
    case soundEffectsLabel
    case moodIdle
    case moodThinking
    case moodSpeaking
    case moodSuccess
    case moodError
    case moodSleeping
}
