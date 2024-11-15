import Foundation

class CurrencyViewModel {
    var currencyList = [CurrencyModel]()
    init() {
        fetchCurrencies()
    }
    
   private func fetchCurrencies() {
        guard let filepath = Bundle.main.path(forResource: "Currencies", ofType: "json") else {
            return
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filepath))
            let currencies = try JSONDecoder().decode([String: CurrencyModel].self, from: data)
            currencyList = Array(currencies.values)
        
        } catch {
            
        }
    }
}
