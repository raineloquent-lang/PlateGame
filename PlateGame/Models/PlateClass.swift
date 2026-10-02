import SwiftUI

enum PlateClass: String, Codable, CaseIterable {
    case civil          = "Гражданский"
    case meme           = "Мемный"
    case aue            = "АУЕ"
    case military       = "Военный"
    case police         = "МВД"
    case sk             = "Следственный комитет"
    case government     = "Правительственный"
    case kgb            = "ФСБ"
    case presidential   = "Администрация Президента"
    case historic       = "Исторический"
    
    var multiplier: Double {
        switch self {
        case .civil:        return 1.0
        case .meme:         return 3.0
        case .aue:          return 5.0
        case .police:       return 10.0
        case .military:     return 15.0
        case .sk:           return 30.0
        case .government:   return 50.0
        case .kgb:          return 100.0
        case .presidential: return 200.0
        case .historic:     return 500.0
        }
    }
    
    var bonusAmount: Int {
        switch self {
        case .civil:        return 0
        case .meme:         return 5_000
        case .aue:          return 24_000
        case .military:     return 40_000
        case .police:       return 30_000
        case .sk:           return 60_000
        case .government:   return 100_000
        case .kgb:          return 150_000
        case .presidential: return 200_000
        case .historic:     return 500_000
        }
    }
    
    var color: Color {
        switch self {
        case .civil:        return Color(white: 0.5)
        case .meme:         return Color(red: 0.4, green: 0.8, blue: 0.4)
        case .aue:          return Color(red: 0.2, green: 0.6, blue: 0.3)
        case .military:     return Color(red: 0.4, green: 0.6, blue: 0.9)
        case .police:       return Color(red: 0.3, green: 0.5, blue: 0.95)
        case .sk:           return Color(red: 0.6, green: 0.4, blue: 0.9)
        case .government:   return Color(red: 0.95, green: 0.6, blue: 0.2)
        case .kgb:          return Color(red: 0.9, green: 0.25, blue: 0.25)
        case .presidential: return Color(red: 0.95, green: 0.15, blue: 0.15)
        case .historic:     return Color(red: 0.98, green: 0.85, blue: 0.2)
        }
    }
}