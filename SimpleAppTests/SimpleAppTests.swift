//
//  SimpleAppTests.swift
//  SimpleAppTests
//
//  Created by Nicky Patson on 01/04/2021.
//

import XCTest
@testable import SimpleApp

class SimpleAppTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testSuccessParser() {
        
        let json = """
                             {"sensorZone": 1,
                             "sensorLocation": 3,
                             "serialNumber": "DE:34:FE:23:3A",
                             "macAddress": "X000A3312T",
                             "sensorName": "Sensor 1",
                              "sensorType": 1
                      }
      """.data(using: .utf8)!
        
        let sensorDetail = try! JSONDecoder().decode(SensorDetail.self, from: json)
        
        XCTAssertNotNil(sensorDetail)
        
        
    }
    
    func testVehicleParser() {
        
        let json = """
        { "vehicleID": "11224455",
          "name": "Vehicle Name 123",
          "reeferSerial": "ABCD14DFSAS",
          "mobileNumber": "+353891100111",
         "customer": "Customer XYZ"

        }
      """.data(using: .utf8)!
        
        let sensorDetail = try! JSONDecoder().decode(VehicleDetail.self, from: json)
        XCTAssertNotNil(sensorDetail)
    
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
