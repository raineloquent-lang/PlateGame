import Foundation

struct Bonus: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let amount: Int
    let points: Int
}

struct PriceBreakdown {
    let base: Int
    let bonuses: [Bonus]
    let comboMultiplier: Double
    let regionMultiplier: Double
    let codeMultiplier: Double
    let classMultiplier: Double
    let plateClass: PlateClass
    let rarity: Rarity
    let hasElite: Bool
    
    var bonusesSum: Int { bonuses.reduce(0) { $0 + $1.amount } }
    var bonusPoints: Int { bonuses.reduce(0) { $0 + $1.points } }
    
    var total: Int {
        let sum = Double(base + bonusesSum)
        let value = sum * comboMultiplier * regionMultiplier
                  * codeMultiplier * classMultiplier
        return Int(value.rounded())
    }
}

enum PlatePricer {
    
    // MARK: - Публичные методы
    
    /// Полный расчёт для показа в детальной карточке
    static func calculate(for p: LicensePlate, rarity: Rarity) -> PriceBreakdown {
        let cls = PlateGenerator.determineClass(for: p)
        let hasElite = cls != .civil
        let bonuses = collectBonuses(p, plateClass: cls)
        let combo = comboMultiplier(bonusesCount: bonuses.count)
        let region = RegionRegistry.multiplier(for: p.region)
        let code = randomCode()
        
        return PriceBreakdown(
            base: 100,
            bonuses: bonuses,
            comboMultiplier: combo,
            regionMultiplier: region,
            codeMultiplier: code,
            classMultiplier: rarity.classMultiplier,
            plateClass: cls,
            rarity: rarity,
            hasElite: hasElite
        )
    }
    
    /// Считает всё: бонусы, очки, комбо, регион, код, редкость, финальную цену
    static func evaluate(for p: LicensePlate) -> (breakdown: PriceBreakdown, rarity: Rarity) {
        let cls = PlateGenerator.determineClass(for: p)
        let hasElite = cls != .civil
        let bonuses = collectBonuses(p, plateClass: cls)
        let combo = comboMultiplier(bonusesCount: bonuses.count)
        let region = RegionRegistry.multiplier(for: p.region)
        let code = randomCode()
        
        let points = bonuses.reduce(0) { $0 + $1.points }
        let rarity = Rarity.determine(bonusPoints: points, hasElite: hasElite)
        
        let breakdown = PriceBreakdown(
            base: 100,
            bonuses: bonuses,
            comboMultiplier: combo,
            regionMultiplier: region,
            codeMultiplier: code,
            classMultiplier: rarity.classMultiplier,
            plateClass: cls,
            rarity: rarity,
            hasElite: hasElite
        )
        
        return (breakdown, rarity)
    }
    
    static func price(for p: LicensePlate, rarity: Rarity) -> Int {
        calculate(for: p, rarity: rarity).total
    }
    
    // MARK: - Код
    
    private static func randomCode() -> Double {
        // Bias к верхним значениям (0.5...1.0)
        let a = Double.random(in: 0.5...1.0)
        let b = Double.random(in: 0.5...1.0)
        return max(a, b)
    }
    
    // MARK: - Бонусы
    
    static func collectBonuses(_ p: LicensePlate,
                               plateClass: PlateClass) -> [Bonus] {
        var result: [Bonus] = []
        let l = [p.letter1, p.letter2, p.letter3]
        let d = Array(p.digits)
        
        // ═══ БУКВЫ ═══
        let lettersAllEqual = l[0] == l[1] && l[1] == l[2]
        let lettersMirror   = l[0] == l[2] && l[0] != l[1]
        let lettersTwoEqual = (l[0] == l[1] || l[1] == l[2] || l[0] == l[2])
                              && !lettersAllEqual && !lettersMirror
        
        if lettersAllEqual {
            result.append(Bonus(title: "3 одинаковые буквы", amount: 24_000, points: 2))
        } else if lettersMirror {
            result.append(Bonus(title: "Палиндром букв", amount: 12_000, points: 1))
        } else if lettersTwoEqual {
            result.append(Bonus(title: "2 одинаковые буквы", amount: 8_000, points: 1))
        }
        
        // ═══ ЦИФРЫ ═══
        let digitsAllEqual = Set(p.digits).count == 1
        let digitsTwoEqual = Set(p.digits).count == 2
        let digitsMirror   = d.count == 3 && d[0] == d[2] && d[0] != d[1]
        let digitsSeq      = isSequential(p.digits)
        let isRound        = ["100","200","300","400","500","600","700","800","900"].contains(p.digits)
        let isSmall        = ["001","002","003","004","005","006","007","008","009"].contains(p.digits)
        
        if digitsAllEqual {
            result.append(Bonus(title: "3 одинаковые цифры", amount: 21_000, points: 2))
        } else if digitsMirror {
            result.append(Bonus(title: "Зеркальные цифры", amount: 10_000, points: 2))
        } else if digitsTwoEqual {
            result.append(Bonus(title: "2 одинаковые цифры", amount: 7_000, points: 1))
        } else if isSmall {
            result.append(Bonus(title: "Малый номер", amount: 12_000, points: 2))
        } else if digitsSeq {
            result.append(Bonus(title: "Последовательные цифры", amount: 15_000, points: 2))
        } else if isRound {
            result.append(Bonus(title: "Круглый номер", amount: 10_000, points: 1))
        }
        
        // ═══ ЦИФРЫ = РЕГИОН ═══
        if p.digits == p.region || p.region.hasSuffix(p.digits) {
            result.append(Bonus(title: "Цифры совпадают с регионом", amount: 13_000, points: 2))
        }
        
        // ═══ БЛАТНАЯ СЕРИЯ ═══
        if plateClass != .civil {
            if let (_, desc, amount) = SeriesRegistry.info(for: p.series) {
                result.append(Bonus(title: desc, amount: amount, points: 0))
            } else if plateClass == .historic,
                      let hDesc = SeriesRegistry.historicDescription(for: p.compact) {
                result.append(Bonus(title: hDesc, amount: 500_000, points: 0))
            } else if plateClass == .government && l[0] == "А" && l[2] == "А" {
                let regionName = RegionRegistry.name(for: p.region)
                result.append(Bonus(title: "Правительство \(regionName)",
                                    amount: 24_000, points: 0))
            } else {
                result.append(Bonus(title: "Блатной номер.", amount: 7_000, points: 0))
            }
        }
        
        return result
    }
    
    private static func isSequential(_ d: String) -> Bool {
        let n = d.compactMap { $0.wholeNumberValue }
        guard n.count == 3 else { return false }
        return (n[1] == n[0]+1 && n[2] == n[1]+1) ||
               (n[1] == n[0]-1 && n[2] == n[1]-1)
    }
    
    // MARK: - Комбо
    
    /// комбо = 1.00 при N ≤ 1, иначе 0.75 × N
    private static func comboMultiplier(bonusesCount n: Int) -> Double {
        if n <= 1 { return 1.00 }
        return 0.75 * Double(n)
    }
}
