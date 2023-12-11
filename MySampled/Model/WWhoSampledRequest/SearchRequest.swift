import Foundation
class SearchRequest {
    
    static let sharedInstance = SearchRequest()
    private var artistId = 0
    var resultTitle = RetrieveResultTrack.sharedInstance
    var ringBack : ((Int) -> ())?
    var myTuple: (artist: String, track: String) = ("", "")

    var myTupleValue: (artist: String, track: String) {
        get {
            return myTuple
        }
        set(newValue) {
            myTuple = newValue
        }
    }

    private init() {}

    func performSearch() async -> Int? {
        let track = myTupleValue.track
        let artist = myTupleValue.artist
        
        guard let url = URL(string: "https://www.whosampled.com/apimob/v1/search-track/?q=\(track)&auto=1&format=json") else {
            print("Invalid URL")
            return nil
        }
        
        do {
            let json = try await NetworkService.shared.httpRequest(url: url, expecting: TrackResponse.self)
            if let result = json.objects {
                for sampleResult in result {
                    if sampleResult.full_artist_name!.contains(artist) {
                        return sampleResult.id
                    }
                }
            }
        } catch {
            print("Erreur : \(error)")
        }
        return nil
    }
}


struct TrackResponse: Codable {
    let meta: Meta?
    let objects: [TrackRequest]?
}


struct TrackRequest: Codable {
    let full_artist_name: String?
    let id: Int?
    let label: String?
    let largeImageUrl: String?
    let medium_image_url: String?
    let release_name: String?
    let release_year: String?
    let small_image_url: String?
    let spotify_id: String?
    let spotify_id_verified: Bool?
    let track_name: String?
}

struct Meta: Codable {
    let limit: Int?
    let next: String?
    let offset: Int?
    let previous: String?
    let total_count: Int?
}
