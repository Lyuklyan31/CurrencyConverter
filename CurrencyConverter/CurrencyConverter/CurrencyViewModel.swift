import Foundation
import Combine

class CurrencyViewModel {
    private var currencyService = CurrencyService()
    
    @Published private(set) var currencies = [CurrencyModel]()
    @Published private(set) var alertMessage: String?
    
    private var allCurrencies = [CurrencyModel]()
    
    init() {
        fetchCurrencies()
    }
    
    func fetchCurrencies() {
        do {
            allCurrencies = try currencyService.fetchCurrencies()
            currencies = allCurrencies
        } catch {
            alertMessage = "Error fetching currencies."
        }
    }
    
    func filterCurrencies(with searchText: String) {
        if searchText.isEmpty {
            currencies = allCurrencies
        } else {
            currencies = allCurrencies.filter { currency in
                currency.name.lowercased().contains(searchText.lowercased()) ||
                currency.code.lowercased().contains(searchText.lowercased())
            }
        }
    }
}
