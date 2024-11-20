import Foundation

enum СurrenciesServiceError: Error {
    case fileNotFound(resource: String, fileType: String)
    case decodingError
}

class СurrenciesService {
    func fetchCurrencies() throws -> [СurrenciesModel] {
        guard let filepath = Bundle.main.path(forResource: "Currencies", ofType: "json") else {
            throw СurrenciesServiceError.fileNotFound(resource: "Currencies", fileType: "json")
        }
        
        let data = try Data(contentsOf: URL(fileURLWithPath: filepath))
        let decodedData = try JSONDecoder().decode([String: СurrenciesModel].self, from: data)
        
        return Array(decodedData.values)
    }
}
