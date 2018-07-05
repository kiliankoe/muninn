protocol Agent {
    static var agentName: String { get }
    static var description: String { get }

    var name: String { get }
    var memory: [String: String] { get set }

    init?(from config: YamlAgent)
}

// An agent that can receive events.
protocol ReceivingAgent: Agent {
    // used for transparent runtime documentation, events are not polled from sources, but pushed here.
    var sources: [EmittingAgent] { get }

    /// Receive an event from a source. This is called by the source itself.
    ///
    /// - Parameter event: an event
    func receive(event: Event)
}

/// An agent that can produce events.
///
/// These are mostly also `ScheduledAgent`s, but don't necessarily have to be. Possible other `EmittingAgent`s are
/// those triggered by webhooks, stream events (e.g. Twitter) or manually.
protocol EmittingAgent: Agent {
    var receivers: [ReceivingAgent] { get }

    /// Emit events and push these downstream to all receivers.
    ///
    /// It depends on the specific agent implementation where and when this function is called. For `ScheduledAgent`s
    /// this is done by the scheduler.
    func emit()
}

/// An agent that directly processes incoming events optionally producing new events.
protocol ProcessingAgent: Agent {
    var sources: [EmittingAgent] { get }
    var receivers: [ReceivingAgent] { get }

    /// Receive an event, process it and optionally emit new events to `receivers`.
    ///
    /// - Parameter event: an event
    func process(event: Event)
}
