import Foundation

class WeatherAgent: ScheduledAgent {
    static var agentName = "Weather Agent"
    static var description = """
    The Weather Agent creates an event for the day’s weather at a given `location`.
    """

    var name: String
    var memory: [String: String] = [:]

    var receivers: [ReceivingAgent] = []

    static var defaultSchedule = Schedule.every1d
    var schedule: Schedule

    enum Location {
        case string(String)
        case coordinate(Double, Double)
    }

    var location: Location

    enum Service {
        case wunderground(apiKey: String)
        case darksky(apiKey: String)
    }

    var service: Service

    init(name: String, schedule: Schedule, receivers: [ReceivingAgent], location: Location, service: Service) {
        self.name = name
        self.schedule = schedule
        self.receivers = receivers
        self.location = location
        self.service = service
    }

    required init?(from config: YamlAgent) {
        self.name = config.name

        guard let schedule = Schedule(from: config.schedule ?? "") else {
            print("unknown schedule value for \(self.name): \(config.schedule ?? "")")
            return nil
        }
        self.schedule = schedule

        guard let options = config.options else {
            print("missing options for \(self.name).")
            return nil
        }

        if let location = options["location"]?.value as? String {
            self.location = .string(location)
        } else if let location = options["location"]?.value as? [Double] {
            self.location = .coordinate(location[0], location[1])
        } else {
            print("unknown location value for \(self.name): \(options["location"])")
            return nil
        }

        guard let service = options["service"]?.value as? String,
            let apiKey = options["api_key"]?.value as? String else {
                print("missing service or api_key for \(self.name)")
                return nil
        }
        switch service {
        case "darksky":
            self.service = Service.darksky(apiKey: apiKey)
        case "wunderground":
            self.service = Service.wunderground(apiKey: apiKey)
        default:
            print("unknown service for \(self.name): \(service). Expected `darksky` or `wunderground`.")
            return nil
        }
    }

    func emit() {
        #warning("TODO: Fetch weather data (ideally support darksky & wunderground)")

        print("Fetching fake weather data")
        sleep(1)

        let rawPayload = [
            "fake": "data"
        ]
        guard let payload = try? JSONEncoder().encode(rawPayload) else { return }

        let event = Event(source: self, payload: payload)

        for receiver in self.receivers {
            receiver.receive(event: event)
        }
    }
}
