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
                    .padding(.top, 50)
                
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
                    .padding(.bottom, 40)
            }
            
            if showBanner {
                RecordBanner(price: state.recordPrice) { hideBanner() }
                    .padding(.horizontal)
                    .padding(.top, 60)
                    .offset(y: bannerOffset)
            }
        }
        .ignoresSafeArea(.all)
        .sheet(isPresented: $showCollection) {
            CollectionView()
        }
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
    
    private func resetAnimations() {
        displayedPrice = 0
        visibleBonuses = 0
        stopScale = 1.0
    }
    
    private func animateStop(for plate: LicensePlate) {
        let calc = PlatePricer.calculate(for: plate, rarity: state.currentRarity)
        
        stopScale = 1.06
        withAnimation(.spring(response: 0.25, dampingFraction: 0.4)) {
            stopScale = 1.0
        }
        
        let target = calc.total
        let steps = 25
        let stepValue = max(target / steps, 1)
        for i in 1...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.035) {
                displayedPrice = min(stepValue * i, target)
            }
        }
        
        for i in 1...max(calc.bonuses.count, 1) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 + Double(i) * 0.08) {
                visibleBonuses = i
            }
        }
    }
    
    private func showRecordBanner() {
        bannerOffset = -200
        showBanner = true
        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
            bannerOffset = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { hideBanner() }
    }
    
    private func hideBanner() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.9)) {
            bannerOffset = -200
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            showBanner = false
        }
    }
}
