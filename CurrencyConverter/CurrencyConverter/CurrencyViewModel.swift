import Foundation

class CurrencyViewModel {
    private var currencyService = CurrencyService()
    
    private var currencyList = [CurrencyModel]()
    
    @Published private(set) var alertMessage: String?
    
    init() {
        fetchCurrencies()
    }
    
   private func fetchCurrencies() {
       do {
           currencyList = try currencyService.fetchCurrencies()
           print(currencyList)
       } catch {
           alertMessage = "Error fetching currencies."
       }
    }
}
