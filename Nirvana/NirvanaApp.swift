//
//  NirvanaApp.swift
//  Nirvana
//
//  Created by Akshat Dutt Kaushik on 04/08/25.
//

import SwiftUI
import SwiftData

@main
struct NirvanaApp: App {
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: SongModel.self)
        } catch {
            fatalError("Failed to create ModelContainer for Song: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
