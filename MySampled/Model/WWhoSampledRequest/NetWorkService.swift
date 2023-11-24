import Foundation

class NetworkService {
    
    enum CustomError: Error {
        case invalidUrl
        case invalidData
    }
    
    static let shared = NetworkService()
    
    func httpRequest<T: Codable>(url: URL?, expecting: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = url else {
            completion(.failure(CustomError.invalidUrl))
            return
        }
        var request = URLRequest(url: url)

        request.setValue("www.whosampled.com", forHTTPHeaderField: "Host")
        request.setValue("WhoSampled 1.41.3 rv:2 (iPad; iPadOS 16.6; en_FR)", forHTTPHeaderField: "User-Agent")

        let session = URLSession.shared
        
        
        
        let task = session.dataTask(with: request) { data, _, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(CustomError.invalidData))
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                
                completion(.success(result))
            } catch {
                let str = String(decoding: data, as: UTF8.self)

                print(str)

                completion(.failure(error))
            
            }
        }
        task.resume()
    }
}
