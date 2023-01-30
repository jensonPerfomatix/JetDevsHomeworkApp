//
//  String+JetDevs.swift
//  JetDevsHomeWork
//
//  Created by Jenson John on 30/01/23.
//

import Foundation

extension String {
    
    func isValidEmail() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: self.count)) != nil
            
        } catch {
            return false
        }
    }
}
