import Foundation
import Yams
import Console

let console = Terminal()

public class Muninn {
    public static let shared = Muninn()
    public init() {}

    struct Scenario {
        var name: String
        var agents: [Agent]
    }

    var scenarios = [Scenario]()

    func readScenarios() {
        let scenariosDir = try! FileManager.default.contentsOfDirectory(atPath: "./scenarios")
        for file in scenariosDir {
            guard file.contains(".yml") || file.contains(".yaml") else { continue }

            let configScenarioHandle = try! FileHandle(forReadingFrom: URL(string: "./scenarios/\(file)")!)
            let configScenarioStr = String(data: configScenarioHandle.readDataToEndOfFile(), encoding: .utf8)
            let configScenario = try! YAMLDecoder().decode(YamlScenario.self, from: configScenarioStr!)

            let agents = configScenario.agents.compactMap { $0.parse() }

            // Configure specified receivers
            for agent in agents where agent is EmittingAgent {
                var agent = agent as! EmittingAgent

                guard let wantedReceivers = configScenario.agents.first(where: { $0.name == agent.name })!.receivers else {
                    continue
                }

                // TODO: Validate that receivers exist and every agent can be reached.

                let receivers = wantedReceivers
                    .compactMap { agentName in return agents.first(where: { $0.name == agentName })}
                    .filter { $0 is ReceivingAgent } // TODO: specifying non-receiving agents should be output as an error

                agent.receivers = receivers as! [ReceivingAgent]
            }

            let name = file
                .replacingOccurrences(of: ".yml", with: "")
                .replacingOccurrences(of: ".yaml", with: "")

            let scenario = Scenario(name: name, agents: agents)
            self.scenarios.append(scenario)
        }
    }

    public func run() {
        self.readScenarios()

        // TODO: Improve output, ideally to show receiver relationships.
        // Initial agents are all EmittingAgents
        for scenario in self.scenarios {
            console.output("Scenario \(scenario.name) found:".consoleText(color: .magenta, isBold: true))
            for agent in scenario.agents {
                print(" - \(agent.name)")
            }
        }

        let scheduledAgents = self.scenarios
            .flatMap { $0.agents }
            .filter { $0 is ScheduledAgent } as! [ScheduledAgent]

        Scheduler.shared.schedule(agents: scheduledAgents)

        console.output("Running...".consoleText(color: .brightCyan, isBold: true))

        RunLoop.main.run(until: .distantFuture)
    }
}
