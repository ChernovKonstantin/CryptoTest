final class MockMarketService: MarketService {
    
    var isGetMarketsSuccessful: Bool = false
    
    func getMarketsList() async throws -> MarketListResponse {
        if isGetMarketsSuccessful {
            return MarketListResponse(response: Response(marketList: [Market(name: "test")], currencies: ["test":Currency(pairName: "test0/test1", id: 123, price: "10", high: "11", change: "11", low: "11", volume: "11", tickSize: "1")]))
        } else {
            throw NetworkError.invalidData
        }
    }
}
