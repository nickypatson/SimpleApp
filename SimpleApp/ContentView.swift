//
//  ContentView.swift
//  SimpleApp
//
//  Created by Nicky Patson on 01/04/2021.
//

import SwiftUI
import CoreData

// MARK: - ContentView
struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var viewModel: HomeViewModel
    
    @FetchRequest(entity: Sensor.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Sensor.sensorName, ascending: true)])
    var sensors: FetchedResults<Sensor>
    
    @FetchRequest(entity: Vehicle.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Vehicle.vehicleId, ascending: true)])
    var vehicle: FetchedResults<Vehicle>
    
    @State var selectedSensor : Sensor?
    @State var isPresented = false
    
    var body: some View {

        NavigationView {
            List {
                ForEach(sensors, id: \.self) { sensor in
                    
                    SensorRow(onComplete: { selectedsensor in
                        viewModel.saveContext()
                    }, sensor: sensor)
                }
                .onDelete(perform: deleteSensor)
            }
            .navigationBarTitle(Text(vehicle.first?.name ?? ""))
            .toolbar {
                Button("Reload From JSON") {
                    viewModel.deleteAllValues()
                }
            }
        }.onAppear{
            viewModel.loadValues()
        }
    }
    
    /// Action to delete sensor data
    private func deleteSensor(at offsets: IndexSet) {
        offsets.forEach { index in
            let sensors = self.sensors[index]
            self.viewModel.deleteSensor(sensor: sensors)
        }
    }
}

// MARK: - SensorRow
struct SensorRow: View {
    
    @State var isPresented = false
    let onComplete: (Sensor) -> Void
    var sensor: Sensor
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack{
                Text("Sensor Name:")
                Text(sensor.sensorName)
                    .font(.caption)
            }
            HStack{
                Text("Mac Address:")
                Text(sensor.macAddress)
                    .font(.caption)
            }
            HStack{
                Text("Sensor type:")
                Text(sensor.state.rawValue)
                    .font(.caption)
            }
        }.onTapGesture {
            self.isPresented = true
        }
        .sheet(isPresented: $isPresented) {
            
            SensorDetails(sensor: sensor) { (sensor) in
                self.onComplete(sensor)
                self.isPresented = false
            }
        }
    }
}
