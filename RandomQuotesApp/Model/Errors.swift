struct ErrorResponse: Decodable {
    let result: ErrorResult
}

struct ErrorResult: Decodable {
    let message: String
}
