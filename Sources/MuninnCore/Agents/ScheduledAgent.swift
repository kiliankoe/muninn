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

    init?(from value: String) {
        switch value {
        case "every_1m": self = .every1m
        case "every_2m": self = .every2m
        case "every_5m": self = .every5m
        case "every_1d": self = .every1d
        case "every_2d": self = .every2d
        case "every_monday": self = .everyMonday
        default: return nil
        }
    }
}

/// An agent that runs on a schedule and produces events.
protocol ScheduledAgent: EmittingAgent {
    static var defaultSchedule: Schedule { get }
    var schedule: Schedule { get }
}
