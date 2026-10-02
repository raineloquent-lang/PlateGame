import SwiftUI

struct CollectionRow: View {
    let item: GameState.InventoryItem
    
    var body: some View {
        let rarity = item.rarity
        
        HStack(spacing: 10) {
            // Мини-номер
            PlateView(plate: item.plate, compact: true)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 3) {
                HStack(spacing: 4) {
                    if item.inSafe {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 9))
                            .foregroundColor(.orange)
                    }
                    Text("Россия · Гражданский")
                        .font(.system(size: 10))
                        .foregroundColor(Color(white: 0.55))
                        .lineLimit(1)
                }
                
                HStack(spacing: 3) {
                    ForEach(0..<5, id: \.self) { i in
                        Capsule()
                            .fill(i < rarity.bars ? rarity.color : Color.white.opacity(0.15))
                            .frame(width: 10, height: 3)
                    }
                }
                
                Text("\(item.price.formatted()) ₽")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(rarity.color)
            }
        }
        .padding(10)
        .background(
            LinearGradient(
                colors: [rarity.color.opacity(0.25), rarity.color.opacity(0.05)],
                startPoint: .leading, endPoint: .trailing
            )
        )
        .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(rarity.color.opacity(0.4), lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
