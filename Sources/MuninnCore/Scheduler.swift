import Foundation

class Scheduler {
    static let shared = Scheduler()

    func schedule(agents: [ScheduledAgent]) {
        for agent in agents {
            guard let timer = agent.createTimer() else { continue }
            RunLoop.main.add(timer, forMode: .commonModes)
            console.output("Scheduled \(agent.name) to run \(agent.schedule).".consoleText(color: .magenta, isBold: true))
        }
    }
}
