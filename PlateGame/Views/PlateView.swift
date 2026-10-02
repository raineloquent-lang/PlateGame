import SwiftUI

struct PlateView: View {
    let plate: LicensePlate
    var compact: Bool = false        // ← для инвентаря
    
    var body: some View {
        let fontSize: CGFloat = compact ? 32 : 44
        let regionSize: CGFloat = compact ? 22 : 28
        
        HStack(spacing: 0) {
            HStack(spacing: 4) {
                Text(plate.letter1)
                Text(plate.digits)
                Text(plate.letter2 + plate.letter3)
            }
            .font(.system(size: fontSize, weight: .heavy, design: .default))
            .foregroundColor(.black)
            .padding(.horizontal, compact ? 10 : 14)
            .padding(.vertical, compact ? 6 : 8)
            .background(Color(white: 0.88))
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            
            VStack(spacing: 0) {
                Text(plate.region)
                    .font(.system(size: regionSize, weight: .heavy))
                    .foregroundColor(.black)
                    .lineLimit(1)
                HStack(spacing: 2) {
                    Text("RUS")
                        .font(.system(size: compact ? 7 : 9, weight: .bold))
                        .foregroundColor(.black)
                    FlagRU().frame(width: compact ? 14 : 18,
                                   height: compact ? 9 : 12)
                }
            }
            .padding(.horizontal, compact ? 6 : 8)
            .padding(.vertical, compact ? 4 : 6)
            .background(Color(white: 0.88))
            .overlay(
                Rectangle().frame(width: 1.5)
                    .foregroundColor(.black.opacity(0.6)),
                alignment: .leading
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .overlay(RoundedRectangle(cornerRadius: 5)
                    .stroke(Color(white: 0.5), lineWidth: 2))
        .overlay(RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.black, lineWidth: 0.8))
        .shadow(color: .black.opacity(0.5), radius: 6, y: 3)
    }
}

struct FlagRU: View {
    var body: some View {
        VStack(spacing: 0) {
            Color.white
            Color(red: 0.0, green: 0.22, blue: 0.65)
            Color(red: 0.83, green: 0.06, blue: 0.13)
        }
        .overlay(Rectangle().stroke(Color.black.opacity(0.5), lineWidth: 0.5))
    }
}
