//
//  HomeViewModel.swift
//  Sample App
//
//  Created by Nicky Patson on 31/03/2021.
//

import Foundation
import CoreData
import SwiftUI
import Combine


// MARK: - HomeViewModel
class HomeViewModel :NSObject, ObservableObject{
    
    var managedObjectContext : NSManagedObjectContext
    private var cancellables = [AnyCancellable]()
    
    
    @FetchRequest(entity: Vehicle.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Vehicle.vehicleId, ascending: true)])
    var vehicle: FetchedResults<Vehicle>
    
    @FetchRequest(entity: Sensor.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Sensor.sensorName, ascending: true)])
    var sensors: FetchedResults<Sensor>
    
    init(managedObjectContext:NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    /// Loading values from the JSON 'Response.json'
    func loadValues(){
        
        if loadAllSensors().count > 0{
            return
        }
        guard let output = ResponseModel.parse(jsonFile: "ResponseModel"),let vehicle = output.vehicleDetails.first, let sensors = output.vehicleDetails.last?.sensorDetails  else {
            return
        }
        self.saveInCoreDataWith(vehicle: vehicle, sensors:sensors)
    }
    
    ///Deleting all ''Sensor' and 'Vehicle' data '
    func deleteAllValues(){
        
        for sensor in self.loadAllSensors(){
            self.managedObjectContext.delete(sensor)
        }
        
        for vehicle in self.loadAllVehicle(){
            self.managedObjectContext.delete(vehicle)
        }
        
        self.saveContext()
        self.loadValues()
    }
    
    /// Loading all sensors
    func loadAllSensors() -> [Sensor]{
        
        let fetchRequest = NSFetchRequest<Sensor>(entityName: "Sensor")
        let records = (try? self.managedObjectContext.fetch(fetchRequest)) ?? []
        return records
        
    }
    /// Loading all vehicle
    func loadAllVehicle() -> [Vehicle]{
        
        let fetchRequest = NSFetchRequest<Vehicle>(entityName: "Vehicle")
        let records = (try? self.managedObjectContext.fetch(fetchRequest)) ?? []
        return records
        
    }
    
    /// Saving vehicle and sensors data to coredata
    private func saveInCoreDataWith(vehicle: VehicleDetail, sensors: [SensorDetail]) {
        self.createVehicleEntity(vehicle: vehicle)
        _ = sensors.map{self.createSensorEntity(sensor: $0)}
        saveContext()
    }
    
    /// Deteting sensor from coredata
    func deleteSensor(sensor:Sensor){
        self.managedObjectContext.delete(sensor)
        saveContext()
    }
    
    /// Updating sensor
    func updateSensor(sensor:Sensor){
        saveContext()
    }

    /// Create new entitiy for vehicle
    private func createVehicleEntity(vehicle: VehicleDetail) {
        
        let vehicleObject = Vehicle(context: managedObjectContext)
        vehicleObject.vehicleId = vehicle.vehicleId
        vehicleObject.name = vehicle.name
        vehicleObject.reeferSerial = vehicle.reeferSerial
        vehicleObject.mobileNumber = vehicle.mobileNumber
        vehicleObject.customer = vehicle.customer
    }
    
    
    /// Create new entitiy for Sensors
    private func createSensorEntity(sensor: SensorDetail) {
        
        let sensorObject = Sensor(context: managedObjectContext)
        sensorObject.sensorZone = Int64(sensor.sensorZone)
        sensorObject.sensorLocation = Int64(sensor.sensorLocation)
        sensorObject.serialNumber = sensor.serialNumber
        sensorObject.sensorName = sensor.sensorName
        sensorObject.macAddress = sensor.macAddress
        sensorObject.sensorType = Int32(sensor.sensorType)
        
    }
    
    /// Saving context
    func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
}


// MARK: - Decodable
extension Decodable {
    
    /// parse value from json to decode object
    static func parse(jsonFile: String) -> Self? {
        
        guard let url = Bundle.main.url(forResource: jsonFile, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {return nil}
        
        let decoder = JSONDecoder()
        let output = try? decoder.decode(self, from: data)
        return output
    }
}
