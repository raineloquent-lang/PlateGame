import SwiftUI

struct CollectionView: View {
    @EnvironmentObject var state: GameState
    @Environment(\.dismiss) private var dismiss
    @State private var sortBy: SortMode = .rarity
    @State private var selectedItem: GameState.InventoryItem?
    @State private var showQuickSell = false
    
    enum SortMode { case rarity, date, price }
    
    var sorted: [GameState.InventoryItem] {
        switch sortBy {
        case .rarity:
            return state.inventory.sorted { $0.rarity.rawValue > $1.rarity.rawValue }
        case .date:
            return state.inventory.reversed()
        case .price:
            return state.inventory.sorted { $0.price > $1.price }
        }
    }
    
    var totalValue: Int { state.inventory.reduce(0) { $0 + $1.price } }
    
    var body: some View {
        ZStack {
            Color(white: 0.05)
            
            VStack(spacing: 0) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    
                    Text("Коллекция")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.leading, 4)
                    
                    Spacer()
                    Text("\(state.inventory.count) / \(state.inventoryLimit)")
                        .foregroundColor(Color(white: 0.6))
                }
                .padding(.horizontal)
                .padding(.top, 60)
                .padding(.bottom, 8)
                
                Text("Стоимость коллекции \(totalValue.formatted()) ₽")
                    .font(.system(size: 13))
                    .foregroundColor(Color(white: 0.55))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal)
                
                HStack(spacing: 10) {
                    PillButton(title: "Дата", active: sortBy == .date) { sortBy = .date }
                    PillButton(title: "Цена", active: sortBy == .price) { sortBy = .price }
                    PillButton(title: "Редкость ▼",
                               active: sortBy == .rarity, accent: true) { sortBy = .rarity }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(sorted) { item in
                            CollectionRow(item: item)
                                .onTapGesture { selectedItem = item }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 120)
                }
            }
            
            VStack {
                Spacer()
                HStack(spacing: 8) {
                    BarButton(title: "Выбрать всё") { }
                    BarButton(title: "В сейф") { state.moveAllToSafe() }
                    BarButton(title: "Из сейфа") { state.moveAllFromSafe() }
                    BarButton(title: "Продажа") { showQuickSell = true }
                }
                .padding()
                .padding(.bottom, 30)
                .background(Color(white: 0.08))
            }
        }
        .ignoresSafeArea(.all)
        .sheet(item: $selectedItem) { item in
            PlateDetailView(item: item)
        }
        .sheet(isPresented: $showQuickSell) {
            QuickSellView()
        }
    }
}

// PillButton и BarButton — без изменений
