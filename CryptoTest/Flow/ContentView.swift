import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ContentViewModel
    
    var body: some View {
        VStack {
            if viewModel.allMarkets.isEmpty {
                ProgressView()
                    .scaleEffect(2)
            } else {
                NavigationView {
                    List {
                        ForEach(viewModel.filteredMarkets.sorted(by: >), id: \.key) { key, value in
                            containerView(for: value)
                                .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                    .searchable(text: $viewModel.searchText)
                }
            }
        }
        .onAppear {
            viewModel.start()
        }
    }
    
    @ViewBuilder private func containerView(for currency: Currency) -> some View {
        HStack {
            nameView(for: currency)
            Spacer()
            priceView(for: currency)
            changeView(for: currency)
        }
    }
    
    @ViewBuilder private func nameView(for currency: Currency) -> some View {
        let customName = viewModel.customizePairName(for: currency.pairName)
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                DefaultText(text: customName.0, color: .black).bold()
                DefaultText(text: "/" + customName.1, color: .gray)
            }
            DefaultText(text: "Vol " + viewModel.formatNumberString(currency.volume), color: .gray)
        }
    }
    
    @ViewBuilder private func priceView(for currency: Currency) -> some View {
        VStack(alignment: .trailing) {
            DefaultText(text: viewModel.formatSmallDecimalString(currency.tickSize), color: .black)
                .bold()
            DefaultText(text: "$" + currency.price, color: .gray)
        }
    }
    
    @ViewBuilder private func changeView(for currency: Currency) -> some View {
        ZStack {
            viewModel.getChangeBackColor(currency.change)
                .clipShape(.rect(cornerRadius: 12))
            DefaultText(text: currency.change + "%", color: .black)
        }
        .frame(width: 90, height: 50)
    }
}

#Preview {
    ContentView(viewModel: ContentViewModel())
}
