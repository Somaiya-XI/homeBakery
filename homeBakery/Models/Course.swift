//
//  Course.swift
//  homeBakery
//
//  Created by Somaiya on 09/07/1447 AH.
//

import Foundation

// Course Object for Views
struct Course: Codable, Identifiable {
    var id: String
    var title: String
    var level: String
    var locationName: String
    var locationLatitude: Double
    var locationLongitude: Double
    var chefId: String
    var startDate: Int
    var endDate: Int
    var description: String
    var imageUrl: String
    
    init(from: CourseRecord){
        self.id = from.id
        self.title = from.fields.title
        self.level = from.fields.level
        self.locationName = from.fields.imageUrl
        self.locationLatitude = from.fields.locationLatitude
        self.locationLongitude = from.fields.locationLongitude
        self.chefId = from.fields.chefId
        self.startDate = from.fields.startDate
        self.endDate = from.fields.endDate
        self.description = from.fields.description
        self.imageUrl = from.fields.imageUrl
    }

}

// Course obj with API fields
struct CourseDto: Codable {
    var title: String
    var level: String
    var locationName: String
    var locationLatitude: Double
    var locationLongitude: Double
    var chefId: String
    var startDate: Int
    var endDate: Int
    var description: String
    var imageUrl: String
}

// Course Object with JSON format
struct CourseRecord: Codable {
    var id: String
    var fields: CourseDto
    
    func toCourse() -> Course {
        Course(from: self)
    }
}

struct CoursesApiResponse: Codable {
    var records: [CourseRecord]
}
