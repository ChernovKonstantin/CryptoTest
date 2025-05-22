final class MarketServiceImpl: MarketService {
    
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func getMarketsList() async throws -> MarketListResponse {
        try await apiService.fetch(
            ServersServiceRequests.ServersList()
        )
        
    }
}
