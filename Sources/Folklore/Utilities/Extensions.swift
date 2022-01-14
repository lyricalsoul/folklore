import Foundation

extension Dictionary where Key == String, Value == Any {
  var jsonString: String? {
    guard let data = try? JSONSerialization.data(withJSONObject: self) else {
      return nil
    }
    return String(data: data, encoding: .utf8)
  }

  func cast<T: Decodable>() -> T? {
    guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else { return nil }
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    return try? decoder.decode(T.self, from: data)
  }
}