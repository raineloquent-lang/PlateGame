import SwiftUI

struct PlateView: View {
    let plate: LicensePlate
    var compact: Bool = false
    
    var body: some View {
        let fontSize: CGFloat = compact ? 20 : 44
        let regionSize: CGFloat = compact ? 14 : 28
        
        HStack(spacing: 0) {
            HStack(spacing: compact ? 2 : 4) {
                Text(plate.letter1)
                Text(plate.digits)
                Text(plate.letter2 + plate.letter3)
            }
            .font(.system(size: fontSize, weight: .heavy))
            .foregroundColor(.black)
            .padding(.horizontal, compact ? 6 : 14)
            .padding(.vertical, compact ? 4 : 8)
            .background(Color(white: 0.88))
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .fixedSize(horizontal: false, vertical: true)
            
            VStack(spacing: 0) {
                Text(plate.region)
                    .font(.system(size: regionSize, weight: .heavy))
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                HStack(spacing: 2) {
                    Text("RUS")
                        .font(.system(size: compact ? 6 : 9, weight: .bold))
                        .foregroundColor(.black)
                    FlagRU()
                        .frame(width: compact ? 12 : 18,
                               height: compact ? 8 : 12)
                }
            }
            .padding(.horizontal, compact ? 5 : 8)
            .padding(.vertical, compact ? 3 : 6)
            .background(Color(white: 0.88))
            .overlay(
                Rectangle().frame(width: compact ? 1 : 1.5)
                    .foregroundColor(.black.opacity(0.6)),
                alignment: .leading
            )
            .fixedSize()
        }
        .clipShape(RoundedRectangle(cornerRadius: compact ? 4 : 5))
        .overlay(RoundedRectangle(cornerRadius: compact ? 4 : 5)
                    .stroke(Color(white: 0.5), lineWidth: compact ? 1.5 : 2))
        .overlay(RoundedRectangle(cornerRadius: compact ? 4 : 5)
                    .stroke(Color.black, lineWidth: 0.8))
        .shadow(color: .black.opacity(0.5),
                radius: compact ? 3 : 6,
                y: compact ? 1 : 3)
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
