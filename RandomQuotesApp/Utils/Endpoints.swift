import Foundation

struct Endpoints {
    private static var baseURL: String {
#if DEBUG
        return "http://127.0.0.1:8000/api"
#else
        return "https://api.example.com"
#endif
    }
    
    private static func buildURL(_ path: String) -> String {
        return "\(baseURL)\(path)"
    }
    
    struct Auth {
        static let signIn = buildURL("/users/login")
        static let refreshTokens = buildURL("/users/refresh-tokens")
        static let logout = buildURL("/users/logout")
    }
    
    struct Users {
        static let getUser = buildURL("/users")
    }
    
    struct Quotes {
        static let createQuote = buildURL("/quotes")
        static let randomQuote = buildURL("/quotes/random")
        static let updateQuote = buildURL("/quotes")
        static let deleteQuote = buildURL("/quotes")
    }
}
