import Foundation
import Combine

class CurrencyViewModel {
    private var currencyService = CurrencyService()
    
    @Published private(set) var currencies = [CurrencyModel]()
    
    @Published private(set) var alertMessage: String?
    
    init() {
        fetchCurrencies()
    }
    
   private func fetchCurrencies() {
       do {
           currencies = try currencyService.fetchCurrencies()
           print("Currencies: \(currencies)")
       } catch {
           alertMessage = "Error fetching currencies."
       }
    }
}
