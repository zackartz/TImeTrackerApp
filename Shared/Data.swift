//
//  Data.swift
//  TimeTracker
//
//  Created by zack on 6/19/21.
//

import SwiftUI

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let timestamp = try? newJSONDecoder().decode(Timestamp.self, from: jsonData)

import Foundation


// MARK: - TimestampElement
struct Timestamp: Codable, Identifiable {
    var id: String
    var endTime, startTime: Date
    var active: Bool
    var comment, category: String?
    var project: String

    enum CodingKeys: String, CodingKey {
        case id
        case startTime = "start_time"
        case endTime = "end_time"
        case active, comment, category, project
    }
}

class JavaScriptISO8601DateFormatter {
    static let fractionalSecondsFormatter: ISO8601DateFormatter = {
        let res = ISO8601DateFormatter()
        // The default format options is .withInternetDateTime.
        // We need to add .withFractionalSeconds to parse dates with milliseconds.
        res.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return res
    }()

    static let defaultFormatter = ISO8601DateFormatter()

    static func decodedDate(_ decoder: Decoder) throws -> Date {
        let container = try decoder.singleValueContainer()
        let dateAsString = try container.decode(String.self)

        // See warning below.
        for formatter in [fractionalSecondsFormatter, defaultFormatter] {
            if let res = formatter.date(from: dateAsString) {
                return res
            }
        }

        throw DecodingError.dataCorrupted(DecodingError.Context(
            codingPath: decoder.codingPath,
            debugDescription: "Expected date string to be JavaScript-ISO8601-formatted."
        ))
    }

    static func encodeDate(date: Date, encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(fractionalSecondsFormatter.string(from: date))
    }

    private init() {}
}

extension JSONDecoder.DateDecodingStrategy {
    static func javaScriptISO8601() -> JSONDecoder.DateDecodingStrategy {
        .custom(JavaScriptISO8601DateFormatter.decodedDate)
    }
}

extension JSONDecoder {
    static func javaScriptISO8601() -> JSONDecoder {
        let res = JSONDecoder()
        res.dateDecodingStrategy = .javaScriptISO8601()
        return res
    }
}

extension JSONEncoder.DateEncodingStrategy {
    static func javaScriptISO8601() -> JSONEncoder.DateEncodingStrategy {
        .custom(JavaScriptISO8601DateFormatter.encodeDate)
    }
}

extension JSONEncoder {
    static func javaScriptISO8601() -> JSONEncoder {
        let res = JSONEncoder()
        res.dateEncodingStrategy = .javaScriptISO8601()
        return res
    }
}


class Api {    
    func getTimestamps(completion: @escaping ([Timestamp]) -> ()) {
        guard let url = URL(string: "https://tt.zackmyers.io/api/v1/timestamps") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let ts = try? JSONDecoder.javaScriptISO8601().decode([Timestamp].self, from: data) {
                    DispatchQueue.main.async {
                        completion(ts)
                    }
                    
                    return
                }
            }
            
            if let error = error {
                print(error)
                return
            }

            print("fetch failed")
        }
        .resume()
    }
    
    func stopTimestamp(id: String) {
        guard let url = URL(string: "https://tt.zackmyers.io/api/v1/end/\(id)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if (try? JSONDecoder.javaScriptISO8601().decode(Timestamp.self, from: data)) != nil {
                    return
                }
            }
        }
        .resume()
    }
    
    func deleteTimestamp(id: String) -> Bool {
        let url = URL(string: "https://tt.zackmyers.io/api/v1/timestamps/\(id)")
        guard let requestURL = url else {
            return false
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
                
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            if data != nil {
                print("we did it!")
                return
            }
        }
        task.resume()
        
        return false
    }
    
    func createTimestampJsonData(project: String, category: String, comment: String) -> Data {
        return try! JSONEncoder.javaScriptISO8601().encode(Timestamp(id: "", endTime: Date.init(), startTime: Date.init(), active: false, comment: comment, category: category, project: project))
    }
}

class Format {
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        let dateText = dateFormatter.string(from: date)
        return dateText
    }
    
    func formatDateShort(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        let dateText = dateFormatter.string(from: date)
        return dateText
    }
    
    func getTime(start: Date, end: Date) -> String {
        let str = formatTime(date: start.timeIntervalSinceReferenceDate - end.timeIntervalSinceReferenceDate)
        var arr = str.components(separatedBy: " ")
        
        arr = arr.dropLast(1)
        
        return arr.joined(separator: " ")
    }
    
    func formatTime(date: TimeInterval) -> String {
        let dateFormatter = RelativeDateTimeFormatter()
        dateFormatter.dateTimeStyle = .named
        
        return dateFormatter.localizedString(fromTimeInterval: date)
    }
}
