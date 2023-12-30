//
//  RetrieveResultTrack.swift
//  WhoSampledApi
//
//  Created by Lion on 30/08/2023.
//

import Foundation

enum CustomError: Error {
    case invalidUrl
    case artistNotFound
}

// find Sample dest if the song was sampled
class RetrieveResultTrack {
    static let sharedInstance = RetrieveResultTrack()

    private var artistId = 0
    func fetchResultTrack() async throws -> ArtistInfo {
        let resultRequest = SearchRequest.sharedInstance
        guard let idArtist = await resultRequest.performSearch() else {
            throw CustomError.artistNotFound
        }

        let artistUrl = URL(string: "https://www.whosampled.com/apimob/v1/track/\(idArtist)/?format=json")!

        let artist: ArtistInfo = try await NetworkService.shared.httpRequest(url: artistUrl, expecting: ArtistInfo.self)
        return artist
    }
}

struct ArtistInfo: Codable {
    struct Artist: Codable {
        let artistName: String
        let coverCount: String
        let existsAsArtist: Bool
        let existsAsProducer: Bool
        let id: String
        let largeImageUrl: String
        let mediumImageUrl: String
        let remixCount: String
        let resourceUri: String
        let sampleCount: String
        let smallImageUrl: String

        enum CodingKeys: String, CodingKey {
            case artistName = "artist_name"
            case coverCount = "cover_count"
            case existsAsArtist = "exists_as_artist"
            case existsAsProducer = "exists_as_producer"
            case id
            case largeImageUrl = "large_image_url"
            case mediumImageUrl = "medium_image_url"
            case remixCount = "remix_count"
            case resourceUri = "resource_uri"
            case sampleCount = "sample_count"
            case smallImageUrl = "small_image_url"
        }
    }

    struct Producer: Codable {
        let artistName: String?
        let coverCount: String?
        let existsAsArtist: Bool?
        let existsAsProducer: Bool?
        let id: String?
        let largeImageUrl: String?
        let mediumImageUrl: String?
        let remixCount: String?
        let resourceUri: String?
        let sampleCount: String?
        let smallImageUrl: String?
        enum CodingKeys: String, CodingKey {
            case artistName = "artist_name"
            case coverCount = "cover_count"
            case existsAsArtist = "exists_as_artist"
            case existsAsProducer = "exists_as_producer"
            case id
            case largeImageUrl = "large_image_url"
            case mediumImageUrl = "medium_image_url"
            case remixCount = "remix_count"
            case resourceUri = "resource_uri"
            case sampleCount = "sample_count"
            case smallImageUrl = "small_image_url"
        }
    }

    let artist: Artist
    let coverCount: Int
    let coveredCount: Int
    let featuringArtist1: FeaturingArtist?
    let fullArtistName: String
    let genre: String
    let id: Int
    let label: String
    let largeImageUrl: String?
    let mediumImageUrl: String
    let producer1: Producer?
    let producer2: Producer?
    let releaseName: String
    let releaseYear: String
    let remixCount: Int
    let remixedCount: Int
    let resourceUri: String
    let sampleCount: Int
    let sampledCount: Int
    let smallImageUrl: String
    let spotifyId: String?
    let spotifyIdVerified: Bool?
    let trackName: String?
    let youtubeId: String?
    let youtubeSyndicate: Bool?

    enum CodingKeys: String, CodingKey {
        case artist
        case coverCount = "cover_count"
        case coveredCount = "covered_count"
        case featuringArtist1 = "featuring_artist1"
        case fullArtistName = "full_artist_name"
        case genre
        case id
        case label
        case largeImageUrl = "large_image_url"
        case mediumImageUrl = "medium_image_url"
        case producer1
        case producer2
        case releaseName = "release_name"
        case releaseYear = "release_year"
        case remixCount = "remix_count"
        case remixedCount = "remixed_count"
        case resourceUri = "resource_uri"
        case sampleCount = "sample_count"
        case sampledCount = "sampled_count"
        case smallImageUrl = "small_image_url"
        case spotifyId = "spotify_id"
        case spotifyIdVerified = "spotify_id_verified"
        case trackName = "track_name"
        case youtubeId = "youtube_id"
        case youtubeSyndicate = "youtube_syndicate"
    }
}

struct FeaturingArtist: Codable {
    let artistName: String
    let coverCount: String
    let existsAsArtist: Bool
    let existsAsProducer: Bool
    let id: String
    let largeImageUrl: String
    let mediumImageUrl: String
    let remixCount: String
    let resourceUri: String
    let sampleCount: String
    let smallImageUrl: String

    enum CodingKeys: String, CodingKey {
        case artistName = "artist_name"
        case coverCount = "cover_count"
        case existsAsArtist = "exists_as_artist"
        case existsAsProducer = "exists_as_producer"
        case id
        case largeImageUrl = "large_image_url"
        case mediumImageUrl = "medium_image_url"
        case remixCount = "remix_count"
        case resourceUri = "resource_uri"
        case sampleCount = "sample_count"
        case smallImageUrl = "small_image_url"
    }
}
