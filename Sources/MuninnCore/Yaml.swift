import AnyCodable

struct YamlScenario: Decodable {
    var agents: [YamlAgent]
}

struct YamlAgent: Decodable {
    var name: String
    var type: String
    var schedule: String?
    var receivers: [String]?
    var options: [String: AnyDecodable]?

    func parse() -> Agent? {
        switch type {
        case "weather_agent":
            return WeatherAgent(from: self)
        case "telegram_agent":
            return TelegramAgent(from: self)
//        case "json_parse_agent":
//            return JSONParseAgent(from: self)
        default:
            print("Invalid agent name `\(type)`")
            return nil
        }
    }
}
