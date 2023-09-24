class ResultSample {
    
    static let sharedInstance = ResultSample()
    var sampleCallback: ((String?, String?) -> ())?
    
    func displayTrack() {
        let resultContainSample = SampleOriginDetector.sharedInstance
        let resultWasSampledIn = SampledIn.sharedInstance
        

        // Configurer le callback pour la première fonction
        resultContainSample.sendSampleInfo = { containSample in
            var sourceArtistsSet = Set<String>()

            for sample in containSample {

                if let sourceArtistName = sample?.source_track?.full_artist_name,
                   var trackName = sample?.source_track?.track_name,
                   !sourceArtistsSet.contains(sourceArtistName) {
                    
                    var artistName = sourceArtistName
                    
                    print("Voici l'artist sampler: \(artistName) et voici le son : \(trackName)")
                    
                    self.sampleCallback?(sourceArtistName, nil)
                    
                    sourceArtistsSet.insert(artistName)
                    artistName = ""
                    trackName = ""
                    
                }
            }
            sourceArtistsSet.removeAll()
            // Une fois que le callback est terminé, appeler la deuxième fonction
            resultWasSampledIn.wasSampledIN()
        }
        
        // Configurer le callback pour la deuxième fonction
        resultWasSampledIn.sendSampleOriginData = { wasSampled in
            var destArtistsSet = Set<String>()
            for sample in wasSampled {

                if var destArtistName = sample?.dest_track?.full_artist_name,
                   var trackName = sample?.dest_track?.track_name,
                   !destArtistsSet.contains(destArtistName) {

                    print("Voici l'artiste qui a sampler : \(destArtistName) et voici le son avec le qu'elle a sampler: \(trackName)")
                    
                                        self.sampleCallback?(nil, destArtistName)
                    destArtistsSet.insert(destArtistName)
                    destArtistName = ""
                    trackName = ""
                }
                
            }
            destArtistsSet.removeAll()
            
        }
        
        // Appeler la première fonction
        resultContainSample.retrieveCurrentSample()
    }
}
