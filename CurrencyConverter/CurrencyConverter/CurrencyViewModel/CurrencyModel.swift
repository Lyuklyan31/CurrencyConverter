import Foundation

struct CurrencyModel: Codable, Hashable {
    let name: String
    let code: String
    var value: Double
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(code)
    }

    static func == (lhs: CurrencyModel, rhs: CurrencyModel) -> Bool {
        return lhs.code == rhs.code
    }
}
