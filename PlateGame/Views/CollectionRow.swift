import SwiftUI

struct CollectionRow: View {
    let item: GameState.InventoryItem
    
    var body: some View {
        let rarity = item.rarity
        
        HStack(spacing: 12) {
            HStack(spacing: 0) {
                HStack(spacing: 2) {
                    Text(item.plate.letter1)
                    Text(item.plate.digits)
                    Text(item.plate.letter2 + item.plate.letter3)
                }
                .font(.system(size: 22, weight: .black))
                .foregroundColor(.black)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                
                VStack(spacing: 0) {
                    Text(item.plate.region)
                        .font(.system(size: 16, weight: .black))
                    Text("RUS").font(.system(size: 7, weight: .bold))
                }
                .foregroundColor(.black)
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .overlay(
                    Rectangle().frame(width: 1)
                        .foregroundColor(.black.opacity(0.6)),
                    alignment: .leading
                )
            }
            .background(Color(white: 0.88))
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .overlay(RoundedRectangle(cornerRadius: 4)
                        .stroke(Color(white: 0.5), lineWidth: 1.5))
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 4) {
                    if item.inSafe {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.orange)
                    }
                    Text("Россия · Гражданский")
                        .font(.system(size: 11))
                        .foregroundColor(Color(white: 0.55))
                }
                
                HStack(spacing: 3) {
                    ForEach(0..<5, id: \.self) { i in
                        Capsule()
                            .fill(i < rarity.bars ? rarity.color : Color.white.opacity(0.15))
                            .frame(width: 12, height: 3)
                    }
                }
                
                Text("\(item.price.formatted()) ₽")
                    .font(.system(size: 16, weight: .bold))
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