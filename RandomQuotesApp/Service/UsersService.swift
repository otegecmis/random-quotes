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
        let endpoint = "\(Endpoints.Users.getUser)/\(userID)"
        
        NetworkManager.shared.request(
            endpoint: endpoint,
            method: .get
        ) { (result: Result<UserResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
