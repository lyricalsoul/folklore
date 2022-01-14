public struct FolkloreCommandContext {
  let message: TelegramMessage
  let args: [String]
  var author: TelegramUser? {
    return message.from
  }
  var chat: TelegramChat {
    return message.chat
  }
  
  public func reply(with text: String) {
    print("replied with \(text)")
  }
}