import SwiftUI

struct MainGameView: View {
    @EnvironmentObject var state: GameState
    @State private var showCollection = false
    @State private var bannerOffset: CGFloat = -200
    @State private var showBanner = false
    @State private var displayedPrice: Int = 0
    @State private var visibleBonuses: Int = 0
    @State private var stopScale: CGFloat = 1.0
    
    var body: some View {
        let shownPlate = state.isSpinning
            ? (state.spinningPlate ?? state.currentPlate ?? PlateGenerator.randomPlate())
            : (state.currentPlate ?? PlateGenerator.randomPlate())
        
        let calc = PlatePricer.calculate(for: shownPlate, rarity: state.currentRarity)
        let rarity = state.isSpinning ? Rarity.common : state.currentRarity
        
        NavigationStack {
            ZStack(alignment: .top) {
                // Фон
                LinearGradient(colors: rarity.backgroundGradient,
                               startPoint: .top, endPoint: .bottom)
                    .animation(.easeInOut(duration: 0.4), value: rarity)
                
                // Тап на весь экран
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        guard !state.isSpinning,
                              !state.isLocked,
                              state.balance >= state.spinCost,
                              state.inventory.count < state.inventoryLimit else { return }
                        hideBanner()
                        resetAnimations()
                        state.spin()
                    }
                
                VStack(spacing: 0) {
                    HeaderBar(balance: state.balance) { showCollection = true }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)   // ← уменьшил с 60, т.к. safe area теперь убран
                    
                    Spacer()
                    
                    if state.isSpinning {
                        RarityBarSkeleton()
                            .padding(.horizontal, 24)
                            .padding(.bottom, 16)
                    } else {
                        RarityBar(rarity: rarity, price: calc.total)
                            .padding(.horizontal, 24)
                            .padding(.bottom, 16)
                    }
                    
                    PlateView(plate: shownPlate)
                        .scaleEffect(state.isSpinning ? 0.95 : stopScale)
                        .animation(
                            state.isSpinning
                            ? .easeInOut(duration: 0.08)
                            : .spring(response: 0.25, dampingFraction: 0.4),
                            value: state.isSpinning
                        )
                        .padding(.horizontal, 24)
                        .padding(.bottom, 16)
                    
                    if state.isSpinning {
                        Text("...")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color.white.opacity(0.3))
                            .padding(.bottom, 12)
                    } else {
                        Text("\(displayedPrice.formatted()) ₽")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(rarity.color)
                            .animation(.easeOut(duration: 0.4), value: displayedPrice)
                            .padding(.bottom, 12)
                    }
                    
                    VStack(spacing: 4) {
                        if !state.isSpinning {
                            ForEach(Array(calc.bonuses.enumerated()), id: \.offset) { idx, bonus in
                                Text(bonus.title)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(white: 0.65))
                                    .multilineTextAlignment(.center)
                                    .opacity(idx < visibleBonuses ? 1 : 0)
                                    .offset(y: idx < visibleBonuses ? 0 : 20)
                                    .animation(
                                        .easeOut(duration: 0.35).delay(Double(idx) * 0.08),
                                        value: visibleBonuses
                                    )
                            }
                        }
                    }
                    .frame(minHeight: 80, alignment: .top)
                    .padding(.horizontal, 24)
                    
                    Spacer()
                    
                    Text(state.isSpinning
                         ? "Крутится..."
                         : (state.isLocked ? "Ждём..." : "Тапни в любом месте"))
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color.white.opacity(0.4))
                        .padding(.bottom, 20)   // ← уменьшил с 60
                }
                
                if showBanner {
                    RecordBanner(price: state.recordPrice) { hideBanner() }
                        .padding(.horizontal)
                        .padding(.top, 20)   // ← уменьшил
                        .offset(y: bannerOffset)
                }
            }
            .ignoresSafeArea(.all)   // ← КЛЮЧЕВОЕ! Игнорим safe area для ВСЕГО ZStack
            .navigationDestination(isPresented: $showCollection) {
                CollectionView()
            }
            .toolbar(.hidden, for: .navigationBar)
            .onReceive(state.$lastRecordEvent) { event in
                guard event != nil else { return }
                showRecordBanner()
            }
            .onChange(of: state.isSpinning) { spinning in
                if !spinning, let plate = state.currentPlate {
                    animateStop(for: plate)
                }
            }
        }
    }
    
    // ... остальные методы без изменений
}
