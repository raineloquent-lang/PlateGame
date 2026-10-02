import SwiftUI

struct PlateView: View {
    let plate: LicensePlate
    
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 6) {
                Text(plate.letter1)
                Text(plate.digits)
                Text(plate.letter2 + plate.letter3)
            }
            .font(.system(size: 52, weight: .black))
            .foregroundColor(.black)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color(white: 0.88))
            
            VStack(spacing: 0) {
                Text(plate.region)
                    .font(.system(size: 34, weight: .black))
                    .foregroundColor(.black)
                HStack(spacing: 2) {
                    Text("RUS")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.black)
                    FlagRU().frame(width: 20, height: 13)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color(white: 0.88))
            .overlay(
                Rectangle().frame(width: 2)
                    .foregroundColor(.black.opacity(0.7)),
                alignment: .leading
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .overlay(RoundedRectangle(cornerRadius: 6)
                    .stroke(Color(white: 0.45), lineWidth: 3))
        .overlay(RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.black, lineWidth: 1))
        .shadow(color: .black.opacity(0.6), radius: 12, y: 6)
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