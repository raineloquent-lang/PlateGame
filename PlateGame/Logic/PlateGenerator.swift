import Foundation

enum PlateGenerator {
    static let letters = Array("АВЕКМНОРСТУХ")
    static let digits  = Array("0123456789")
    
    /// Генерация номера с определением редкости по бонусам
    static func generate() -> (plate: LicensePlate, rarity: Rarity) {
        // Пытаемся сгенерировать номер
        // (не нужен while — редкость определяется после генерации)
        let plate = randomPlate()
        let (_, rarity) = PlatePricer.evaluate(for: plate)
        return (plate, rarity)
    }
    
    /// Просто случайный номер (для мелькания)
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
        // 4. Лёгкий шанс "блатного номера"
        if Int.random(in: 1...1000) <= 30 {
            return .police
        }
        return .civil
    }
}
