import Foundation
import RealHTTP

public typealias NetworkRequest = HTTPRequest

protocol APIRequest {

    associatedtype Result: Codable

    func request() -> HTTPRequest
}

protocol APIService: AnyObject {

    func fetch<T: APIRequest>(_ convertible: T) async throws -> T.Result
}

extension APIRequest {

    var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }
}
