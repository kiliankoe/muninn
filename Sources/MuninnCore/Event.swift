import Foundation

struct Event {
    var source: Agent
    var createdAt: Date
    var payload: Data

    init(source: Agent, payload: Data) {
        self.source = source
        self.payload = payload
        self.createdAt = Date()
    }

    var payloadDict: [String: Any] {
        guard let decoded = try? JSONSerialization.jsonObject(with: self.payload) else {
            print("Failed to decode event payload as JSON.")
            return [:]
        }
        guard let dict = decoded as? [String: Any] else {
            print("Failed to decode event payload as instance of Dictionary<String, Any>.")
            return [:]
        }
        return dict
    }
}
