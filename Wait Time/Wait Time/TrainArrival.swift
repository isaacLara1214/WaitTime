//
//  Train.swift
//  Wait Time
//
//  Created by Isaac Lara on 4/24/25.
//

import Foundation

struct TrainArrival: Codable {
    let destination: String
    let direction: String
    let eventTime: String
    let isRealtime: String
    let line: String
    let nextArrival: String
    let station: String
    let trainId: String
    let waitingSeconds: String
    let waitingTime: String
    let delay: String?
    let latitude: String?
    let longitude: String?

    enum CodingKeys: String, CodingKey {
        case destination = "DESTINATION"
        case direction = "DIRECTION"
        case eventTime = "EVENT_TIME"
        case isRealtime = "IS_REALTIME"
        case line = "LINE"
        case nextArrival = "NEXT_ARR"
        case station = "STATION"
        case trainId = "TRAIN_ID"
        case waitingSeconds = "WAITING_SECONDS"
        case waitingTime = "WAITING_TIME"
        case delay = "DELAY"
        case latitude = "LATITUDE"
        case longitude = "LONGITUDE"
    }
}

struct StationInfo {
    let name: String
    var arrivalsByLine: [String: [TrainArrival]]
}
