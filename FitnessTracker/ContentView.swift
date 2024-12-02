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

struct MuscleGroupSectionView: View {
    let muscleGroup: MuscleGroup
    @Binding var newGroupName: String
    var addExercise: (String) -> Void

    var body: some View {
        Section(header: Text(muscleGroup.localizaedName)) {
            ForEach(muscleGroup.exercises) { exercise in
                NavigationLink(exercise.localizaedName) {
                    AddExerciseEntryView(muscleGroup: muscleGroup, exercise: exercise)
                }
            }
            TextField("Add new exercise", text: $newGroupName)
                .onSubmit {
                    addExercise(newGroupName)
                }
        }
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort:\MuscleGroup.id, order: .forward) private var items: [MuscleGroup]

    @State private var newGroupNames: [UUID: String] = [:] // Store new names for each section by ID.

    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    MuscleGroupSectionView(
                        muscleGroup: item,
                        newGroupName: Binding(
                            get: { newGroupNames[item.id] ?? "" },
                            set: { newGroupNames[item.id] = $0 }
                        ),
                        addExercise: { name in
                            addExercise(to: item, name: name)
                        }
                    )
                }
            }
        }
        .onAppear {
            addDefaultMuscleGroups()
        }
    }

    private func addExercise(to muscleGroup: MuscleGroup, name: String) {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        modelContext.insert(Exercise(id: .init(), localizaedName: name, muscleGroup: muscleGroup))
        newGroupNames[muscleGroup.id] = "" // Clear the text field
    }


    private func addDefaultMuscleGroups() {
        guard items.isEmpty else { return }
        let muscleGroups: [String] = ["Chest", "Back", "Legs", "Shoulders", "Biceps", "Triceps", "Forearms", "Abs"]
        for muscleGroup in muscleGroups.enumerated() {
            modelContext.insert(MuscleGroup(id: .init(), localizaedName: muscleGroup.element, exercises: []))
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: MuscleGroup.self, inMemory: true)
}
