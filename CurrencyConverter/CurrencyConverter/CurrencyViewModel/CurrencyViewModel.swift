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
    
    @Published private(set) var currency = CurrencyModel()
    
    private let userDefaultsKey = "converterList"
    
    init() {
        fetchCurrencies()
        loadConverterList()
        loadExchangeRates()
    }
    
    func fetchCurrencies() {
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
        let allCurrencies = currencies
        
        if searchText.isEmpty {
            fetchCurrencies()
        } else {
            currencies = allCurrencies.filter { currency in
                currency.name.lowercased().contains(searchText.lowercased()) ||
                currency.code.lowercased().contains(searchText.lowercased())
            }
        }
        

    }
    
    
    func updateConverterList(with currency: CurrencyModel) {
        if let existingCurrencyIndex = converterList.firstIndex(where: { $0.name == currency.name }) {
            converterList.remove(at: existingCurrencyIndex)
            if let indexInCurrencies = currencies.firstIndex(where: { $0.code == currency.code }) {
                currencies[indexInCurrencies].isSelected = false
            }
            return
        }
        
        let newCurrency = CurrencyModel(name: currency.name, code: currency.code, value: 0.0, isSelected: true)
        converterList.append(newCurrency)
        
        if let indexInCurrencies = currencies.firstIndex(where: { $0.code == currency.code }) {
            currencies[indexInCurrencies].isSelected = true
        }
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
    
    func loadConverterList() {
        guard let savedData = UserDefaults.standard.array(forKey: userDefaultsKey) as? [[String: Any]] else { return }
        converterList = savedData.compactMap { dict in
            if let name = dict["name"] as? String,
               let code = dict["code"] as? String,
               let value = dict["value"] as? Double {
                return CurrencyModel(name: name, code: code, value: value)
            }
            return nil
        }
        
        for currency in converterList {
            if let indexInCurrencies = currencies.firstIndex(where: { $0.code == currency.code }) {
                currencies[indexInCurrencies].isSelected = true
            }
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
