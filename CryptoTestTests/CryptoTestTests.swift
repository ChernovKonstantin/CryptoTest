import Testing
import SwiftUI
@testable import CryptoTest

struct ContentViewModelTests {

    @Test func testInitialFilteredMarketsEmptySearch() {
        let vm = ContentViewModel()
        vm.allMarkets = [
            "BTC/USD": Currency(pairName: "BTC/USD", id: 1, price: "50000", high: "51000", change: "5", low: "49000", volume: "1000", tickSize: "0.01"),
            "ETH/USD": Currency(pairName: "ETH/USD", id: 2, price: "4000", high: "4100", change: "-3", low: "3900", volume: "500", tickSize: "0.01"),
            "LTC/USD": Currency(pairName: "LTC/USD", id: 3, price: "200", high: "220", change: "0", low: "180", volume: "300", tickSize: "0.01")
        ]

        vm.searchText = ""
        #expect(vm.filteredMarkets.count == 3)
    }

    @Test func testFilteredMarketsWithMatchingSearch() {
        let vm = ContentViewModel()
        vm.allMarkets = [
            "BTC/USD": Currency(pairName: "BTC/USD", id: 1, price: "50000", high: "51000", change: "5", low: "49000", volume: "1000", tickSize: "0.01"),
            "ETH/USD": Currency(pairName: "ETH/USD", id: 2, price: "4000", high: "4100", change: "-3", low: "3900", volume: "500", tickSize: "0.01"),
            "LTC/USD": Currency(pairName: "LTC/USD", id: 3, price: "200", high: "220", change: "0", low: "180", volume: "300", tickSize: "0.01")
        ]

        vm.searchText = "ETH"
        #expect(vm.filteredMarkets.count == 1)
        #expect(vm.filteredMarkets.first?.key == "ETH/USD")
    }

    @Test func testFilteredMarketsWithNoMatch() {
        let vm = ContentViewModel()
        vm.allMarkets = [
            "BTC/USD": Currency(pairName: "BTC/USD", id: 1, price: "50000", high: "51000", change: "5", low: "49000", volume: "1000", tickSize: "0.01"),
            "ETH/USD": Currency(pairName: "ETH/USD", id: 2, price: "4000", high: "4100", change: "-3", low: "3900", volume: "500", tickSize: "0.01"),
            "LTC/USD": Currency(pairName: "LTC/USD", id: 3, price: "200", high: "220", change: "0", low: "180", volume: "300", tickSize: "0.01")
        ]

        vm.searchText = "XYZ"
        #expect(vm.filteredMarkets.isEmpty)
    }

    @Test func testFormatNumberStringThousands() {
        let vm = ContentViewModel()
        let formatted = vm.formatNumberString("123321.00")
        #expect(formatted == "123.32T")
    }

    @Test func testFormatNumberStringMillions() {
        let vm = ContentViewModel()
        let formatted = vm.formatNumberString("123321123")
        #expect(formatted == "123.32M")
    }

    @Test func testFormatNumberStringBelowThousand() {
        let vm = ContentViewModel()
        let formatted = vm.formatNumberString("999")
        #expect(formatted == "999")
    }

    @Test func testFormatSmallDecimalString() {
        let vm = ContentViewModel()
        let original = "0.000000000189"
        let formatted = vm.formatSmallDecimalString(original)
        #expect(formatted == "0.000 000 000 189")
    }

    @Test func testGetChangeBackColorPositive() {
        let vm = ContentViewModel()
        let color = vm.getChangeBackColor("5")
        #expect(color == Color.green)
    }

    @Test func testGetChangeBackColorNegative() {
        let vm = ContentViewModel()
        let color = vm.getChangeBackColor("-3")
        #expect(color == Color.red)
    }

    @Test func testGetChangeBackColorZero() {
        let vm = ContentViewModel()
        let color = vm.getChangeBackColor("0")
        #expect(color == Color.gray)
    }

    @Test func testGetChangeBackColorInvalidString() {
        let vm = ContentViewModel()
        let color = vm.getChangeBackColor("abc")
        #expect(color == Color.gray)
    }
}
