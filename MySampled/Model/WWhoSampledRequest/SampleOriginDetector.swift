import Foundation
import UIKit

// find Sample dest for information sample
class SampleOriginDetector {
    static let sharedInstance = SampleOriginDetector()
    private var sampleResult: RetrieveResultTrack?
    var sampleObject = [TrackSample]()

    var sendSampleInfo: (([TrackSample?]) -> Void)?

    class SampleOriginDetector {
        static let sharedInstance = SampleOriginDetector()

        func retrieveCurrentSample() async throws -> ([TrackSample]) {
            let resultTrack = RetrieveResultTrack.sharedInstance
            let artistInfo = try await resultTrack.fetchResultTrack()
            let artistId = artistInfo.id
            let samplesUrl = URL(string: "https://www.whosampled.com/apimob/v1/track-samples/?dest_track=\(artistId)&format=json")!

            let sampleResponse: TrackSampleResponse = try await NetworkService.shared.httpRequest(url: samplesUrl, expecting: TrackSampleResponse.self)

            return sampleResponse.objects ?? []
        }
    }
}

struct TrackSample: Codable {
    struct Artist: Codable {
        let artistName: String?
        let id: Int?
        let resourceUri: String?

        enum CodingKeys: String, CodingKey {
            case artistName = "artist_name"
            case id
            case resourceUri = "resource_uri"
        }
    }

    struct Track: Codable {
        let artist: Artist?
        let fullArtistName: String?
        let id: Int?
        let label: String?
        var minuteSample: String?
        let largeImageUrl: String?
        let mediumImageUrl: String?
        let releaseName: String?
        let releaseYear: String?
        let smallImageUrl: String?
        let spotifyId: String?
        let spotifyIdVerified: Bool?
        let trackName: String?
        let youtubeId: String?
        let youtubeSyndicate: Bool?

        enum CodingKeys: String, CodingKey {
            case artist
            case fullArtistName = "full_artist_name"
            case id
            case label
            case minuteSample = "minute_sample" // Ajustez si le nom JSON est différent
            case largeImageUrl = "large_image_url"
            case mediumImageUrl = "medium_image_url"
            case releaseName = "release_name"
            case releaseYear = "release_year"
            case smallImageUrl = "small_image_url"
            case spotifyId = "spotify_id"
            case spotifyIdVerified = "spotify_id_verified"
            case trackName = "track_name"
            case youtubeId = "youtube_id"
            case youtubeSyndicate = "youtube_syndicate"
        }
    }

    var destTrack: Track?
    let id: Int?
    let resourceUri: String?
    var sourceTrack: Track?

    enum CodingKeys: String, CodingKey {
        case destTrack = "dest_track"
        case id
        case resourceUri = "resource_uri"
        case sourceTrack = "source_track"
    }
}

struct TrackSampleResponse: Codable {
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

    let meta: Meta?
    let objects: [TrackSample]?

    enum CodingKeys: String, CodingKey {
        case meta
        case objects
    }
}
