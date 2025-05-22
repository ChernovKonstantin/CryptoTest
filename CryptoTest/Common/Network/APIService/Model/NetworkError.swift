enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case invalidStatusCode(Int)
    case unathorized
}
