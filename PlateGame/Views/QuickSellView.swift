import SwiftUI

struct QuickSellView: View {
    @EnvironmentObject var state: GameState
    @Environment(\.dismiss) private var dismiss
    
    @State private var raritySelection: Set<Rarity> = []
    
    var filtered: [GameState.InventoryItem] {
        state.inventory.filter { item in
            raritySelection.isEmpty || raritySelection.contains(item.rarity)
        }
    }
    
    var sellable: [GameState.InventoryItem] {
        filtered.filter { !$0.inSafe }
    }
    
    var totalPrice: Int {
        sellable.reduce(0) { $0 + state.sellPrice(for: $1) }
    }
    
    var body: some View {
        ZStack {
            Color(white: 0.08).ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Быстрая продажа")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Выбери, что продать. Если в строке ничего не выбрано — подходит любое.")
                    .font(.system(size: 13))
                    .foregroundColor(Color(white: 0.55))
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Редкость").foregroundColor(Color(white: 0.6))
                    HStack(spacing: 4) {
                        ForEach(Rarity.allCases, id: \.self) { rarity in
                            RarityChip(
                                rarity: rarity,
                                count: state.inventory.filter { $0.rarity == rarity }.count,
                                selected: raritySelection.contains(rarity)
                            ) {
                                if raritySelection.contains(rarity) {
                                    raritySelection.remove(rarity)
                                } else {
                                    raritySelection.insert(rarity)
                                }
                            }
                        }
                    }
                }
                
                HStack {
                    Text("На продажу: \(sellable.count)")
                        .foregroundColor(.white)
                    Spacer()
                }
                
                HStack {
                    Text("Цена —").foregroundColor(Color(white: 0.6))
                    Text("\(totalPrice.formatted()) ₽")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                HStack(spacing: 10) {
                    Button("Сбросить") { raritySelection.removeAll() }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(white: 0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    
                    Button("Продать") {
                        for item in sellable { state.sell(item) }
                        dismiss()
                    }
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(red: 0.85, green: 0.25, blue: 0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }
            .padding(20)
        }
    }
}

struct RarityChip: View {
    let rarity: Rarity
    let count: Int
    let selected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Capsule()
                    .fill(rarity.color)
                    .frame(height: 6)
                Text("\(count)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(8)
            .background(selected ? rarity.color.opacity(0.3) : Color(white: 0.12))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(selected ? rarity.color : Color.clear, lineWidth: 2)
            )
        }
    }
}