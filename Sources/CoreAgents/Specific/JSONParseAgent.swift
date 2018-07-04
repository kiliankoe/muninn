import Foundation

class JSONParseAgent: ProcessingAgent {
    static var agentName = "JSON Parse Agent"
    static var description = """
    The JSON Parse Agent parses a JSON string and emits the data in a new event.
    `data` is the JSON to parse. Use Liquid templating to specify the JSON string.
    `data_key` sets the key which contains the parsed JSON data in emitted events
    """

    var name: String
    var memory: [String: String] = [:]

    var sources: [EmittingAgent]
    var receivers: [ReceivingAgent]

    typealias JSONHandler = (Data) -> Data?
    var jsonHandler: JSONHandler

    init(name: String, sources: [EmittingAgent], receivers: [ReceivingAgent], jsonHandler: @escaping JSONHandler) {
        self.name = name
        self.sources = sources
        self.receivers = receivers
        self.jsonHandler = jsonHandler
    }

    func process(event: Event) {
        guard let payload = self.jsonHandler(event.payload) else { return }
        let newEvent = Event(source: self, payload: payload)
        for receiver in self.receivers {
            receiver.receive(event: newEvent)
        }
    }
}
