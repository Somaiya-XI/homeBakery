//
//  BookingService.swift
//  homeBakery
//
//  Created by Somaiya on 09/07/1447 AH.
//

import Foundation

struct BookingService {
    
    func getAllBookings() async throws -> [Booking] {
        let endpoint = "\(Config.airtableAPI)/booking"
        
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
            let apiBookings =  try decoder.decode(BookingsApiResponse.self, from: data)
            
            // Convert to the AppView Data
            var bookings: [Booking] = []
            
            for booking in apiBookings.records {
                bookings.append(booking.toBooking())
            }
            
            return bookings
            
        } catch { throw APIError.decoding(error) }
    }
    
    func createBooking(_ booking: Booking) async throws -> Booking {
        let endpoint = "\(Config.airtableAPI)/booking"
        
        let bookingData = booking.toBookingRecord()
        guard let url = URL(string: endpoint) else { throw APIError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            
            request.httpBody = try encoder.encode(bookingData)
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
            let apiBooking = try decoder.decode(BookingRecord.self, from: data)
            let newBooking = apiBooking.toBooking()
            
            return newBooking
            
        } catch { throw APIError.decoding(error) }
        
    }
    
    func deleteBooking(_ id: String) async throws -> Bool {
        let endpoint = "\(Config.airtableAPI)/booking/\(id)"
        
        guard let url = URL(string: endpoint) else { throw APIError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue(Config.token, forHTTPHeaderField: "Authorization")

        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,                   (200...299).contains(httpResponse.statusCode)
        else { throw APIError.invalidResponse }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let apiBooking = try decoder.decode(DeleteBookingApiResponse.self, from: data)
            
            return apiBooking.deleted
            
        } catch { throw APIError.decoding(error) }
        
    }
}

import Playgrounds

#Playground {
    let service = BookingService()
    do {
        let book = Booking(id: "",
                           courseid: "recDo3aHYzoWLO6yP",
                           userId: "recWNhwQMScGcvSKs",
                           status: "Pending")
        try await service.createBooking(book)
        
        try await service.getAllBookings()
//        try await service.deleteBooking("recHLoOwAsPD43E3H")
    } catch {
        print(error)
    }
}
