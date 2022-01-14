struct TelegramUser : Codable {
  var id: Double
  var isBot: Bool
  var firstName: String
  var lastName: String?
  var username: String?
  var languageCode: String?
  
  public init(dummy: Bool) {
    self.id = -1.0
    self.isBot = true
    self.firstName = "Telegram"
  }
}