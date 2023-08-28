//
//  WebScrap.swift
//  MySampled
//
//  Created by Lion on 25/08/2023.
//
import SwiftSoup
import Foundation



class WebScrap {
    static let sharedInstance = WebScrap()
    
    
    
    func retrieveData(currentUrl: String? ){
        
        if let unwrappedUrl = currentUrl, let url = URL(string: unwrappedUrl) {
            
            let session = URLSession.shared
            
            let dataTask = session.dataTask(with: url) { data, response, error in
                
                if let error = error {
                    print("Erreur lors de l'envoi de la requête : \(error.localizedDescription)")
                    return
                }
                
                guard let data = data, error == nil else {
                    print("Aucune donnée reçue.")
                    return
                }
                do {
                    let html = try String(contentsOf: url)
                    let doc = try SwiftSoup.parse(html)
                    
                    let selector = "#content > div > div.leftContent > section:nth-child(5) > div > div > a"
                    let links = try doc.select(selector)
                    
                    for link in links {
                        
                        if let title = try? link.attr("title") {
                            print("Link Title: \(title)")
                            
                            if let img = try? link.select("img").first(),
                               let src = try? img.attr("src") {
                                print("Image Source: \(src)")
                            }
                        }
                    }
                } catch {
                    print("Erreur lors de la récupération de la page HTML: \(error)")
                }
                
            }
            
            
            dataTask.resume()
        }
        else {
            print("Aucune source trouver")
            
            
        }
    }
    
}
