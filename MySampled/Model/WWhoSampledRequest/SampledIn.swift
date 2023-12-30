import Foundation

class SampledIn {

    static let sharedInstance = SampledIn()
    var sampleInfo = ResultSample()
    var sendSampleOriginData: (([TrackSample?]) -> Void)?
    private var sampleResult: RetrieveResultTrack?
    private init() {
    }

    // find if the current song retrieve with Shazam was sampled in other song
    class SampledIn {

        static let sharedInstance = SampledIn()
        var sampleInfo = ResultSample()

        func wasSampledIn() async throws -> [TrackSample] {
            let resultTrack = RetrieveResultTrack.sharedInstance
            let artistInfo = try await resultTrack.fetchResultTrack()
            let artistId = artistInfo.id

            let samplesUrl = URL(string: "https://www.whosampled.com/apimob/v1/track-samples/?source_track=\(artistId)&format=json&limit=6")!

            let sampleResponse: TrackSampleResponse = try await NetworkService.shared.httpRequest(url: samplesUrl, expecting: TrackSampleResponse.self)
            return sampleResponse.objects ?? []
        }
    }

}
