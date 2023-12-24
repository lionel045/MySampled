
//Send to the vc any information of sample
class ResultSample {
    
    static let sharedInstance = ResultSample()
    var sampleSource: [TrackSample] = []
    var sampleDest: [TrackSample] = []
    
    var artistsSrcSet = Set<String>()
    var artistsDestSet = Set<String>()
    
    private func processSample(sample: TrackSample?, isSource: Bool) {
        guard let artistName = isSource ? sample?.source_track?.full_artist_name : sample?.dest_track?.full_artist_name,
              let trackName = isSource ? sample?.source_track?.track_name : sample?.dest_track?.track_name else {
            return
        }
        
        print("Artiste \(isSource ? "sampler" : "qui a samplé") : \(artistName), Son : \(trackName)")
    }
    
    // Traitement des samples
    func displayTrack() async -> ([TrackSample?], [TrackSample?]) {
        let originDetector = SampleOriginDetector.sharedInstance
        let sampledIn = SampledIn.sharedInstance
        
         sampleSource = []
         sampleDest  = []
        
        do {
            let sourceSamples = try await originDetector.retrieveCurrentSample()
            for sample in sourceSamples {
                guard let artistName = sample.source_track?.full_artist_name else { continue }
                if !artistsSrcSet.contains(artistName){
                    processSample(sample: sample, isSource: true)
                    artistsSrcSet.insert(artistName)
                    sampleSource.append(sample)
                }
            }
            
            let destSamples = try await sampledIn.wasSampledIN()
            for sample in destSamples {
                guard let artistName = sample.dest_track?.full_artist_name else {continue}
                if !artistsDestSet.contains(artistName){
                    processSample(sample: sample, isSource: false)
                    artistsDestSet.insert(artistName)
                    sampleDest.append(sample)
                }
                
            }
            print("il y a \(sampleSource.count) sample sur ce son, \(sampleDest.count) reprises dessus")
            return (sampleSource,sampleDest)
        } catch {
            print("Erreur : \(error)")
        }
        artistsDestSet.removeAll()
        artistsSrcSet.removeAll()
        return ([],[])
    }
}
