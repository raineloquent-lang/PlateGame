import Foundation

struct LicensePlate: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    let letter1: String
    let digits: String
    let letter2: String
    let letter3: String
    let region: String
    
    init(id: UUID = UUID(),
         letter1: String, digits: String,
         letter2: String, letter3: String,
         region: String) {
        self.id = id
        self.letter1 = letter1
        self.digits = digits
        self.letter2 = letter2
        self.letter3 = letter3
        self.region = region
    }
    
    var series: String { "\(letter1)\(letter2)\(letter3)" }
    var compact: String { "\(letter1)\(digits)\(letter2)\(letter3)\(region)" }
    var fullText: String { "\(letter1)\(digits)\(letter2)\(letter3) \(region)" }
}