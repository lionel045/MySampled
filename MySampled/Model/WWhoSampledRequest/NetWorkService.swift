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
        
        request.setValue("Digest username=\"f811o0f7klopw8f88dosn39l8dlai3nx\", realm=\"apimob\", nonce=\"1701720515.6795354:BBFC:cb9ec07d72aeaa39e23e6d0b22ec39c8\", uri=\"/apimob/v1/search-artist/?q=tup&format=json&ac=1\", response=\"c15ae0a355a7d026f21b39a7219c7e19\", opaque=\"ee78f269db532c3871a921ed10d11d24ca7ff3fb\", algorithm=\"MD5\", cnonce=\"64888b6c4567afab9bc7b55568f264a6\", nc=00000003, qop=\"auth\"", forHTTPHeaderField: "Authorization")

        
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
