//
//  User.swift
//  homeBakery
//
//  Created by Somaiya on 11/07/1447 AH.
//

import Foundation

struct User: Codable, Identifiable {
    var id: String
    var name: String?
    var email: String?
    var password: String?
    
    func toUserRecord() -> UserRecord { UserRecord(fields: UserDto(name: name, email: email, password: password)) }
    
}

struct UserDto: Codable {
    var name: String?
    var email: String?
    var password: String?
}

struct UserRecord: Codable {
    var id: String?
    var fields: UserDto
    
    func toUser() -> User {
        return User(id: id ?? UUID().uuidString, name: fields.name ?? "", email: fields.email ?? "", password: fields.password ?? "")
    }
}

struct UsersApiResponse: Codable {
    var records: [UserRecord]
}
