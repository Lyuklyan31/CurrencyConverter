import Combine
import UIKit

class CurrencyViewModel {
    private var currencyService = СurrenciesService()
    private let rateService = RateService()
    
    @Published private(set) var currencies = [CurrencyModel]()
    @Published private(set) var converterList = [CurrencyModel]() {
        didSet { saveConverterList() }
    }
    @Published private(set) var alertMessage: String?
    @Published private(set) var conversionRates = [String: Double]()
    
    @Published private(set) var curency = CurrencyModel()
    
    private let userDefaultsKey = "converterList"
    
    init() {
        fetchCurrencies()
//        loadConverterList()
        loadExchangeRates()
    }
    
    private func fetchCurrencies() {
        do {
            let fetchedCurrencies = try currencyService.fetchCurrencies()
                    
            self.currencies = fetchedCurrencies.map { currency in
                CurrencyModel(name: currency.name, code: currency.code)
            }
        } catch {
            alertMessage = "Error fetching currencies."
        }
    }
    
    func filterCurrencies(with searchText: String) {
        if searchText.isEmpty {
            fetchCurrencies()
        } else {
            currencies = currencies.filter { currency in
                currency.name.lowercased().contains(searchText.lowercased()) ||
                currency.code.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    func updateConverterList(at indexPath: Int) {
        currencies.indices.forEach { currencies[$0].isSelected = false }
        currencies[indexPath].isSelected = true
        curency = currencies[indexPath]
        
        let selectedCurrency = currencies[indexPath]
        guard !converterList.contains(where: { $0.isSelected }) else { return }
        let newCurrency = CurrencyModel(name: selectedCurrency.name, code: selectedCurrency.code, value: 0.0)
        converterList.append(newCurrency)
    }
    
    func updateValue(for code: String, newValue: Double) {
        guard let baseRate = conversionRates[code] else { return }
        
        converterList = converterList.map { currency in
            if currency.code == code {
                return CurrencyModel(name: currency.name, code: currency.code, value: newValue)
            } else {
                guard let currentRate = conversionRates[currency.code] else { return currency }
                let convertedValue = (newValue / baseRate) * currentRate
                return CurrencyModel(name: currency.name, code: currency.code, value: convertedValue)
            }
        }
    }
    
    private func saveConverterList() {
        let data = converterList.map { ["name": $0.name, "code": $0.code, "value": $0.value] }
        UserDefaults.standard.set(data, forKey: userDefaultsKey)
    }
    
    private func loadConverterList() {
        guard let savedData = UserDefaults.standard.array(forKey: userDefaultsKey) as? [[String: Any]] else { return }
        converterList = savedData.compactMap { dict in
            if let name = dict["name"] as? String,
               let code = dict["code"] as? String,
               let value = dict["value"] as? Double {
                return CurrencyModel(name: name, code: code, value: value)
            }
            return nil
        }
    }
    
    private func loadExchangeRates() {
        if let savedRatesData = UserDefaults.standard.data(forKey: "conversionRates"),
           let savedRates = try? JSONDecoder().decode(RateModel.self, from: savedRatesData) {
            conversionRates = savedRates.conversionRates
        }
    }
    
    func fetchExchangeRates() {
        Task {
            do {
                let rateModel = try await rateService.fetchRates()
                saveExchangeRates(rateModel)
                conversionRates = rateModel.conversionRates
            } catch {
                alertMessage = "Error fetching exchange rates."
            }
        }
    }
    
    private func saveExchangeRates(_ rateModel: RateModel) {
        if let encodedRates = try? JSONEncoder().encode(rateModel) {
            UserDefaults.standard.set(encodedRates, forKey: "conversionRates")
        }
    }
}
