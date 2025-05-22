struct MarketListResponse: Codable {
    let response: Response
}

struct Response: Codable {
    let marketList: [Market]
    let currencies: [String: Currency]
}

struct Market: Codable, Hashable {
    let name: String
}

struct Currency: Codable, Comparable {
    static func < (lhs: Currency, rhs: Currency) -> Bool {
        lhs.id < rhs.id
    }
    
    let pairName: String
    let id: Int
    var price: String
    let high: String
    var change: String
    let low: String
    var volume: String
    let tickSize: String
}
