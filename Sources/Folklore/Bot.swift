import Logging
import NIO

open class Bot {
  private var updater: UpdateMethod? = nil
  private var handler: TelegramEventHandler
  private var commandRegistry: FolkloreCommandRegistry?
  private var usingFramework: Bool
  private var logger: Logger
  var me: TelegramUser = TelegramUser(dummy: true)
  var request: TelegramRequester
  
  public init(
    token: String,
    useFramework: Bool = true,
    usingEventLoopGroup elg: EventLoopGroup? = nil
  ) {
    self.request = TelegramRequester(token: token, eventLoopGroup: elg)
    self.handler = TelegramEventHandler()
    self.logger = Logger(label: "is.lyrical.folklore")
    self.usingFramework = useFramework
    if (self.usingFramework) {
      self.commandRegistry = FolkloreCommandRegistry()
    }
  }
  
  private func preStart() {
    Task {
      guard let me = try? await self.request.getMe() else {
        fatalError("An invalid token was provided to Folklore.")
      }
      self.me = me

      self.logger.info("Logged in as \(self.me.firstName) (@\(self.me.username!))")
    }
    
    if (self.usingFramework) {
      commandRegistry!.registerListener(bot: self)
    }

    self.updater = Poller(bot: self)
  }
  
  public func start() {
    preStart()
    updater!.start()
  }
  
  public func stop() {
    self.updater!.stop()
  }
  
  public func on(command: String, using closure: @escaping (FolkloreCommandContext) -> Void) {
    commandRegistry!.registerCommand(name: command, handler: closure)
  }
  
  public func on(command: String, aliases: [String], using closure: @escaping (FolkloreCommandContext) -> Void) {
    commandRegistry!.registerCommand(name: command, handler: closure, aliases: aliases)
  }
  
  public func on(event: TelegramEvent, using closure: @escaping (Any) -> Void) {
    handler.register(event: event, handler: closure)
  }
  
  internal func handle(_ data: Any, event: TelegramEvent) {
    handler.emit(event: event, data: data)
  }
}