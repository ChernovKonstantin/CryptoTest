import Foundation

final class APIServiceImpl {
    
    private let baseURL: URL 
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
}

extension APIServiceImpl: APIService {
    
    func fetch<T: APIRequest>(_ convertible: T) async throws -> T.Result {
        let request = try makeURLRequest(from: convertible)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            do {
                return try decoder.decode(T.Result.self, from: data)
            } catch {
                throw NetworkError.invalidData
            }
        case 401:
            throw NetworkError.unathorized
        default:
            throw NetworkError.invalidStatusCode(httpResponse.statusCode)
        }
    }
    
    private func makeURLRequest<T: APIRequest>(from convertible: T) throws -> URLRequest {
        let endpoint = convertible.endpoint
        guard let url = URL(string: endpoint, relativeTo: baseURL) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = convertible.method.rawValue
        
        if let body = convertible.body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
}
