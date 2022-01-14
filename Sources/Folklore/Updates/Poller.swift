class Poller : UpdateMethod {
  var lastUpdate: Double = 0
  init(bot: Bot) {
    super.init(bot: bot, label: "is.lyrical.folklore.updates.poller")
  }
  
  override func getUpdates() async {
    if var updates = try? await self.bot.request.getUpdates(offset: lastUpdate + 1) {
      if (updates.isEmpty) { return }
      updates.sort { $1.updateId < $0.updateId }
      self.lastUpdate = updates.last!.updateId
      
      updates.forEach {
        if let msg = $0.message { self.bot.handle(msg, event: .newMessage) }
      }
      print("last update id is \(lastUpdate)")
    }
  }
}