import Foundation
import Security

final class TokenManager {
    static let shared = TokenManager()
    
    private init() {}
    
    private let accessToken = "access_token"
    private let refreshToken = "refresh_token"
    private let userID = "userID"
    
    func saveTokens(tokens: Tokens) {
        UserDefaults.standard.set(tokens.access_token, forKey: accessToken)
        UserDefaults.standard.set(tokens.refresh_token, forKey: refreshToken)
        UserDefaults.standard.set(tokens.userID, forKey: userID)
        UserDefaults.standard.synchronize()
    }
    
    func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: accessToken)
    }
    
    func getRefreshToken() -> String? {
        return UserDefaults.standard.string(forKey: refreshToken)
    }
    
    func getUserID() -> String? {
        return UserDefaults.standard.string(forKey: userID)
    }
    
    func clearTokens() {
        UserDefaults.standard.removeObject(forKey: accessToken)
        UserDefaults.standard.removeObject(forKey: refreshToken)
        UserDefaults.standard.removeObject(forKey: userID)
        UserDefaults.standard.synchronize()
    }
} 
