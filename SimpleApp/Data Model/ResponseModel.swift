//
//  ResponseModel.swift
//  Sample App
//
//  Created by Nicky Patson on 31/03/2021.
//

import Foundation

// MARK: - ResponseModel
struct ResponseModel: Codable {
    let vehicleDetails: [VehicleDetail]
}

// MARK: - RequestDetail
struct RequestDetail: Codable {
    let vId: String
    let mobileAppId, messageType: Int

    enum CodingKeys: String, CodingKey {
        case vId
        case mobileAppId
        case messageType
    }
}

// MARK: - UserDetail
struct UserDetail: Codable {
    let userId: Int

    enum CodingKeys: String, CodingKey {
        case userId
    }
}

// MARK: - VehicleDetail
struct VehicleDetail: Codable {
    let vehicleId, name, reeferSerial, mobileNumber: String?
    let customer: String?
    let sensorDetails: [SensorDetail]?

    enum CodingKeys: String, CodingKey {
        case vehicleId
        case name, reeferSerial, mobileNumber, customer, sensorDetails
    }
}

// MARK: - SensorDetail
struct SensorDetail: Codable {
    let sensorZone, sensorLocation: Int
    let serialNumber, macAddress, sensorName: String
    let sensorType: Int
}
