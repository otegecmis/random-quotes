import Foundation

struct UserResponse: Decodable {
    let result: User
}

struct User: Decodable {
    let id: String
    let name: String
    let surname: String
    let quotes: [Quote]
}

class UsersService {
    func getUser(userID: String, completion: @escaping (Result<User, Error>) -> Void) {
        guard let accessToken = UserDefaults.standard.string(forKey: "access_token") else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No access token found, please sign in again."])))
            return
        }
        
        let urlString = "\(Endpoints.Users.getUser)/\(userID)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
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
                    let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                    completion(.success(userResponse.result))
                } catch let decodingError {
                    print("Decoding Error: \(decodingError)")
                    completion(.failure(decodingError))
                }
            } else if httpResponse.statusCode == 401 {
                AuthService().refreshTokens { result in
                    switch result {
                    case .success:
                        self.getUser(userID: userID, completion: completion)
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            } else {
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
