import Foundation

class WeatherAgent: ScheduledAgent {
    static var agentName = "Weather Agent"
    static var description = """
    The Weather Agent creates an event for the day’s weather at a given `location`.
    """

    var name: String
    var memory: [String: String] = [:]

    var receivers: [ReceivingAgent]

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

    func emit() {
        #warning("TODO: Fetch weather data (ideally support darksky & wunderground)")

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
