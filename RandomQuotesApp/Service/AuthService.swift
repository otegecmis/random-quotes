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
        var request = URLRequest(url: URL(string: Endpoints.Users.signIn)!)
        
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
}
