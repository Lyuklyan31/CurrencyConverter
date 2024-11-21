import Foundation

struct CurrencyModel: Codable, Hashable {
    var id = UUID()
    var name: String = ""
    var code: String = ""
    var value: Double = 0.0
    var isSelected: Bool = false
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(code)
        hasher.combine(value)
    }

    static func == (lhs: CurrencyModel, rhs: CurrencyModel) -> Bool {
        return lhs.name == rhs.name &&
        lhs.code == rhs.code &&
        lhs.value == rhs.value
    }
}
