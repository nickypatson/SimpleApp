//
//  SensorDetails.swift
//  SimpleApp
//
//  Created by Nicky Patson on 01/04/2021.
//

import SwiftUI

// MARK: - SensorDetails
struct SensorDetails: View {
    
    @ObservedObject var sensor : Sensor
    var onComplete: (Sensor) -> Void
    
    let formatter: NumberFormatter = {
        let numFormatter = NumberFormatter()
        numFormatter.numberStyle = .none
        return numFormatter
    }()
    
    @State private var selectedSensorType: Int = 0
    
    init(sensor:Sensor,onComplete:@escaping (Sensor) -> Void) {
        self.sensor = sensor
        self.onComplete = onComplete
        self._selectedSensorType = State(initialValue: Int(self.sensor.sensorType))
    }
    
    var body: some View {
        
        let sensorType = Binding<Int>(
            get: { self.selectedSensorType - 1},
            set: {
                self.selectedSensorType = $0 + 1
                self.sensor.sensorType = Int32(self.selectedSensorType)
            })
        
        let sensorLocation = Binding<String>(
            get: { String(sensor.sensorLocation) },
            set: {
                if let value = formatter.number(from: $0) {
                    self.sensor.sensorLocation = Int64(truncating: value)
                }
            })
        
        let sensorZone = Binding<String>(
            get: { String(sensor.sensorZone) },
            set: {
                if let value = formatter.number(from: $0) {
                    self.sensor.sensorZone = Int64(truncating: value)
                }
            })
        
        NavigationView {
            Form {
                Section(header: Text("Sensor Name")) {
                    TextField("Sensor Name", text: $sensor.sensorName)
                }
                Section(header: Text("Sensor Type")) {
                    
                    Picker(selection: sensorType, label: Text("Sensor Type")) {
                        ForEach(0 ..< SensorType.allCases.count) {
                            Text(SensorType.allCases[$0].rawValue).tag($0)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Mac Address")) {
                    TextField("Mac Address", text: $sensor.macAddress)
                }
                Section(header: Text("Sensor Location")) {
                    TextField("Sensor Location", text: sensorLocation)
                        .keyboardType(.numberPad)
                }
                Section(header: Text("Sensor Zone")) {
                    TextField("Sensor Zone", text: sensorZone)
                        .keyboardType(.numberPad)
                }
                Section(header: Text("Serial Number")) {
                    TextField("Sensor Number", text: $sensor.serialNumber)
                }
                
                Section {
                    Button(action: updateAction) {
                        Text("Update")
                    }
                }
            }
            .navigationBarTitle(Text("Sensors"), displayMode: .inline)
        }
    }
    
    /// Updatng sensor specific data action
    private func updateAction() {
        onComplete(sensor)
    }
}

