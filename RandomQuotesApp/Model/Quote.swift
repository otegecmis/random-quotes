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
