//
//  ContentView.swift
//  FitnessTracker
//
//  Created by Егор on 30.11.2024.
//

import SwiftUI
import SwiftData
/*
 You can inout any expecise to any category and we will automatically sort them into workouts based on a date
 */
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort:\MuscleGroup.id, order: .forward) private var items: [MuscleGroup]

    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    Section(header: Text(item.localizaedName)) {
                        NavigationLink("Add new item") {
                            AddExerciseEntryView(muscleGroup: item, exercise: nil)
                        }
                    }.headerProminence(.increased)
                }
            }
        }.onAppear {
            addDefaultMuscleGrouos()
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }

    private func addDefaultMuscleGrouos() {
        let muscleGroups: [String] = ["Chest", "Back", "Legs", "Shoulders", "Biceps", "Triceps", "Forearms", "Abs"]
        for muscleGroup in muscleGroups.enumerated() {
            modelContext.insert(MuscleGroup(id: muscleGroup.offset, localizaedName: muscleGroup.element))
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: MuscleGroup.self, inMemory: true)
}
