import Foundation


class SampleOriginDetector {
    
    static let sharedInstance = SampleOriginDetector()
    private var sampleResult: RetrieveResultTrack?
    var sampleObject = [TrackSample]()

    var sendSampleInfo: (([TrackSample?]) ->())?
    
    func retrieveCurrentSample() {
        sampleResult = RetrieveResultTrack.sharedInstance
        
        sampleResult?.retrieveIdArtist = { id in
            
            guard let url = URL(string: "https://www.whosampled.com/apimob/v1/track-samples/?dest_track=\(id)&format=json") else { return }
            
            NetworkService.shared.httpRequest(url: url, expecting: TrackSampleResponse.self) {  result in
                
                switch result {
                case .success(let artist):
                    if let artistSample = artist.objects {
                        var sampleInfo = ResultSample()
                        for sample in artistSample {

                            self.sampleObject.append(sample)
                        }
                        
                        self.sendSampleInfo?(self.sampleObject)
                        self.sampleObject.removeAll()
                      
                    }
                    
                case .failure(let error):
                    print("Erreur : \(error)")
                }
            }
            
        }
        sampleResult?.fetchResultTrack()
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
    let source_track: Track?
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

