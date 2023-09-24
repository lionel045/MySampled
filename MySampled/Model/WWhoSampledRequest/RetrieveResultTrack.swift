//
//  RetrieveTrackArtist.swift
//  WhoSampledApi
//
//  Created by Lion on 30/08/2023.
//

import Foundation

struct RetrieveResultTrack {
    
    static let sharedInstance = RetrieveResultTrack()
   
        
    
    private var artistId = 0
    var retrieveIdArtist : ((Int) ->())?
    
   // private init() {
  //      }
    
    func fetchResultTrack() {
         
        var resultRequest = SearchRequest.sharedInstance
        resultRequest.performSearch()
        resultRequest.ringBack = { idArtist in
            
            guard let url = URL(string: "https://www.whosampled.com/apimob/v1/track/\(idArtist)/?format=json")
            else {return}
            
            NetworkService.shared.httpRequest(url: url, expecting: ArtistInfo.self) {  result in
                
                switch result {
                case .success(let artist):
                    self.retrieveIdArtist?(artist.id)
                    print(artist.id)
                case .failure(let error):
                    print("Erreur : \(error)")
                }
            }
            
        }
        
    }
        
    }


    
struct ArtistInfo: Codable {
    struct Artist: Codable {
        let artist_name: String
        let cover_count: String
        let exists_as_artist: Bool
        let exists_as_producer: Bool
        let id: String
        let large_image_url: String
        let medium_image_url: String
        let remix_count: String
        let resource_uri: String
        let sample_count: String
        let small_image_url: String
    }

    struct Producer: Codable {
        let artist_name: String?
        let cover_count: String?
        let exists_as_artist: Bool?
        let exists_as_producer: Bool?
        let id: String?
        let large_image_url: String?
        let medium_image_url: String?
        let remix_count: String?
        let resource_uri: String?
        let sample_count: String?
        let small_image_url: String?
    }

    let artist: Artist
    let collab_artist1: String?
    let collab_artist2: String?
    let cover_count: Int
    let covered_count: Int
    let featuring_artist1: FeaturingArtist?
    let full_artist_name: String
    let genre: String
    let id: Int
    let label: String
    let large_image_url: String?
    let medium_image_url: String
    let producer1: Producer?
    let producer2: Producer?
    let release_name: String
    let release_year: String
    let remix_count: Int
    let remixed_count: Int
    let resource_uri: String
    let sample_count: Int
    let sampled_count: Int
    let small_image_url: String
    let spotify_id: String?
    let spotify_id_verified: Bool?
    let track_name: String
    let youtube_id: String
    let youtube_syndicate: Bool
}

struct FeaturingArtist: Codable {
    let artist_name: String
    let cover_count: String
    let exists_as_artist: Bool
    let exists_as_producer: Bool
    let id: String
    let large_image_url: String
    let medium_image_url: String
    let remix_count: String
    let resource_uri: String
    let sample_count: String
    let small_image_url: String
}
    

