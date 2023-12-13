import Foundation
import UIKit


class SampleOriginDetector {
    
    static let sharedInstance = SampleOriginDetector()
    private var sampleResult: RetrieveResultTrack?
    var sampleObject = [TrackSample]()
    
    var sendSampleInfo: (([TrackSample?]) ->())?
    
    class SampleOriginDetector {
        
        static let sharedInstance = SampleOriginDetector()
        
        func retrieveCurrentSample() async throws -> [TrackSample] {
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
        let artist_name: String?
        let id: Int?
        let resource_uri: String?
    }
    
    struct Track: Codable {
        let artist: Artist?
        let full_artist_name: String?
        let id: Int?
        let label: String?
        let large_image_url: String?
        let medium_image_url: String?
        let release_name: String?
        let release_year: String?
        let small_image_url: String?
        let spotify_id: String?
        let spotify_id_verified: Bool?
        let track_name: String?
        let youtube_id: String?
        let youtube_syndicate: Bool?
    }
    
    let dest_track: Track?
    let id: Int?
    let resource_uri: String?
    var source_track: Track?
}

struct TrackSampleResponse: Codable {
    struct Meta: Codable {
        let limit: Int?
        let next: String?
        let offset: Int?
        let previous: String?
        let total_count: Int?
    }
    
    let meta: Meta?
    let objects: [TrackSample]?
}

