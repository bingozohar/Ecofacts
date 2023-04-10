//
//  EcofactsApp.swift
//  Ecofacts
//
//  Created by Bingo Zohar on 05/04/2023.
//

import CoreData
import SwiftUI

@main
struct EcofactsApp: App {
    @StateObject private var store = EcofactStore()
    @StateObject private var dataController = DataController()
    
    func load() -> Void {
        print("INIT LOAD")
        EcofactStore.load { result in
            switch result {
            case .failure(let error):
                fatalError(error.localizedDescription)
            case .success(let topics):
                store.topics = topics
            }
        }
    }
    
    func save() -> Void {
        print("INIT SAVE")
        EcofactStore.save(topics: store.topics) { result in
            if case .failure(let error) = result {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainView(loadAction: load, saveAction: save)
                .onAppear {
                    load()
                }
                .environmentObject(store)
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
