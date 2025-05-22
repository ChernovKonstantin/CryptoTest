protocol MarketService {
    func getMarketsList() async throws -> MarketListResponse
}
