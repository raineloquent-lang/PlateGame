import SwiftUI

struct RarityBarSkeleton: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Определяется...")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.white.opacity(0.4))
                HStack(spacing: 4) {
                    ForEach(0..<5, id: \.self) { _ in
                        Capsule()
                            .fill(Color.white.opacity(0.15))
                            .frame(width: 14, height: 4)
                    }
                }
            }
            Spacer()
            Text("...")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Color.white.opacity(0.3))
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(Color.black.opacity(0.55))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}