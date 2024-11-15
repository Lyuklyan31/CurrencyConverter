import Foundation

enum CurrencyServiceError: Error {
    case fileNotFound(resource: String, fileType: String)
    case decodingError
}

class CurrencyService {
    func fetchCurrencies() throws -> [CurrencyModel] {
        guard let filepath = Bundle.main.path(forResource: "Currencies", ofType: "json") else {
            throw CurrencyServiceError.fileNotFound(resource: "Currencies", fileType: "json")
        }
        
        let data = try Data(contentsOf: URL(fileURLWithPath: filepath))
        let decodedData = try JSONDecoder().decode([String: CurrencyModel].self, from: data)
        
        return Array(decodedData.values)
    }
}
