import Combine

protocol MarketWebSocketService {
    func connect(markets: [String]) async
    var subject: PassthroughSubject<[MarketUpdate], Never> { get }
}
