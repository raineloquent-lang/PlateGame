import Foundation

enum PlateGenerator {
    static let letters = Array("АВЕКМНОРСТУХ")
    static let digits  = Array("0123456789")
    
    /// Генерация номера с роллом редкости
    static func generate() -> (plate: LicensePlate, rarity: Rarity) {
        let rarity = rollRarity()
        let plate = randomPlate()
        return (plate, rarity)
    }
    
    /// Просто случайный номер (для мелькания во время спина)
    static func randomVisualOnly() -> LicensePlate {
        randomPlate()
    }
    
    static func randomPlate() -> LicensePlate {
        LicensePlate(
            letter1: String(letters.randomElement()!),
            digits: String((0..<3).map { _ in digits.randomElement()! }),
            letter2: String(letters.randomElement()!),
            letter3: String(letters.randomElement()!),
            region: RegionRegistry.allCodes.randomElement()!
        )
    }
    
    /// Рулетка редкости по шансам
    static func rollRarity() -> Rarity {
        let total = Rarity.allCases.reduce(0.0) { $0 + $1.chance }
        let roll = Double.random(in: 0..<total)
        var cumulative = 0.0
        for rarity in Rarity.allCases {
            cumulative += rarity.chance
            if roll < cumulative { return rarity }
        }
        return .common
    }
    
    /// Определение класса (блатности) номера
    static func determineClass(for p: LicensePlate) -> PlateClass {
        // 1. Исторический
        if SeriesRegistry.historic.keys.contains(p.compact) {
            return .historic
        }
        // 2. Известная серия
        if let (cls, _, _) = SeriesRegistry.info(for: p.series) {
            return cls
        }
        // 3. Региональные блатные А?А (Правительство региона)
        let l = [p.letter1, p.letter2, p.letter3]
        if l[0] == "А" && l[2] == "А" && l[1] != "А" {
            return .government
        }
        // 4. Лёгкий "блатной номер" шанс
        if Int.random(in: 1...1000) <= 30 {
            return .police
        }
        return .civil
    }
}