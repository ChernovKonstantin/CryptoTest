struct MarketUpdate: Decodable {
    let method: String
    let market: String
    let state: MarketState
    let id: Int?

    private enum CodingKeys: String, CodingKey {
        case method, params, id
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.method = try container.decode(String.self, forKey: .method)
        self.id = try? container.decode(Int.self, forKey: .id)

        var params = try container.nestedUnkeyedContainer(forKey: .params)

        self.market = try params.decode(String.self)
        self.state = try params.decode(MarketState.self)
    }
}

struct MarketState: Codable {
    let last: String
    let volume: String
    let open: String
}
