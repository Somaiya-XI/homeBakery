//
//  UserService.swift
//  homeBakery
//
//  Created by Somaiya on 11/07/1447 AH.
//

import Foundation

struct UserService {
    
    func getAllUsers() async throws -> [User] {
        let endpoint = "\(Config.airtableAPI)/user"
        
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
            let apiUsers =  try decoder.decode(UsersApiResponse.self, from: data)
            
            // Convert to the AppView Data
            var users: [User] = []
            
            for user in apiUsers.records {
                users.append(user.toUser())
            }
            
            return users
            
        } catch { throw APIError.decoding(error) }
    }
    
    func updateUser(id: String, _ user: User) async throws -> User {
        let endpoint = "\(Config.airtableAPI)/user/\(id)"
        
        let userData = user.toUserRecord()
        guard let url = URL(string: endpoint) else { throw APIError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            
            request.httpBody = try encoder.encode(userData)
            request.setValue(Config.token, forHTTPHeaderField: "Authorization")
        }
        catch {
            throw APIError.invalidData
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,                   (200...299).contains(httpResponse.statusCode)
        else { throw APIError.invalidResponse }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let apiUser = try decoder.decode(UserRecord.self, from: data)
            let updatedUser = apiUser.toUser()
            
            return updatedUser
            
        } catch { throw APIError.decoding(error) }
        
    }
    
}

import Playgrounds

#Playground {
    let service = UserService()
    do {
                
        try await service.getAllUsers()
        let u = User(id: "", name: "New Name")
        //try await service.updateUser(id: "recK8QGYcpM8667s9", u)
        

    } catch {
        print(error)
    }
}
