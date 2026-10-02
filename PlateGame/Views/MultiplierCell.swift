import SwiftUI

struct MultiplierCell: View {
    let label: String
    let value: Double
    
    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(Color(white: 0.5))
            Text("×\(String(format: "%.2f", value))")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
    }
}