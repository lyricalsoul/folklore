import Logging
import Foundation
import AsyncHTTPClient
import NIO
import NIOFoundationCompat

public class TelegramRequester {
  private var token: String
  var apiURL: String = "http://api.telegram.org"
  var logger: Logger
  var decoder: JSONDecoder
  var encoder: JSONEncoder
  var httpClient: HTTPClient

  init(token: String, eventLoopGroup: EventLoopGroup? = nil) {
    self.token = token
    self.logger = Logger(label: "is.lyrical.folklore.telegram.requests")
    self.encoder = JSONEncoder()
    self.decoder = JSONDecoder()
    self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    self.httpClient = HTTPClient(eventLoopGroupProvider: eventLoopGroup != nil ? .shared(eventLoopGroup!) : .createNew)
  }
  
  deinit {
    self.logger.info("i'm getting deleted; shutting down the http client")
    try? self.httpClient.syncShutdown()
  }
  
  public func set(apiURL: String) {
    self.apiURL = apiURL
  }
  
  func getUpdates() async throws -> [TelegramUpdate]? {
    return await self.go([TelegramUpdate].self, method: "getUpdates") 
  }
  
  func getUpdates(offset: Double) async throws -> [TelegramUpdate]? {
    return await self.go([TelegramUpdate].self, method: "getUpdates", parameters: ["offset": offset]) 
  }
  
  func getMe() async throws -> TelegramUser? {
    return await self.go(TelegramUser.self, method: "getMe") 
  }
  
  // TODO: Update this to use async/await syntax AS SOON AS POSSIBLE. Gotta wait on AsyncHTTPClient, they still haven't updated their library
  private func go<T : Codable>(_ type: T.Type, method: String, parameters: [String: Any]? = nil) async -> (T?) {
    let url = "\(self.apiURL)/bot\(self.token)/\(method)"
    
    return await withCheckedContinuation { continuation in
      httpClient.execute(request: buildRequest(url: url, parameters: parameters)!).whenComplete { [self] rst in
        switch rst {
        case .failure(let error):
          logger.warning("request failed with: \(error)")
          continuation.resume(returning: nil)
        case .success(let response):
          if response.status == .ok {
            guard let decoded = try? self.decoder.decode(TelegramResponse<T>.self, from: response.body!) else {
              logger.warning("couldn't decode basic telegram response for method \(method)")
              continuation.resume(returning: nil)
              return
            }
            if decoded.ok {
              continuation.resume(returning: decoded.result)
            } else {
              logger.warning("method \(method) failed with error code \(decoded.errorCode ?? -1): \(decoded.description ?? "?")")
              continuation.resume(returning: nil)
            }
          } else {
            logger.warning("method \(method) returned a non-ok http response status: \(response.status)")
            continuation.resume(returning: nil)
          }
        }
      }
    }
  }
  
  private func buildRequest(url: String, parameters: [String: Any]? = nil) -> HTTPClient.Request? {
    guard var request = try? HTTPClient.Request(url: url, method: (parameters != nil ? .POST : .GET)) else {
      return nil
    }
    
    request.headers.add(name: "User-Agent", value: "Folklore (Swift 5.5 and up; Library-like, https://github.com/lyricalsoul/folklore)")
    if let params = parameters {
      request.headers.add(name: "Content-Type", value: "application/json")
      request.body = .string(params.jsonString!)
    }
    
    return request
  }
}