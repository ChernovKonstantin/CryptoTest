import Combine


final class MockMarketWebSocketService: MarketWebSocketService {
    func connect(markets: [String]) async { }
    
    var subject = PassthroughSubject<[MarketUpdate], Never>()
}
