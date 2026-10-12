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

        case .goalsTitle:
            switch self {
            case .russian:  return "Автономные цели"
            case .english:  return "Autonomous Goals"
            case .chinese:  return "自主常驻目标"
            case .japanese: return "自律バックグラウンド目標"
            case .spanish:  return "Objetivos autónomos"
            case .german:   return "Autonome Ziele"
            case .french:   return "Objectifs autonomes"
            case .korean:   return "자율 상주 목표"
            }

        case .goalsSubtitle:
            switch self {
            case .russian:  return "Фоновые микро-агенты"
            case .english:  return "Standing background micro-agents"
            case .chinese:  return "常驻后台微智能体"
            case .japanese: return "バックグラウンド常駐エージェント"
            case .spanish:  return "Microagentes en segundo plano"
            case .german:   return "Hintergrund-Mikro-Agenten"
            case .french:   return "Micro-agents d'arrière-plan"
            case .korean:   return "상주형 백그라운드 마이크로 에이전트"
            }

        case .addGoalButton:
            switch self {
            case .russian:  return "Добавить фоновую цель"
            case .english:  return "Add Standing Goal"
            case .chinese:  return "添加常驻目标"
            case .japanese: return "目標を追加"
            case .spanish:  return "Añadir objetivo"
            case .german:   return "Neues Ziel hinzufügen"
            case .french:   return "Ajouter un objectif"
            case .korean:   return "상주 목표 추가"
            }

        case .newGoalTitle:
            switch self {
            case .russian:  return "Новая цель"
            case .english:  return "New Goal"
            case .chinese:  return "新目标"
            case .japanese: return "新しい目標"
            case .spanish:  return "Nuevo objetivo"
            case .german:   return "Neues Ziel"
            case .french:   return "Nouvel objectif"
            case .korean:   return "새 목표"
            }

        case .goalTitlePlaceholder:
            switch self {
            case .russian:  return "Название цели (напр. Контроль батареи)"
            case .english:  return "Goal Title (e.g. Battery Sentinel)"
            case .chinese:  return "目标名称（例如：电池监控）"
            case .japanese: return "目標のタイトル（例: バッテリー監視）"
            case .spanish:  return "Título (ej. Centinela de batería)"
            case .german:   return "Titel (z. B. Akku-Wächter)"
            case .french:   return "Titre (ex. Sentinelle de batterie)"
            case .korean:   return "목표 제목 (예: 배터리 감시)"
            }

        case .goalPromptPlaceholder:
            switch self {
            case .russian:  return "Инструкция / промпт для Gemini..."
            case .english:  return "Prompt instruction for Gemini..."
            case .chinese:  return "给 Gemini 的提示词指令..."
            case .japanese: return "Gemini へのプロンプト指示..."
            case .spanish:  return "Instrucción de prompt para Gemini..."
            case .german:   return "Prompt-Anweisung für Gemini..."
            case .french:   return "Instruction de prompt pour Gemini..."
            case .korean:   return "Gemini 프롬프트 지시사항..."
            }

        case .intervalLabel:
            switch self {
            case .russian:  return "Интервал:"
            case .english:  return "Interval:"
            case .chinese:  return "运行间隔："
            case .japanese: return "間隔:"
            case .spanish:  return "Intervalo:"
            case .german:   return "Intervall:"
            case .french:   return "Intervalle :"
            case .korean:   return "주기:"
            }

        case .cancelButton:
            switch self {
            case .russian:  return "Отмена"
            case .english:  return "Cancel"
            case .chinese:  return "取消"
            case .japanese: return "キャンセル"
            case .spanish:  return "Cancelar"
            case .german:   return "Abbrechen"
            case .french:   return "Annuler"
            case .korean:   return "취소"
            }

        case .saveButton:
            switch self {
            case .russian:  return "Сохранить"
            case .english:  return "Save"
            case .chinese:  return "保存"
            case .japanese: return "保存"
            case .spanish:  return "Guardar"
            case .german:   return "Speichern"
            case .french:   return "Enregistrer"
            case .korean:   return "저장"
            }

        case .resultLabel:
            switch self {
            case .russian:  return "Результат:"
            case .english:  return "Result:"
            case .chinese:  return "执行结果:"
            case .japanese: return "実行結果:"
            case .spanish:  return "Resultado:"
            case .german:   return "Ergebnis:"
            case .french:   return "Résultat :"
            case .korean:   return "결과:"
            }

        case .promptInstructionsLabel:
            switch self {
            case .russian:  return "Системный промпт / Инструкции"
            case .english:  return "Prompt / Instructions"
            case .chinese:  return "系统提示词与指令"
            case .japanese: return "プロンプト / システム指示"
            case .spanish:  return "Prompt / Instrucciones"
            case .german:   return "Prompt / Anweisungen"
            case .french:   return "Prompt / Instructions"
            case .korean:   return "프롬프트 / 시스템 지시"
            }

        case .bodyGeometryLabel:
            switch self {
            case .russian:  return "Форма тела аватара"
            case .english:  return "Body Geometry"
            case .chinese:  return "身材几何形态"
            case .japanese: return "ボディ形状"
            case .spanish:  return "Geometría corporal"
            case .german:   return "Körperform"
            case .french:   return "Forme du corps"
            case .korean:   return "바디 형태"
            }

        case .colorAuraLabel:
            switch self {
            case .russian:  return "Цветовая аура"
            case .english:  return "Color Aura"
            case .chinese:  return "色彩光晕"
            case .japanese: return "カラーオーラ"
            case .spanish:  return "Aura de color"
            case .german:   return "Farb-Aura"
            case .french:   return "Aura de couleur"
            case .korean:   return "컬러 오라"
            }

        case .accessoryLabel:
            switch self {
            case .russian:  return "Аксессуары"
            case .english:  return "Accessory"
            case .chinese:  return "配饰"
            case .japanese: return "アクセサリー"
            case .spanish:  return "Accesorio"
            case .german:   return "Accessoire"
            case .french:   return "Accessoire"
            case .korean:   return "액세서리"
            }

        case .avatarScaleLabel:
            switch self {
            case .russian:  return "Размер аватара"
            case .english:  return "Avatar Scale"
            case .chinese:  return "尺寸缩放"
            case .japanese: return "アバタースケール"
            case .spanish:  return "Tamaño del avatar"
            case .german:   return "Avatar-Größe"
            case .french:   return "Échelle de l'avatar"
            case .korean:   return "아바타 크기"
            }

        case .autoSleepLabel:
            switch self {
            case .russian:  return "Авто-сон при бездействии"
            case .english:  return "Auto-sleep when inactive"
            case .chinese:  return "闲置时自动休眠"
            case .japanese: return "非アクティブ時に自動スリープ"
            case .spanish:  return "Suspender automáticamente"
            case .german:   return "Automatischer Ruhezustand"
            case .french:   return "Mise en veille auto"
            case .korean:   return "비활성 시 자동 수면"
            }

        case .testVoiceButton:
            switch self {
            case .russian:  return "Проверить голос 🔊"
            case .english:  return "Test Voice 🔊"
            case .chinese:  return "试听声音 🔊"
            case .japanese: return "音声をテスト 🔊"
            case .spanish:  return "Probar voz 🔊"
            case .german:   return "Stimme testen 🔊"
            case .french:   return "Tester la voix 🔊"
            case .korean:   return "음성 테스트 🔊"
            }
        }
    }

    public func everyMinutes(_ mins: Int) -> String {
        switch self {
        case .russian:  return "Каждые \(mins) мин"
        case .english:  return "Every \(mins) min"
        case .chinese:  return "每 \(mins) 分钟"
        case .japanese: return "\(mins)分ごと"
        case .spanish:  return "Cada \(mins) min"
        case .german:   return "Alle \(mins) Min."
        case .french:   return "Toutes les \(mins) min"
        case .korean:   return "\(mins)분마다"
        }
    }

    public func lastChecked(_ timeStr: String) -> String {
        switch self {
        case .russian:  return "Проверено: \(timeStr)"
        case .english:  return "Last checked: \(timeStr)"
        case .chinese:  return "上次检查: \(timeStr)"
        case .japanese: return "最終確認: \(timeStr)"
        case .spanish:  return "Última comprobación: \(timeStr)"
        case .german:   return "Zuletzt geprüft: \(timeStr)"
        case .french:   return "Dernière vérif. : \(timeStr)"
        case .korean:   return "마지막 확인: \(timeStr)"
        }
    }

    public func defaultGoals() -> [TaskGoal] {
        switch self {
        case .russian:
            return [
                TaskGoal(
                    title: "Контроль батареи Mac",
                    prompt: "Проверь процент заряда батареи. Если ниже 20% и зарядка не подключена, предупреди пользователя.",
                    intervalSeconds: 600,
                    isEnabled: false
                ),
                TaskGoal(
                    title: "Разминка и отдых глаз",
                    prompt: "Напомни пользователю размяться, поморгать и сделать пару глотков воды.",
                    intervalSeconds: 3600,
                    isEnabled: false
                )
            ]
        case .chinese:
            return [
                TaskGoal(
                    title: "Mac 电池监测",
                    prompt: "检查电量百分比。如果低于 20% 且未充电，提醒用户插上电源。",
                    intervalSeconds: 600,
                    isEnabled: false
                ),
                TaskGoal(
                    title: "久坐与视力休息提醒",
                    prompt: "提醒用户活动身体、眨眼休息并喝一口水。",
                    intervalSeconds: 3600,
                    isEnabled: false
                )
            ]
        case .japanese:
            return [
                TaskGoal(
                    title: "Mac バッテリー監視",
                    prompt: "バッテリー残量を確認し、20%未満で充電されていない場合はユーザーに警告してください。",
                    intervalSeconds: 600,
                    isEnabled: false
                ),
                TaskGoal(
                    title: "姿勢とストレッチのリマインダー",
                    prompt: "軽くストレッチし、まばたきをして水分補給するよう促してください。",
                    intervalSeconds: 3600,
                    isEnabled: false
                )
            ]
        default:
            return [
                TaskGoal(
                    title: "Mac Battery Sentinel",
                    prompt: "Check battery percentage. If below 20% and not charging, warn the user.",
                    intervalSeconds: 600,
                    isEnabled: false
                ),
                TaskGoal(
                    title: "Desk Break & Posture Check",
                    prompt: "Remind the user to stretch, blink, and take a sip of water.",
                    intervalSeconds: 3600,
                    isEnabled: false
                )
            ]
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
    case goalsTitle
    case goalsSubtitle
    case addGoalButton
    case newGoalTitle
    case goalTitlePlaceholder
    case goalPromptPlaceholder
    case intervalLabel
    case cancelButton
    case saveButton
    case resultLabel
    case promptInstructionsLabel
    case bodyGeometryLabel
    case colorAuraLabel
    case accessoryLabel
    case avatarScaleLabel
    case autoSleepLabel
    case testVoiceButton
}
