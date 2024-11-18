import Foundation
import Combine

class CurrencyViewModel {
    private var currencyService = CurrencyService()
    
    @Published private(set) var currencies = [CurrencyModel]()
    @Published private(set) var converterList = [CurrencyModel]() {
        didSet {
            saveConverterList()
        }
    }
    @Published private(set) var alertMessage: String?
    private var allCurrencies = [CurrencyModel]()
    
    private let userDefaultsKey = "converterList"
    
    init() {
        fetchCurrencies()
        loadConverterList()
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
    
    func updateConverterList(at indexPath: Int) {
        converterList.append(currencies[indexPath])
    }
    
    private func saveConverterList() {
        let data = converterList.map { ["name": $0.name, "code": $0.code] }
        UserDefaults.standard.set(data, forKey: userDefaultsKey)
    }
    
    private func loadConverterList() {
        guard let savedData = UserDefaults.standard.array(forKey: userDefaultsKey) as? [[String: String]] else { return }
        converterList = savedData.compactMap { dict in
            if let name = dict["name"], let code = dict["code"] {
                return CurrencyModel(name: name, code: code)
            }
            return nil
        }
    }
}
