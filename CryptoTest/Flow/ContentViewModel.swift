import Combine
import SwiftUI
import Factory
import Foundation

class ContentViewModel: ObservableObject {
    @Injected(\.serversService) private var serversService: MarketService
    @Injected(\.webSockeService) private var webSockeService: MarketWebSocketService
    
    @Published var searchText: String = ""
    @Published var allMarkets: [String: Currency] = [:]
    
    private var cancellables = Set<AnyCancellable>()
    
    var filteredMarkets: [String: Currency]  {
        if searchText.isEmpty {
            return allMarkets
        } else {
            return allMarkets.filter { $0.value.pairName.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    init() {
        setupBindings()
    }
    
    @MainActor
    func start() {
        Task {
            do {
                let newMarkets = try await serversService.getMarketsList().response
                self.allMarkets = newMarkets.currencies
                let marketsList = newMarkets.marketList.compactMap {
                    $0.name
                }
                await webSockeService.connect(markets: marketsList)
            } catch {
                print(error)
            }
        }
    }
    
    func customizePairName(for name: String) -> (String, String) {
        let parts = name.components(separatedBy: "/")
        let first = parts.first ?? ""
        let second = parts.dropFirst().joined(separator: "/")
        return (first, second)
    }
    
    func formatNumberString(_ str: String) -> String {
        guard let value = Double(str) else {
            return str
        }
        
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.numberStyle = .decimal
        
        if value >= 1_000_000 {
            let millions = value / 1_000_000
            let formatted = formatter.string(from: NSNumber(value: millions)) ?? "\(millions)"
            return "\(formatted)M"
        } else if value >= 1_000 {
            let thousands = value / 1_000
            let formatted = formatter.string(from: NSNumber(value: thousands)) ?? "\(thousands)"
            return "\(formatted)T"
        } else {
            let formatted = formatter.string(from: NSNumber(value: value)) ?? "\(value)"
            return formatted
        }
    }
    
    func formatSmallDecimalString(_ str: String) -> String {
        let parts = str.prefix(14).split(separator: ".", omittingEmptySubsequences: false)
        
        guard parts.count == 2 else {
            return str
        }
        
        let integerPart = String(parts[0])
        let fractionalPart = String(parts[1])
        
        var groupedFractional = ""
        for (index, char) in fractionalPart.enumerated() {
            if index > 0 && index % 3 == 0 {
                groupedFractional.append(" ")
            }
            groupedFractional.append(char)
        }
        
        return integerPart + "." + groupedFractional
    }
    
    func getChangeBackColor(_ str: String) -> Color {
        if str.contains("-") {
            return .red
        } else {
            guard let value = Double(str) else { return .gray }
                return value > 0 ? .green : .gray
        }
    }
    
    private func setupBindings() {
        let publisher = webSockeService.subject.eraseToAnyPublisher()
        publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] markets in
                guard let self else { return }
                for market in markets {
                    var temp = self.allMarkets[market.market]
                    temp?.price = market.state.last
                    temp?.volume = market.state.volume
                    if let lastPrice = Double(market.state.last), let openPrice = Double(market.state.open) {
                        temp?.change = String(format: "%.2f", lastPrice/openPrice*100-100)
                    }
                    self.allMarkets[market.market] = temp
                }
            })
            .store(in: &cancellables)
    }
}
