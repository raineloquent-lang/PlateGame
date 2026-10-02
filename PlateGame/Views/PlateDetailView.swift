import SwiftUI

struct PlateDetailView: View {
    let item: GameState.InventoryItem
    @EnvironmentObject var state: GameState
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        let calc = PlatePricer.calculate(for: item.plate, rarity: item.rarity)
        let rarity = item.rarity
        
        ZStack {
            Color(white: 0.05).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Верхняя плашка
                    VStack(spacing: 12) {
                        PlateView(plate: item.plate)
                            .scaleEffect(0.9)
                        HStack(spacing: 4) {
                            ForEach(0..<5, id: \.self) { i in
                                Capsule()
                                    .fill(i < rarity.bars ? rarity.color : Color.white.opacity(0.15))
                                    .frame(width: 40, height: 5)
                            }
                        }
                        Text(rarity.title)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(rarity.color)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
                    .background(
                        LinearGradient(colors: rarity.backgroundGradient,
                                       startPoint: .top, endPoint: .bottom)
                    )
                    
                    VStack(alignment: .leading, spacing: 0) {
                        VStack(spacing: 6) {
                            HStack(spacing: 8) {
                                Text(calc.plateClass.rawValue)
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundColor(.white)
                                Text("×\(Int(calc.classMultiplier))")
                                    .font(.system(size: 13, weight: .bold))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(calc.plateClass.color)
                                    .foregroundColor(.black)
                                    .clipShape(Capsule())
                            }
                            Text("Россия · \(item.plate.region) · \(RegionRegistry.name(for: item.plate.region))")
                                .font(.system(size: 14))
                                .foregroundColor(Color(white: 0.55))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        
                        Divider().background(Color.white.opacity(0.1))
                        
                        HStack {
                            Text("Базовая стоимость")
                                .foregroundColor(Color(white: 0.65))
                            Spacer()
                            Text("\(calc.base) ₽")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        
                        if !calc.bonuses.isEmpty {
                            Divider().background(Color.white.opacity(0.1))
                                .padding(.horizontal, 20)
                            
                            Text("Комбинации")
                                .font(.system(size: 14))
                                .foregroundColor(Color(white: 0.5))
                                .padding(.horizontal, 20)
                                .padding(.top, 14)
                                .padding(.bottom, 4)
                            
                            ForEach(calc.bonuses) { bonus in
                                HStack(alignment: .top) {
                                    Text(bonus.title)
                                        .foregroundColor(Color(white: 0.85))
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                    Text("+\(bonus.amount.formatted()) ₽")
                                        .foregroundColor(Color(white: 0.85))
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                            }
                        }
                        
                        Divider().background(Color.white.opacity(0.1))
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                        
                        HStack(spacing: 0) {
                            MultiplierCell(label: "комбо", value: calc.comboMultiplier)
                            Divider().frame(height: 30).background(Color.white.opacity(0.1))
                            MultiplierCell(label: "регион", value: calc.regionMultiplier)
                            Divider().frame(height: 30).background(Color.white.opacity(0.1))
                            MultiplierCell(label: "код", value: calc.codeMultiplier)
                            Divider().frame(height: 30).background(Color.white.opacity(0.1))
                            MultiplierCell(label: "класс", value: calc.classMultiplier)
                        }
                        .padding(.vertical, 16)
                        
                        Divider().background(Color.white.opacity(0.1))
                            .padding(.horizontal, 20)
                        
                        HStack {
                            Text("Цена номера")
                                .font(.system(size: 17))
                                .foregroundColor(Color(white: 0.65))
                            Spacer()
                            Text("\(calc.total.formatted()) ₽")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                    }
                    
                    VStack(spacing: 10) {
                        if item.inSafe {
                            Button {
                                state.toggleSafe(item)
                                dismiss()
                            } label: {
                                Text("Убрать из сейфа")
                                    .font(.system(size: 17, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 18)
                                    .background(Color.white.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                        } else {
                            Button {
                                state.toggleSafe(item)
                                dismiss()
                            } label: {
                                Text("В сейф")
                                    .font(.system(size: 17, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 18)
                                    .background(Color.white.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                            
                            Button {
                                state.sell(item)
                                dismiss()
                            } label: {
                                VStack(spacing: 2) {
                                    Text("Продать за \(calc.total.formatted()) ₽")
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundColor(.white)
                                    Text("Получишь \(state.sellPrice(for: item).formatted()) ₽ (−20%)")
                                        .font(.system(size: 11))
                                        .foregroundColor(Color.white.opacity(0.75))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color(red: 0.85, green: 0.25, blue: 0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }
            }
        }
    }
}