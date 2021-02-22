```swift
import Foundation

class HttpRequest<T: Codable> {
    enum APIError: Error {
        case httpBodyJSONSerializationFailed
        case noData
    }
    
    let url: String
    
    init(url: String) {
        self.url = url
    }
    
    func get(completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: url) else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            if let searchResult = try? JSONDecoder().decode(T.self, from: data) {
                DispatchQueue.main.async {
                    completion(.success(searchResult))
                }
            }
        }

        task.resume()
    }
    
    func post(params: [String: Any]? = nil, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let serviceUrl = URL(string: url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        if let params = params {
            guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
                DispatchQueue.main.async {
                    completion(.failure(.httpBodyJSONSerializationFailed))
                }
                return
            }
            
            request.httpBody = httpBody
        }
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            if let searchResult = try? JSONDecoder().decode(T.self, from: data) {
                DispatchQueue.main.async {
                    completion(.success(searchResult))
                }
            }
        }.resume()
    }
}
```
