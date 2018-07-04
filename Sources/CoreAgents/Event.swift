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
}
