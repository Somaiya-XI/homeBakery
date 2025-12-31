//
//  booking.swift
//  homeBakery
//
//  Created by Somaiya on 09/07/1447 AH.
//

import Foundation

// Booking Object with View Data
struct Booking: Codable, Identifiable {
    var id: String
    var courseid: String
    var userId: String
    var status: String
    
    func toBookingRecord() -> BookingRecord {
        BookingRecord(
            fields: BookingDto(courseid: courseid, userId: userId, status: status)
        )
    }
}

// Booking Object with API Fields
struct BookingDto: Codable {
    var courseid: String
    var userId: String
    var status: String
}

// Booking Object with JSON format
struct BookingRecord: Codable {
    var id: String?
    var fields: BookingDto
    
    func toBooking() -> Booking {
        Booking(
            id: id ?? UUID().uuidString,
            courseid: fields.courseid,
            userId: fields.userId,
            status: fields.status
        )
    }
}


struct BookingsApiResponse: Codable {
    var records: [BookingRecord]
}

struct DeleteBookingApiResponse: Codable {
    var deleted: Bool
    var id: String
}
