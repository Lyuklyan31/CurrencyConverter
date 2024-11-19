import Foundation

class RateService {
    func fetchRates() async throws -> RateModel {
        let apiKey = APIKeyProvider.getAPIKey()
        
        let urlString = "https://v6.exchangerate-api.com/v6/\(apiKey)/latest/USD"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedResponse = try JSONDecoder().decode(RateModel.self, from: data)
        
        return decodedResponse
    }
}
