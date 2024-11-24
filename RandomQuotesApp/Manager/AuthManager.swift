import Foundation

class AuthManager {
    static let shared = AuthManager()
    
    private init() {}
    
    func refreshTokens(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let refreshToken = UserDefaults.standard.string(forKey: "refresh_token") else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No refresh token found, please sign in again."])))
            return
        }
        
        var request = URLRequest(url: URL(string: Endpoints.Users.refreshTokens)!)
        
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["refreshToken": refreshToken]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
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
                    let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                    
                    debugPrint("----- Refresh Tokens Response -----")
                    debugPrint("Access Token: \(loginResponse.result.access_token)")
                    debugPrint("Refresh Token: \(loginResponse.result.refresh_token)")
                    debugPrint("User ID: \(loginResponse.result.userID)")
                    debugPrint("-----------------------------------")
                    
                    UserDefaults.standard.setValue(loginResponse.result.access_token, forKey: "access_token")
                    UserDefaults.standard.setValue(loginResponse.result.refresh_token, forKey: "refresh_token")
                    UserDefaults.standard.setValue(loginResponse.result.userID, forKey: "userID")
                    UserDefaults.standard.synchronize()
                    
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            } else {
                if let data = data {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                        completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorResponse.result.message])))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown Error"])))
                }
            }
        }
        
        task.resume()
    }
}
