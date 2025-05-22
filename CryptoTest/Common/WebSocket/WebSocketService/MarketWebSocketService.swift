import Combine

protocol MarketWebSocketServiceProtocol {
    func connect(markets: [String])
    func disconnect()
    var marketPublisher: AnyPublisher<[MarketState], Never> { get }
}
