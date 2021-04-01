//
//  SimpleAppApp.swift
//  SimpleApp
//
//  Created by Nicky Patson on 01/04/2021.
//

import SwiftUI

@main
struct SimpleAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
