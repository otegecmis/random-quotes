import Foundation

struct EmptyResponse: Codable {}

struct QuoteResponse: Decodable {
    let result: Quote
}

struct Quote: Decodable {
    let id: String
    let quote: String
    let author: String
    let information: QuoteInformation?
}

struct QuoteInformation: Decodable {
    let userID: String
}

class QuotesService {
    func createQuote(quoteText: String, author: String, completion: @escaping (Result<Quote, Error>) -> Void) {
        let body = [
            "quote": quoteText,
            "author": author
        ]
        
        let endpoint = Endpoints.Quotes.createQuote
        
        NetworkManager.shared.request(
            endpoint: endpoint,
            method: .post,
            body: body
        ) { (result: Result<QuoteResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchRandomQuote(completion: @escaping (Result<Quote, Error>) -> Void) {
        let endpoint = Endpoints.Quotes.randomQuote
        
        NetworkManager.shared.request(
            endpoint: endpoint,
            method: .get
        ) { (result: Result<QuoteResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateQuote(quoteID: String, quoteText: String, author: String, completion: @escaping (Result<Quote, Error>) -> Void) {
        let body = [
            "quote": quoteText,
            "author": author
        ]
        
        let endpoint = "\(Endpoints.Quotes.updateQuote)/\(quoteID)"
        
        NetworkManager.shared.request(
            endpoint: endpoint,
            method: .put,
            body: body
        ) { (result: Result<QuoteResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteQuote(quoteID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let endpoint = "\(Endpoints.Quotes.deleteQuote)/\(quoteID)"
        
        NetworkManager.shared.request(
            endpoint: endpoint,
            method: .delete
        ) { (result: Result<EmptyResponse, Error>) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
