import Foundation
import RealHTTP

final class APIServiceImpl {
    
    private let httpClient: HTTPClient
    private let storage: Storable
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return decoder
    }()
    
    var authHeaders: HTTPHeaders {
        guard let token: String = storage.get(for: .token) else {
            return HTTPHeaders(headers: [])
        }
        
        return HTTPHeaders(
            headers: [
                HTTPHeaders.Element(
                    name: .authorization,
                    value: "Bearer \(token)"
                )
            ]
        )
    }
    
    init(baseURL: URL, storage: Storable) {
        self.httpClient = HTTPClient(baseURL: baseURL)
        self.storage = storage
    }
}

extension APIServiceImpl: APIService {
    
    func fetch<T: APIRequest>(_ convertible: T) async throws -> T.Result {
        let request = convertible.request()
        request.headers = authHeaders
        let response = try await request
            .fetch(httpClient)
        
        if let error = response.error {
            if error.statusCode == .unauthorized {
                // we got error 401
                throw NetworkError.unathorized
            }
        }
        
        guard let data = response.data else {
            throw NetworkError.invalidData
        }
        return try decoder.decode(T.Result.self, from: data)
    }
}

