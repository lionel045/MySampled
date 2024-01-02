import Foundation
// Api class for shazam request

class ApiRequest {
    static let sharedInstance = ApiRequest()

    let boundary = "---011000010111000001101001"
    var headers: [String: String] {
        [
            "content-type": "multipart/form-data; boundary=\(boundary)",
            "X-RapidAPI-Key": apiKey,
            "X-RapidAPI-Host": "shazam-api6.p.rapidapi.com"
        ]
    }

    // Obtient la clé API à partir du fichier ApiKey.plist
    private var apiKey: String {
        guard let key = Bundle.main.apiKey(named: "X-RapidAPI-Key") else {
            fatalError("API Key not found in ApiKey.plist")
        }
        return key
    }

    // Fonction async pour envoyer une requête à l'API
    func sendSongApi(_ relativePath: URL) async throws -> ShazamResponse {
        let url = URL(string: "https://shazam-api6.p.rapidapi.com/shazam/recognize/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers

        let parameters = [
            [
                "name": "upload_file",
                "fileName": "recording.m4a",
                "contentType": "audio/mpeg"
            ]
        ]

        var body = Data()
        for param in parameters {
            let paramName = param["name"]!

            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(param["fileName"]!)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(param["contentType"]!)\r\n\r\n".data(using: .utf8)!)

            if let fileData = try? Data(contentsOf: relativePath) {
                body.append(fileData)
                body.append("\r\n".data(using: .utf8)!)
            } else {
                print("Impossible de lire le fichier \(param["fileName"]!)")
            }
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        return try decoder.decode(ShazamResponse.self, from: data)
    }
}

extension Bundle {
    func apiKey(named name: String) -> String? {
        if let url = url(forResource: "ApiKey", withExtension: "plist"),
           let data = try? Data(contentsOf: url),
           let config = try? PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil) as? [String: Any] {
            return config[name] as? String
        }
        return nil
    }
}

struct ShazamResponse: Codable {
    let status: Bool?
    let result: ShazamResult?
}

struct ShazamResult: Codable {
    let matches: [Match]?
    let location: Location?
    let timestamp: Int?
    let timezone: String?
    let track: Track?
    let tagid: String?
}

struct Match: Codable {
    let id: String?
    let offset: Double?
    let timeskew: Double?
    let frequencyskew: Double?
}

struct Location: Codable {
    let accuracy: Double?
}

struct Track: Codable {
    let layout: String?
    let type: String?
    let key: String?
    let title: String?
    let subtitle: String?
    let images: Images?
    let share: Share?
    let hub: Hub?
    let sections: [Section]?
    let url: String?
    let artists: [Artist]?
    let isrc: String?
    let genres: Genres?
    let urlparams: UrlParams?
    let myshazam: MyShazam?
    let highlightsurls: HighlightsUrls?
    let relatedtracksurl: String?
    let albumadamid: String?
}

struct Images: Codable {
    let background: String?
    let coverart: String?
    let coverarthq: String?
    let joecolor: String?
}

struct Share: Codable {
    let subject: String?
    let text: String?
    let href: String?
    let image: String?
    let twitter: String?
    let html: String?
    let avatar: String?
    let snapchat: String?
}

struct Hub: Codable {
    let type: String?
    let image: String?
    let actions: [HubAction]?
    let options: [HubOption]?
    let providers: [HubProvider]?
    let explicit: Bool?
    let displayname: String?
}

struct HubAction: Codable {
    let name: String?
    let type: String?
    let id: String?
    let uri: String?
}

struct HubOption: Codable {
    let caption: String?
    let actions: [HubAction]?
    let beacondata: BeaconData?
    let image: String?
    let type: String?
    let listcaption: String?
    let overflowimage: String?
    let colouroverflowimage: Bool?
    let providername: String?
}

struct HubProvider: Codable {
    let caption: String?
    let images: ProviderImages?
    let actions: [HubAction]?
    let type: String?
}

struct ProviderImages: Codable {
    let overflow: String?
    let `default`: String?
}

struct BeaconData: Codable {
    let type: String?
    let providername: String?
}

struct Section: Codable {
    let type: String?
    let metapages: [Metapage]?
    let tabname: String?
    let metadata: [Metadata]?
    let text: [String]?
    let url: String?
    let footer: String?
    let youtubeurl: String?
}

struct Metapage: Codable {
    let image: String?
    let caption: String?
}

struct Metadata: Codable {
    let title: String?
    let text: String?
}

struct Artist: Codable {
    let id: String?
    let adamid: String?
}

struct Genres: Codable {
    let primary: String?
}

struct UrlParams: Codable {
    let tracktitle: String?
    let trackartist: String?
}

struct MyShazam: Codable {
    let apple: MyShazamApple?
}

struct MyShazamApple: Codable {
    let actions: [HubAction]?
}

struct HighlightsUrls: Codable {
    let artisthighlightsurl: String?
}
