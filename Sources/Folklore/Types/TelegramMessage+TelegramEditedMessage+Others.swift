struct TelegramMessage : Codable {
  var date: Double
  var text: String
  var messageId: Double
  var chat: TelegramChat
  var from: TelegramUser?
}