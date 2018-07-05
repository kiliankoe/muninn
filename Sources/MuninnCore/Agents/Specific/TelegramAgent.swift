import Foundation

/// The Telegram Agent receives and collects events and sends them via [Telegram](https://telegram.org/).
class TelegramAgent: ReceivingAgent {
    static var agentName = "Telegram Agent"

    var name: String
    var memory: [String: String] = [:]

    var authToken: String
    var chatId: String

    typealias MessageConfigHandler = ([String: String]) -> [String: String]
    var messageConfigHandler: MessageConfigHandler

    init(name: String,
         authToken: String,
         chatId: String,
         messageConfigHandler: @escaping MessageConfigHandler) {
        self.name = name
        self.authToken = authToken
        self.chatId = chatId
        self.messageConfigHandler = messageConfigHandler
    }

    required init?(from config: YamlAgent) {
        self.name = config.name
        #warning("TODO")
        self.authToken = ""
        self.chatId = ""
        self.messageConfigHandler = { message in return message }
    }

    func receive(event: Event) {
        #warning("TODO: Connect to Telegram Bot API")

        print("Telegram agent received:", event.payloadDict)
        _ = self.messageConfigHandler(event.payloadDict as! [String: String])
    }
}
