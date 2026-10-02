import SwiftUI

struct HeaderBar: View {
    let balance: Int
    let onMenu: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onMenu) {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(.white)
            }
            Spacer()
            Text("\(balance.formatted()) ₽")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
        }
    }
}