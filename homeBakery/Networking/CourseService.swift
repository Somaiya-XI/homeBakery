//
//  CourseService.swift
//  homeBakery
//
//  Created by Somaiya on 09/07/1447 AH.
//

import Foundation

struct CourseService {
    
    func getAllCourses() async throws -> [Course] {
        let endpoint = "\(Config.airtableAPI)/course"
        
        // Declare the service url
        guard let url = URL(string: endpoint) else { throw APIError.invalidURL }
        
        // Add request details (Method, Auth)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(Config.token, forHTTPHeaderField: "Authorization")
        
        // Get data from the url
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Validate response isOk
        guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
        else { throw APIError.invalidResponse }
         
        // Decode data
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let apiCourses =  try decoder.decode(CoursesApiResponse.self, from: data)
            
            // Convert to the View Data
            var courses: [Course] = []
            
            for course in apiCourses.records {
                courses.append(course.toCourse())
            }
            
            return courses
            
        } catch { throw APIError.decoding(error) }
    }
    
    func getCourse(id: String) async throws -> Course {
        let endpoint = "\(Config.airtableAPI)/course/\(id)"
        
        // Declare the service url
        guard let url = URL(string: endpoint) else { throw APIError.invalidURL }
        
        // Add request details (Method, Auth)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(Config.token, forHTTPHeaderField: "Authorization")
        
        // Get data from the url
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Validate response isOk
        guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
        else { throw APIError.invalidResponse }
         
        // Decode data
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let apiCourse =  try decoder.decode(CourseRecord.self, from: data)
            
            return apiCourse.toCourse()
            
        } catch { throw APIError.decoding(error) }
    }
    
}



import Playgrounds

#Playground {
    let service = CourseService()
    do {
        let courses = try await service.getAllCourses()
        try await service.getCourse(id: courses.first!.id)
    } catch {
        print(error)
    }
}
