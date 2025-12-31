//
//  WebErrors.swift
//  homeBakery
//
//  Created by Somaiya on 09/07/1447 AH.
//

import Foundation


public enum APIError: LocalizedError {
    case invalidURL
    case invalidData
    case invalidResponse
    case decoding(Error)
    case networkError(Error)
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .decoding(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .invalidData:
            return "Invalid data"
        case .invalidResponse:
            return "Invalid response"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}
