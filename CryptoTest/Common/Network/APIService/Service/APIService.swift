import Foundation

protocol APIRequest {
    associatedtype Result: Decodable

    var endpoint: String { get }
    var method: HTTPMethod { get }
    var body: [String: Any]? { get }
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
