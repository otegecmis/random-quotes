import Foundation

struct Tokens: Codable {
    let access_token: String
    let refresh_token: String
    let userID: String
}

struct LoginResponse: Codable {
    let result: Tokens
}

class AuthService {
    static func signIn(credentials: [String: String], completion: @escaping (Result<Tokens, Error>) -> Void) {
        var request = URLRequest(url: URL(string: Endpoints.Auth.signIn)!)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: credentials, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                
                debugPrint("----- Sign In Response -----")
                debugPrint("Access Token: \(decodedResponse.result.access_token)")
                debugPrint("Refresh Token: \(decodedResponse.result.refresh_token)")
                debugPrint("User ID: \(decodedResponse.result.userID)")
                debugPrint("----------------------------")
                
                UserDefaults.standard.set(decodedResponse.result.access_token, forKey: "access_token")
                UserDefaults.standard.set(decodedResponse.result.refresh_token, forKey: "refresh_token")
                UserDefaults.standard.set(decodedResponse.result.userID, forKey: "userID")
                UserDefaults.standard.synchronize()
                
                completion(.success(decodedResponse.result))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func refreshTokens(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let refreshToken = UserDefaults.standard.string(forKey: "refresh_token") else {
            let msg: String = "No refresh token found, please sign in again."
            
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: msg])))
            return
        }
        
        var request = URLRequest(url: URL(string: Endpoints.Auth.refreshTokens)!)
        
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
                let msg: String = "Invalid Response"
                
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: msg])))
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
