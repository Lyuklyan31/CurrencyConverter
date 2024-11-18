import Foundation

struct CurrencyModel: Codable, Hashable {
    internal init(name: String, code: String) {
        self.name = name
        self.code = code
    }
    
    let name: String
    let code: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(code)
    }

    static func == (lhs: CurrencyModel, rhs: CurrencyModel) -> Bool {
        return lhs.code == rhs.code
    }
}
