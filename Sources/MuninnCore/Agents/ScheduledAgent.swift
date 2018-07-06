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

    case dailyAt(Time)

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

extension ScheduledAgent {
    var interval: TimeInterval {
        switch self.schedule {
        case .every1m: return 60
        case .every2m: return 2 * 60
        case .every5m: return 5 * 60
        case .every1d: return 24 * 60 * 60
        case .every2d: return 2 * 24 * 60 * 60
        case .everyMonday: fatalError("handle mondays? wat?")
        case .every(let custom): return custom
        case .dailyAt(let time): fatalError("nooooo")
        }
    }

    func createTimer() -> Timer? {
        #warning("Use a better platform guard here, this should also run on other platforms.")
        if #available(macOS 10.12, *) {
            return Timer(fire: Date().addingTimeInterval(3), interval: 1, repeats: true) { timer in
                console.output(String(describing: timer).consoleText(color: .brightBlack))
            }
        } else {
            console.output("Unfortunately scheduled agents are not supported on this platform.".consoleText(color: .red))
            console.output("\(self.name) will *not* be run on its set schedule.".consoleText(color: .red))
            return nil
        }
    }
}

extension Schedule: CustomStringConvertible {
    var description: String {
        switch self {
        case .every1m: return "every minute"
        case .every2m: return "every two minutes"
        case .every5m: return "every five minutes"
        case .every1d: return "every day at 12am"
        case .every2d: return "every two days at 12am"
        case .everyMonday: return "every monday at 12am"
        case .every(let interval): return "every custom interval: \(interval)"
        case .dailyAt(let time): return "every day at \(time)"
        }
    }
}
