import Foundation
// make query in the api for retrieve the track
class SearchRequest {
    static let sharedInstance = SearchRequest()
    private var artistId = 0
    var resultTitle = RetrieveResultTrack.sharedInstance
    var ringBack: ((Int) -> Void)?
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
                for sampleResult in result where sampleResult.fullArtistName?.lowercased().contains(artist) == true {
                    return sampleResult.id
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

    enum CodingKeys: String, CodingKey {
        case meta
        case objects
    }
}

struct TrackRequest: Codable {
    let fullArtistName: String?
    let id: Int?
    let label: String?
    let largeImageUrl: String?
    let mediumImageUrl: String?
    let releaseName: String?
    let releaseYear: String?
    let smallImageUrl: String?
    let spotifyId: String?
    let spotifyIdVerified: Bool?
    let trackName: String?

    enum CodingKeys: String, CodingKey {
        case fullArtistName = "full_artist_name"
        case id
        case label
        case largeImageUrl = "large_image_url"
        case mediumImageUrl = "medium_image_url"
        case releaseName = "release_name"
        case releaseYear = "release_year"
        case smallImageUrl = "small_image_url"
        case spotifyId = "spotify_id"
        case spotifyIdVerified = "spotify_id_verified"
        case trackName = "track_name"
    }
}

struct Meta: Codable {
    let limit: Int?
    let next: String?
    let offset: Int?
    let previous: String?
    let totalCount: Int?

    enum CodingKeys: String, CodingKey {
        case limit
        case next
        case offset
        case previous
        case totalCount = "total_count"
    }
}
