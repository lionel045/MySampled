//
//  ImageService.swift
//  MySampled
//
//  Created by Lion on 10/12/2023.
//

import Foundation
import UIKit
class ImageService {
    static let shared = ImageService()

    func downloadImage(from urlString: String) async throws -> UIImage? {
        guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
        let (data, _) = try await URLSession.shared.data(from: url)
        return UIImage(data: data)
    }

}
enum NetworkError: Error {
    case invalidURL, downloadFailed
}
