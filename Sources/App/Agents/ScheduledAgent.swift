import Foundation

enum Time {
    case oneAM, twoAM, threeAM // ...
}

enum Schedule {
    case every1m
    case every2m
    case every5m
    // ...
    case every1d
    case every2d
    case everyMonday
    case every(TimeInterval)

    case at(Time)
}

/// An agent that runs on a schedule and produces events.
protocol ScheduledAgent: EmittingAgent {
    static var defaultSchedule: Schedule { get }
    var schedule: Schedule { get }
}
