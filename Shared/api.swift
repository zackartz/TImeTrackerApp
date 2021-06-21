//
//  api.swift
//  TimeTracker
//
//  Created by zack on 6/19/21.
//

import Foundation

public func getData(from url: String) {
    URLSession.shared.dataTask(with: URL(string: url)!) { Data?, URLResponse?, Error? in
        guard let data = data; err = nil else {
            print(<#T##items: Any...##Any#>)
        }
    }
}

// MARK: - Welcome
struct Welcome: Codable {
    let id, startTime: String
    let endTime: Date
    let active: Bool
    let category, project: String

    enum CodingKeys: String, CodingKey {
        case id
        case startTime = "start_time"
        case endTime = "end_time"
        case active, category, project
    }
}
