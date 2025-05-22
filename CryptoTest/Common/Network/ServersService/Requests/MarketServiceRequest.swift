enum MarketServiceRequest {
    
    struct ServersList: APIRequest {
        typealias Result = MarketListResponse
        
        
        var endpoint: String { "/v2/market-list/new" }
        var method: HTTPMethod { .get }
        var body: [String: Any]? { nil }
    }
}
