//
//  Chef.swift
//  homeBakery
//
//  Created by Somaiya on 09/07/1447 AH.
//

import Foundation

// Chef Object with View Data
struct Chef: Codable, Identifiable {
    var id: String
    var name: String
    var email: String
    var password: String
}

// Chef Object with API Fields
struct ChefDto: Codable {
    var name: String
    var email: String
    var password: String
}

// Chef Object with JSON format
struct ChefRecord: Codable {
    var id: String
    var fields: ChefDto
    
    func toChef() -> Chef {
        Chef(
            id: id,
            name: fields.name,
            email: fields.email,
            password: fields.password
        )
    }
}

struct ChefsApiResponse: Codable {
    var records: [ChefRecord]
}
