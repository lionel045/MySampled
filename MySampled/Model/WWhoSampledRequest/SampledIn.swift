import Foundation

class SampledIn {
    
    static let sharedInstance = SampledIn()
    var sampleInfo = ResultSample()
    var sendSampleOriginData: (([TrackSample?]) -> ())?
    private var sampleResult: RetrieveResultTrack?
    private init() {
    }
    
    // fetch Sample source if the song was sampled
    class SampledIn {
        
        static let sharedInstance = SampledIn()
        var sampleInfo = ResultSample()
        
        func wasSampledIN() async throws -> [TrackSample] {
            let resultTrack = RetrieveResultTrack.sharedInstance
            let artistInfo = try await resultTrack.fetchResultTrack()
            let artistId = artistInfo.id
            
            let samplesUrl = URL(string: "https://www.whosampled.com/apimob/v1/track-samples/?source_track=\(artistId)&format=json&limit=5")!
            
            let sampleResponse: TrackSampleResponse = try await NetworkService.shared.httpRequest(url: samplesUrl, expecting: TrackSampleResponse.self)
            return sampleResponse.objects ?? []
        }
    }

    
    
}
