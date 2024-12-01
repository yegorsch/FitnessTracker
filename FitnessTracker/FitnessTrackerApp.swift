//
//  FitnessTrackerApp.swift
//  FitnessTracker
//
//  Created by Егор on 30.11.2024.
//

import SwiftUI
import SwiftData

@main
struct FitnessTrackerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            MuscleGroup.self,
            Exercise.self,
            ExerciseEntry.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
