
//Send to the vc any information of sample
class ResultSample {
    
    static let sharedInstance = ResultSample()
    var sampleSource: [TrackSample] = []
    var sampleDest: [TrackSample] = []
    
    var artistsSrcSet = Set<String>()
    var artistsDestSet = Set<String>()
    
    private func processSample(sample: TrackSample?, isSource: Bool) {
        guard let artistName = isSource ? sample?.source_track?.full_artist_name : sample?.dest_track?.full_artist_name,
              let trackName = isSource ? sample?.source_track?.track_name : sample?.dest_track?.track_name,
              let minute = isSource ? sample?.source_track?.minuteSample : sample?.dest_track?.minuteSample
        else {
            return
        }
        
        print("Artiste \(isSource ? "sampler" : "qui a samplé") : \(artistName), Son : \(trackName) à la \(minute) ")
    }
    
    // Traitement des samples
    func displayTrack() async -> ([TrackSample?], [TrackSample?]) {
        let originDetector = SampleOriginDetector.sharedInstance
        let sampledIn = SampledIn.sharedInstance
        let sampledMinute = SampleMinute.sharedInstance
         sampleSource = []
         sampleDest  = []
        
        do {
           
            let sourceSamples = try await originDetector.retrieveCurrentSample()
            let (minuteOrigin,minuteSource) = try await sampledMinute.retrieveMinuteSample()
            
            for (index, var sample) in sourceSamples.enumerated() {
                guard let artistName = sample.source_track?.full_artist_name else { continue }
                
                if !artistsSrcSet.contains(artistName) {
                    sample.source_track?.minuteSample = minuteOrigin[index]?.source_timing
                    processSample(sample: sample, isSource: true)
                    artistsSrcSet.insert(artistName)
                    sampleSource.append(sample)
                }
            }
            
            let destSamples = try await sampledIn.wasSampledIn()
            
            for (index,var sample) in destSamples.enumerated() {
                guard let artistName = sample.dest_track?.full_artist_name else {continue}
                if !artistsDestSet.contains(artistName){
                    sample.dest_track?.minuteSample = minuteSource[index]?.dest_timing
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
