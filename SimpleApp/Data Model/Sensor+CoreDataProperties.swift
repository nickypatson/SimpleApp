//
//  Sensor+CoreDataProperties.swift
//  SimpleApp
//
//  Created by Nicky Patson on 01/04/2021.
//
//

import Foundation
import CoreData

enum SensorType:String, Equatable, CaseIterable  {

    case temperature = "Temperature"
    case humidity = "Humidity"
    case door  = "Door"
        
    var value : Int32{
        
        switch self {
        case .temperature:
            return 1
        case .humidity:
            return 2
        case .door:
            return 3
        }
    }
}

extension Sensor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sensor> {
        return NSFetchRequest<Sensor>(entityName: "Sensor")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var macAddress: String
    @NSManaged public var sensorLocation: Int64
    @NSManaged public var sensorName: String
    @NSManaged public var sensorType: Int32
    @NSManaged public var sensorZone: Int64
    @NSManaged public var serialNumber: String
}

extension Sensor : Identifiable {

}
extension Sensor {
    
    var state: SensorType {
        get {
            
           let type = SensorType.allCases.first(where: {$0.value == self.sensorType})!
            return SensorType(rawValue: String(type.rawValue))!
        }
        set {
            self.sensorType = newValue.value
        }
    }
}
