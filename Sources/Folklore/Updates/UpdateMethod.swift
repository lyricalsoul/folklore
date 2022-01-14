import Foundation
import Logging

class UpdateMethod {
  var bot: Bot
  var logger: Logger
  private var shouldStop: Bool = false

  init(bot: Bot, label: String) {
    self.bot = bot
    self.logger = Logger(label: label)
  }
  
  func start() {
    while !shouldStop {
      if self.bot.me.id != -1.0 {
        Task.init {
          await self.getUpdates()
        }
      }
    }
  }
  
  func getUpdates() async {
    self.logger.error("Please implement the getUpdates() method")
  }
  
  func stop() {
    self.shouldStop = true
  }
}