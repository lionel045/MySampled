//
//  SampleMinute.swift
//  MySampled
//
//  Created by Lion on 25/12/2023.
//

import Foundation

class SampleMinute {
    static let sharedInstance = SampleMinute()
    private init() {}

    func retrieveMinuteSample() async throws -> ([SampleInfo?], [SampleInfo?]) {
        let trackSampleArrayOrigin = try await SampleOriginDetector.sharedInstance.retrieveCurrentSample()
        let trackSampleArraySource = try await SampledIn.sharedInstance.wasSampledIn()

        let originResponses = try await processSamples(trackSampleArrayOrigin)
        let sourceResponses = try await processSamples(trackSampleArraySource)

        return (originResponses, sourceResponses)
    }

    private func processSamples(_ trackSamples: [TrackSample]) async throws -> [SampleInfo?] {
        var jsonResponses = [SampleInfo?]()

        for sample in trackSamples {
            guard let sampleId = sample.id,
                  let url = URL(string: "https://www.whosampled.com/apimob/v1/sample/\(sampleId)/?format=json") else {
                continue
            }

            do {
                let jsonResponse = try await NetworkService.shared.httpRequest(url: url, expecting: SampleInfo.self)
                jsonResponses.append(jsonResponse)
            } catch {
                print("Erreur lors de la récupération des données pour l'ID \(sampleId): \(error)")
            }
        }

        return jsonResponses
    }
}

struct SampleInfo: Codable {
    let sampletype: String?
    let sourcetiming: String?
    let desttiming: String?

    enum CodingKeys: String, CodingKey {

        case sampletype = "sample_type"
        case sourcetiming = "source_timing"
        case desttiming = "dest_timing"
    }

}
