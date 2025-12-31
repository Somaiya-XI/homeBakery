//
//  ChefService.swift
//  homeBakery
//
//  Created by Somaiya on 09/07/1447 AH.
//

import Foundation

struct ChefService {
    
    func getAllChefs() async throws -> [Chef] {
        let endpoint = "\(Config.airtableAPI)/chef"
        
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
            let apiChefs =  try decoder.decode(ChefsApiResponse.self, from: data)
            
            // Convert to the AppView Data
            var chefs: [Chef] = []
            
            for chef in apiChefs.records {
                chefs.append(chef.toChef())
            }
            return chefs
            
        } catch { throw APIError.decoding(error) }
    }
    
    func getChef(id: String) async throws -> Chef {
        let endpoint = "\(Config.airtableAPI)/chef/\(id)"
        
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
            let apiChef =  try decoder.decode(ChefRecord.self, from: data)
            
            return apiChef.toChef()
            
        } catch { throw APIError.decoding(error) }
    }
    
}



import Playgrounds

#Playground {
    let service = ChefService()
    do {
        let chefs = try await service.getAllChefs()
        try await service.getChef(id: chefs.first!.id)
    } catch {
        print(error)
    }
}
