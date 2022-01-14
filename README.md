# Folklore

[WIP] A swifty Telegram framework 

```swift
import Folklore

let bot = Bot(token: "Your token here")
bot.on(command: "ping") { ctx in
  ctx.reply(with: "pooong! 🏓")
}

bot.start()
```