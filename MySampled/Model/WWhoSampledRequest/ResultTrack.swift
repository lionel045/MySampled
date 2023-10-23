class ResultSample {
    
    static let sharedInstance = ResultSample()
    var sampleCallback: ((String?, String?) -> ())?
    
    func displayTrack() {
        let resultContainSample = SampleOriginDetector.sharedInstance
        let resultWasSampledIn = SampledIn.sharedInstance
        
        var sourceArtistsSet = Set<String>()
        var destArtistsSet = Set<String>()
        
        // Configurer le callback pour la première fonction
        resultContainSample.sendSampleInfo = { containSample in
            for sample in containSample {
                if let sourceArtistName = sample?.source_track?.full_artist_name,
                   let trackName = sample?.source_track?.track_name,
                   !sourceArtistsSet.contains(sourceArtistName) {
                    
                    print("Voici l'artist sampler: \(sourceArtistName) et voici le son : \(trackName)")
                    
                    self.sampleCallback?(sourceArtistName, nil)
                    
                    sourceArtistsSet.insert(sourceArtistName)
                }
            }
            
            resultWasSampledIn.wasSampledIN()
        }
                // Configurer le callback pour la deuxième fonction
        resultWasSampledIn.sendSampleOriginData = { wasSampled in
            for sample in wasSampled {
                if let destArtistName = sample?.dest_track?.full_artist_name,
                   let trackName = sample?.dest_track?.track_name,
                   !destArtistsSet.contains(destArtistName) {
                    
                    print("Voici l'artiste qui a sampler : \(destArtistName) et voici le son avec lequel il a sampler: \(trackName)")
                    
                    self.sampleCallback?(nil, destArtistName)
                    
                    destArtistsSet.insert(destArtistName)
                }
            }
        }
        // Appeler la première fonction
        resultContainSample.retrieveCurrentSample()
        
        // Réinitialiser les ensembles après le traitement
        sourceArtistsSet.removeAll()
        destArtistsSet.removeAll()
    }
}
