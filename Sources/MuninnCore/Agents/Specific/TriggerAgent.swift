/// The Trigger Agent will watch for a specific value in an Event payload.
class TriggerAgent: ProcessingAgent {
    static var agentName = "Trigger Agent"

    var name: String
    var memory: [String: String] = [:]

    var receivers: [ReceivingAgent]

    required init?(from config: YamlAgent) {
        self.name = config.name
        self.receivers = []
    }

    func receive(event: Event) {
        print("running empty placeholder trigger agent")
        for receiver in self.receivers {
            receiver.receive(event: event)
        }
    }

    func emit() {
        assert(false, "`emit()` should not be called for a `ProcessingAgent`.")
    }
}

extension TriggerAgent {
    struct Rule {
        enum Kind {
            case regex
        }

        var kind: Kind
        var value: String
        var path: String
    }
}
