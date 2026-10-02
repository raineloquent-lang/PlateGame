import SwiftUI

struct RarityBar: View {
    let rarity: Rarity
    let price: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(rarity.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(rarity.color)
                HStack(spacing: 4) {
                    ForEach(0..<5, id: \.self) { i in
                        Capsule()
                            .fill(i < rarity.bars ? rarity.color : Color.white.opacity(0.15))
                            .frame(width: 14, height: 4)
                    }
                }
            }
            Spacer()
            Text("\(price.formatted()) ₽")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(rarity.color)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(Color.black.opacity(0.55))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}