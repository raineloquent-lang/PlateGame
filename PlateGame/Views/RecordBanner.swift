import SwiftUI

struct RecordBanner: View {
    let price: Int
    let onOpen: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Новый рекорд: номер за")
                    .font(.system(size: 13))
                    .foregroundColor(Color(red: 0.85, green: 0.75, blue: 0.4))
                Text("\(price.formatted()) ₽!")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
            }
            Spacer()
            Button(action: onOpen) {
                Text("Открыть →")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(red: 0.95, green: 0.85, blue: 0.5))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.black.opacity(0.55))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(red: 0.55, green: 0.45, blue: 0.15), lineWidth: 1.5)
        )
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: Color(red: 0.9, green: 0.75, blue: 0.2).opacity(0.3), radius: 12)
    }
}