//
//  ViewControllerExtension.swift
//  MySampled
//
//  Created by Lion on 29/12/2023.
//

import Foundation



extension String {
    func formattedTrackName() -> String {
        self.replacingOccurrences(of: " ", with: "%20")
            .replacingOccurrences(of: "’", with: "")
            .replacingOccurrences(of: "'", with: "'")
            .replacingOccurrences(of: "?", with: "")
            .replacingOccurrences(of: "é", with: "e")
            .replacingOccurrences(of: "à", with: "a")
            .replacingOccurrences(of: "-", with: "%20")
    }
    
    func removingAndContent() -> String {
        if let indexAnd = self.range(of: "&")  {
            return String(self[..<indexAnd.lowerBound])
        }
        return self
    }
    
    
    func removingContentInParenthesesAndBrackets() -> String {
        var result = self
        
        
        while let openParenthesisRange = result.range(of: "(") {
            if let closeParenthesisRange = result.range(of: ")", options: [], range: openParenthesisRange.upperBound..<result.endIndex) {
                result.removeSubrange(openParenthesisRange.lowerBound...closeParenthesisRange.lowerBound)
            } else {
                break
            }
        }
        
        // Supprimer tout après le premier crochet ouvrant "["
        if let bracketRange = result.range(of: "[") {
            result = String(result[..<bracketRange.lowerBound])
        }
        
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}
    



