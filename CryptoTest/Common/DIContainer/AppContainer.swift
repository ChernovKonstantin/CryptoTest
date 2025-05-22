import Foundation
import Factory

extension Container {
    var apiService: Factory<APIService> {
        Factory(self) {
            APIServiceImpl(baseURL: URL(string: "https://p2pb2b.com") ?? URL(fileURLWithPath: ""))
        }
    }

    var marketService: Factory<MarketService> {
        Factory(self) {
            MarketServiceImpl(apiService: Container.shared.apiService())
        }
    }

    var webSockeService: Factory<MarketWebSocketService> {
        Factory(self) {
            MarketWebSocketServiceImpl()
        }
    }
}
