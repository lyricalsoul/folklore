class FolkloreCommandRegistry {
  private var registered: [FolkloreCommand] = []
  
  func registerCommand(name: String, handler: @escaping (FolkloreCommandContext) -> Void, aliases: [String] = []) {
    self.registered.append(FolkloreCommand(name: name, aliases: aliases, handler: handler))
  }
  
  func registerListener(bot: Bot) {
    bot.on(event: .newMessage) { [self] data in
      let msg = data as! TelegramMessage
      if (!msg.text.hasPrefix("/") || msg.from!.isBot) { return }
      
      var args = msg.text.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ")
      var command = args.remove(at: 0)
      if (command.contains("@") && !command.contains("@\(bot.me.username!)")) { return }
      command = command.replacingOccurrences(of: "/", with: "").components(separatedBy: "@").first!.lowercased()
      
      if let cmd = getCommandBy(name: command) {
        let ctx = FolkloreCommandContext(message: msg, args: args)
        print(ctx)
        cmd.handler(ctx)
      }
    }
  }
  
  func getCommandBy(name: String) -> FolkloreCommand? {
    return self.registered.filter { $0.name == name || $0.aliases.contains(name) }.first
  }
}