/*
enum TelegramChatType : String, Decodable, CodingKey { 
  case dm = "private"
  case superGroup = "supergroup"
  case group
  case channel
}
*/
// TODO: Bring back TelegramChatType

struct TelegramChat : Codable {
  var id: Double
  var title: String?
  var type: String
  var firstName: String?
  var lastName: String?
  var username: String?
}
