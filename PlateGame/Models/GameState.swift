import Foundation
import Combine

class GameState: ObservableObject {
    @Published var balance: Int = 50_000
    @Published var inventory: [InventoryItem] = []
    @Published var currentPlate: LicensePlate?
    @Published var spinningPlate: LicensePlate?
    @Published var currentRarity: Rarity = .common
    @Published var isSpinning = false
    @Published var isLocked = false
    @Published var recordPrice: Int = 0
    @Published var lastRecordEvent: UUID?
    
    let spinCost = 3_000
    let sellPercent: Double = 0.80
    let inventoryLimit = 500
    let safeLimit = 5
    
    private let spinDuration: Double = 0.5
    private let tickInterval: Double = 0.03
    
    struct InventoryItem: Identifiable, Codable, Hashable {
        let id: UUID
        let plate: LicensePlate
        let price: Int
        let rarity: Rarity
        let inSafe: Bool
    }
    
    init() {
        let p = PlateGenerator.generate()
        currentPlate = p.plate
        currentRarity = p.rarity
    }
    
    // MARK: - Spin
    
    func spin() {
        guard !isSpinning, !isLocked, balance >= spinCost else { return }
        guard inventory.count < inventoryLimit else { return }
        
        balance -= spinCost
        isSpinning = true
        
        let result = PlateGenerator.generate()
        let finalPlate = result.plate
        let finalRarity = result.rarity
        
        let startTime = Date()
        let timer = Timer.scheduledTimer(withTimeInterval: tickInterval,
                                         repeats: true) { [weak self] t in
            guard let self = self else { return }
            let elapsed = Date().timeIntervalSince(startTime)
            
            if elapsed >= self.spinDuration {
                t.invalidate()
                self.spinningPlate = finalPlate
                self.currentPlate = finalPlate
                self.currentRarity = finalRarity
                self.isSpinning = false
                self.finishSpin(plate: finalPlate, rarity: finalRarity)
            } else {
                self.spinningPlate = PlateGenerator.randomVisualOnly()
            }
        }
        RunLoop.main.add(timer, forMode: .common)
    }
    
    private func finishSpin(plate: LicensePlate, rarity: Rarity) {
        let price = PlatePricer.price(for: plate, rarity: rarity)
        let item = InventoryItem(id: plate.id, plate: plate,
                                 price: price, rarity: rarity, inSafe: false)
        inventory.append(item)
        
        if price > recordPrice {
            recordPrice = price
            lastRecordEvent = UUID()
        }
        save()
        
        if rarity == .epic || rarity == .legendary {
            isLocked = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.isLocked = false
            }
        }
    }
    
    // MARK: - Sell / Safe
    
    func sellPrice(for item: InventoryItem) -> Int {
        Int(Double(item.price) * sellPercent)
    }
    
    func sell(_ item: InventoryItem) {
        balance += sellPrice(for: item)
        inventory.removeAll { $0.id == item.id }
        save()
    }
    
    func sellAll() {
        let total = inventory.filter { !$0.inSafe }
            .reduce(0) { $0 + sellPrice(for: $1) }
        balance += total
        inventory.removeAll { !$0.inSafe }
        save()
    }
    
    func toggleSafe(_ item: InventoryItem) {
        if let idx = inventory.firstIndex(where: { $0.id == item.id }) {
            let old = inventory[idx]
            let newSafe = !old.inSafe
            
            if newSafe {
                let currentSafeCount = inventory.filter { $0.inSafe }.count
                guard currentSafeCount < safeLimit else { return }
            }
            
            inventory[idx] = InventoryItem(
                id: old.id, plate: old.plate, price: old.price,
                rarity: old.rarity, inSafe: newSafe
            )
            save()
        }
    }
    
    func moveAllToSafe() {
        let currentSafeCount = inventory.filter { $0.inSafe }.count
        var free = safeLimit - currentSafeCount
        guard free > 0 else { return }
        
        for i in inventory.indices {
            if free <= 0 { break
