import Foundation

struct Endpoints {
    static let baseURL = ""
    
    static func getBaseURL() -> String {
        return baseURL.isEmpty ? "http://localhost:8000/api" : baseURL
    }
    
    struct Auth {
        static let signIn = "\(getBaseURL())/users/login"
        static let refreshTokens = "\(getBaseURL())/users/refresh-tokens"
    }
    
    struct Users {
        static let getUser = "\(getBaseURL())/users"
    }
        
    struct Quotes {
        static let randomQuote = "\(getBaseURL())/quotes/random"
    }
}
