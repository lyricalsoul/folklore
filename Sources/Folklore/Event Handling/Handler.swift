class TelegramEventHandler {
  // TODO: Add methods to remove listeners. Very easy but don't feel like doin it rn!
  private var registeredEventListeners: [(TelegramEvent, (Any) -> Void)] = []
  
  func register(event: TelegramEvent, handler: @escaping (Any) -> Void) {
    registeredEventListeners.append((event, handler))
  }
  
  func emit(event: TelegramEvent, data: Any) {
    registeredEventListeners.filter { $0.0 == event }.forEach { $0.1(data) }
  }
} 