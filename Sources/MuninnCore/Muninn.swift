import Foundation
import Yams

public class Muninn {
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

                let receivers = wantedReceivers
                    .compactMap { agentName in return agents.first(where: { $0.name == agentName })}
                    .filter { $0 is ReceivingAgent }

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

        for scenario in self.scenarios {
            print("Created scenario '\(scenario.name)' with the following agents:")
            for agent in scenario.agents {
                print(" - \(agent.name)")
            }
        }
    }

    public init() {}
}
