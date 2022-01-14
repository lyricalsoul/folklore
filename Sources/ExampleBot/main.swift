import Folklore
import Foundation

let bot = Bot(token: ProcessInfo.processInfo.environment["TELEGRAM_TOKEN"]!)
bot.on(command: "ping") { ctx in
  ctx.reply(with: "pooong! 🏓")
}

bot.start()