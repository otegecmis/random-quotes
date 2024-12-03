import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case invalidResponse
    case unauthorized
    case serverError(String)
    case unknown
    case noInternetConnection
    case requestFailed(Int, String)
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    private let timeoutInterval: TimeInterval = 60
    
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        body: [String: Any]? = nil,
        requiresAuth: Bool = true,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard ReachabilityManager.shared.checkConnection() else {
            completion(.failure(NetworkError.noInternetConnection))
            return
        }
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = timeoutInterval
        
        if requiresAuth {
            guard let token = TokenManager.shared.getAccessToken() else {
                completion(.failure(NetworkError.unauthorized))
                return
            }
            
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                completion(.failure(error))
                return
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                if method == .delete {
                    completion(.success(EmptyResponse() as! T))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NetworkError.noData))
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(NetworkError.decodingError))
                }
                
            case 401:
                AuthManager.shared.refreshTokens { result in
                    switch result {
                    case .success:
                        print("DEBUG: Token refresh successful..")
                        self?.request(endpoint: endpoint, method: method, body: body, requiresAuth: requiresAuth, completion: completion)
                    case .failure(let error):
                        print("DEBUG: Token refresh failed: \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                }
                
            default:
                if let data = data {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                        completion(.failure(NetworkError.serverError(errorResponse.result.message)))
                    } catch {
                        completion(.failure(NetworkError.unknown))
                    }
                } else {
                    completion(.failure(NetworkError.unknown))
                }
            }
        }
        
        task.resume()
    }
}
