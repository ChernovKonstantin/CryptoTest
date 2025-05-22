import Foundation
@preconcurrency import Combine

actor MarketWebSocketServiceImpl: MarketWebSocketService {
    private var webSocketTask: URLSessionWebSocketTask?
    private let buffer = MarketBuffer()
    nonisolated let subject = PassthroughSubject<[MarketUpdate], Never>()
    
    private var pushTask: Task<Void, Never>?
    private var receiveTask: Task<Void, Never>?
    
    init() {
        guard let url = URL(string: "wss://ws.p2pb2b.com/ws") else { return }
        self.webSocketTask = URLSession.shared.webSocketTask(with: url)
    }

    func connect(markets: [String]) {
        webSocketTask?.resume()
        sendSubscription(for: markets)

        receiveTask = Task {
            await self.receiveLoop()
        }

        pushTask = Task {
            await self.startPushingEvery3Seconds()
        }
    }

    func disconnect() {
        receiveTask?.cancel()
        pushTask?.cancel()
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }

    private func sendSubscription(for markets: [String]) {
        let request: [String: Any] = [
            "method": "state.subscribe",
            "params": markets,
            "id": 1
        ]

        guard let data = try? JSONSerialization.data(withJSONObject: request),
              let string = String(data: data, encoding: .utf8) else {
            return
        }

        webSocketTask?.send(.string(string)) { error in
            if let error = error {
                print("Send error:", error)
            }
        }
    }

    private func receiveLoop() async {
        guard let webSocketTask else { return }

        while !Task.isCancelled {
            do {
                let message = try await webSocketTask.receive()
                await handle(message)
            } catch {
                print("Receive error:", error)
                break
            }
        }
    }

    private func handle(_ message: URLSessionWebSocketTask.Message) async {
        guard case .string(let text) = message,
              let data = text.data(using: .utf8),
              let state = try? JSONDecoder().decode(MarketUpdate.self, from: data) else {
            return
        }
        buffer.update(state)
    }

    private func startPushingEvery3Seconds() async {
        while !Task.isCancelled {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            let values = buffer.values()

            await MainActor.run {
                self.subject.send(values)
            }
        }
    }
}

extension MarketWebSocketServiceImpl {
    class MarketBuffer {
        private var buffer: [String: MarketUpdate] = [:]
        
        func update(_ state: MarketUpdate) {
            buffer[state.market] = state
        }
        
        func values() -> [MarketUpdate] {
            Array(buffer.values)
        }
        
        func clear() {
            buffer.removeAll()
        }
    }
}
