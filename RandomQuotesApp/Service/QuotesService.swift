import Foundation

enum QuoteServiceError: Error {
    case noData
    case invalidResponse
    case serverError(String)
    case decodingError
}

class QuotesService {
    func fetchRandomQuote(completion: @escaping (Result<Quote, Error>) -> Void) {
        guard let accessToken = UserDefaults.standard.string(forKey: "access_token") else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No access token found, please sign in again."])))
            return
        }
        
        var request = URLRequest(url: URL(string: Endpoints.Quotes.randomQuote)!)
        
        request.httpMethod = "GET"
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid Response"])))
                return
            }
            
            if httpResponse.statusCode == 200, let data = data {
                do {
                    let quoteResponse = try JSONDecoder().decode(QuoteResponse.self, from: data)
                    completion(.success(quoteResponse.result))
                } catch {
                    completion(.failure(error))
                }
            } else if httpResponse.statusCode == 401 {
                AuthManager.shared.refreshTokens { result in
                    switch result {
                    case .success:
                        self.fetchRandomQuote(completion: completion)
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            } else if httpResponse.statusCode == 429, let data = data {
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                    completion(.failure(NSError(domain: "", code: 429, userInfo: [NSLocalizedDescriptionKey: errorResponse.result.message])))
                } catch {
                    completion(.failure(NSError(domain: "", code: 429, userInfo: [NSLocalizedDescriptionKey: "Too many requests. Please try again later."])))
                }
            }  else {
                if let data = data, let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorResponse.result.message])))
                } else {
                    completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unknown Error"])))
                }
            }
        }
        
        task.resume()
    }
}
