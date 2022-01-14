struct TelegramUpdate : Codable {
  var updateId: Double
  var message: TelegramMessage?
}