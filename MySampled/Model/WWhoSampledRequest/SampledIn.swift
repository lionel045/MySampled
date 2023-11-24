import Foundation

class SampledIn {
    
    static let sharedInstance = SampledIn()
    var sampleInfo = ResultSample()
    var sendSampleOriginData: (([TrackSample?]) -> ())?
    private var sampleResult: RetrieveResultTrack?
    private init() {
    }
    
    func wasSampledIN(){
        sampleResult = RetrieveResultTrack.sharedInstance
        sampleResult?.retrieveIdArtist = { idArtist in
            
            guard let url = URL(string: "https://www.whosampled.com/apimob/v1/track-samples/?source_track=\(idArtist)&format=json&limit=5") else { return }
            
            NetworkService.shared.httpRequest(url: url, expecting: TrackSampleResponse.self)  { result in
                
                switch result {
                case .success(let artist):
                    if let artist = artist.objects {
                        var sampleObject = [TrackSample]()
                        for sample in artist {
                            sampleObject.append(sample)
                        }
                        self.sendSampleOriginData?(sampleObject)
                        sampleObject.removeAll()
                    }
                    
                case .failure(let error):
                    print("Erreur : \(error)")
                }
            }
        }
        
        
       sampleResult?.fetchResultTrack()
    }
    
    
}
