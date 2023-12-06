//
//  ImageDownloadService.swift
//  MySampled
//
//  Created by Lion on 29/11/2023.
//

import Foundation
import UIKit


class ImageDownloadService {
    
    func downloadImage(artistImage: String) async throws -> UIImage? {
        
        guard let url = URL(string: artistImage) else {
     
            return nil
        }
        
        let request = URLRequest(url: url)
        
        let (data,_) = try await URLSession.shared.data(for: request)
        
        guard let image = (UIImage(data: data)) else {
            print("Impossible de charger l'image")
            return nil
        }

        return image
    }
        
        
    
    
    
    
}
