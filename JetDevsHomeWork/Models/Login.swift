//
//  Login.swift
//  JetDevsHomeWork
//
//  Created by Jenson John on 30/01/23.
//

import Foundation

// MARK: - Login Response

struct LoginResponse: Codable {
    
    let result: Int?
    let errorMessage: String?
    let data: UserInfo?

    enum CodingKeys: String, CodingKey {
        case result, data
        case errorMessage = "error_message"
    }
    
}

// MARK: - Data Class

struct UserInfo: Codable {
    
    let user: User?
    
    enum CodingKeys: String, CodingKey {
        case user
    }
}

// MARK: - User

struct User: Codable {
    
    let userId: Int?
    let userName: String?
    let userProfileURL: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case userName = "user_name"
        case userProfileURL = "user_profile_url"
        case createdAt = "created_at"
    }
}

extension User {
    
    var createdAtDate: Date? {
        guard let createdAt = createdAt else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        let date = dateFormatter.date(from: createdAt)
        return date
    }
    var createDayAgo: Int {
        guard let createdAtDate = createdAtDate else {
            return 0
        }
        return Calendar.current.dateComponents([.day], from: createdAtDate, to: Date()).day!
    }
}
