import Foundation

struct Tokens: Codable {
    let access_token: String
    let refresh_token: String
    let userID: String
}

struct LoginResponse: Codable {
    let result: Tokens
}

final class AuthManager {
    static let shared = AuthManager()
    
    private init() {}
    
    func signIn(credentials: [String: String], completion: @escaping (Result<Tokens, Error>) -> Void) {
        NetworkManager.shared.request(
            endpoint: Endpoints.Auth.signIn,
            method: .post,
            body: credentials,
            requiresAuth: false
        ) { (result: Result<LoginResponse, Error>) in
            switch result {
            case .success(let response):
                self.saveTokens(tokens: response.result)
                completion(.success(response.result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func refreshTokens(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let refreshToken = TokenManager.shared.getRefreshToken() else {
            completion(.failure(NetworkError.unauthorized))
            return
        }
        
        let body = ["refreshToken": refreshToken]
        
        NetworkManager.shared.request(
            endpoint: Endpoints.Auth.refreshTokens,
            method: .put,
            body: body,
            requiresAuth: false
        ) { (result: Result<LoginResponse, Error>) in
            switch result {
            case .success(let response):
                self.saveTokens(tokens: response.result)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        NetworkManager.shared.request(
            endpoint: Endpoints.Auth.logout,
            method: .post,
            requiresAuth: true
        ) { (result: Result<EmptyResponse, Error>) in
            TokenManager.shared.clearTokens()
            completion(.success(()))
        }
    }
    
    private func saveTokens(tokens: Tokens) {
        TokenManager.shared.saveTokens(tokens: tokens)
    }
}
