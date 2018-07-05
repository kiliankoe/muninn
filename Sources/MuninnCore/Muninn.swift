import Foundation
import Yams

public class Muninn {
    struct Scenario {
        var agents: [Agent]
    }

    var scenarios = [Scenario]()

    func readScenarios() {
        let scenariosDir = try! FileManager.default.contentsOfDirectory(atPath: "./scenarios")
        for file in scenariosDir {
            let yamlScenarioHandle = try! FileHandle(forReadingFrom: URL(string: "./scenarios/\(file)")!)
            let yamlScenarioStr = String(data: yamlScenarioHandle.readDataToEndOfFile(), encoding: .utf8)
            let yamlScenario = try! YAMLDecoder().decode(YamlScenario.self, from: yamlScenarioStr!)

            let agents = yamlScenario.agents.compactMap { $0.parse() }
            let scenario = Scenario(agents: agents)
            self.scenarios.append(scenario)
        }
    }

    public func run() {
        self.readScenarios()

        for scenario in self.scenarios {
            for agent in scenario.agents {
                print(agent)
            }
        }
    }

    public init() {}
}

