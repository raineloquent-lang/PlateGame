import SwiftUI

enum Rarity: Int, Codable, CaseIterable {
    case common    = 0
    case uncommon  = 1
    case rare      = 2
    case epic      = 3
    case legendary = 4
    
    var title: String {
        switch self {
        case .common:    return "Обычный"
        case .uncommon:  return "Необычный"
        case .rare:      return "Редкий"
        case .epic:      return "Эпический"
        case .legendary: return "Легендарный"
        }
    }
    
    var color: Color {
        switch self {
        case .common:    return Color(white: 0.55)
        case .uncommon:  return Color(red: 0.30, green: 0.78, blue: 0.35)
        case .rare:      return Color(red: 0.29, green: 0.56, blue: 0.95)
        case .epic:      return Color(red: 0.66, green: 0.35, blue: 0.95)
        case .legendary: return Color(red: 0.95, green: 0.78, blue: 0.15)
        }
    }
    
    var bars: Int { rawValue + 1 }
    
    var backgroundGradient: [Color] {
        switch self {
        case .common:
            return [Color(white: 0.08), Color(white: 0.15)]
        case .uncommon:
            return [Color(red: 0.04, green: 0.14, blue: 0.06),
                    Color(red: 0.08, green: 0.28, blue: 0.12)]
        case .rare:
            return [Color(red: 0.04, green: 0.08, blue: 0.20),
                    Color(red: 0.08, green: 0.18, blue: 0.42)]
        case .epic:
            return [Color(red: 0.10, green: 0.04, blue: 0.18),
                    Color(red: 0.26, green: 0.10, blue: 0.40)]
        case .legendary:
            return [Color(red: 0.14, green: 0.10, blue: 0.02),
                    Color(red: 0.34, green: 0.24, blue: 0.04)]
        }
    }
    
    /// Класс-множитель
    var classMultiplier: Double {
        switch self {
        case .common:    return 1.00
        case .uncommon:  return 1.05
        case .rare:      return 1.20
        case .epic:      return 5.00
        case .legendary: return 50.00
        }
    }
    
    // MARK: - Определение редкости
    
    /// Определяем редкость по очкам бонусов и наличию блатного
    static func determine(bonusPoints: Int, hasElite: Bool) -> Rarity {
        if hasElite {
            return bonusPoints >= 3 ? .legendary : .epic
        } else {
            switch bonusPoints {
            case 0:      return .common
            case 1:      return .uncommon
            case 2:      return .rare
            case 3:      return .epic
            default:     return .legendary   // 4+
            }
        }
    }
}
