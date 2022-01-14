struct TelegramResponse<T : Codable> : Codable {
  var ok: Bool
  var result: T?
  var description: String?
  var errorCode: Int?
}