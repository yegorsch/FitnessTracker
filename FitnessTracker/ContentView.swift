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
    @Query private var exercises: [Exercise]
    var addExercise: (String) -> Void

    init(muscleGroup: MuscleGroup, newGroupName: Binding<String>, addExercise: @escaping (String) -> Void) {
        self.muscleGroup = muscleGroup
        _newGroupName = newGroupName
        self.addExercise = addExercise
    }

    var body: some View {
        Section(header: Text(muscleGroup.localizaedName)) {
            ForEach(exercises) { exercise in
                if exercise.muscleGroup == muscleGroup {
                    NavigationLink(exercise.localizaedName, value: exercise)
                }
            }
            TextField("Add new exercise", text: $newGroupName)
                .onSubmit {
                    addExercise(newGroupName)
                }
        }.headerProminence(.increased)
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
            }.navigationDestination(for: Exercise.self) { exercise in
                AddExerciseEntryView(exercise: exercise)
            }
        }
        .onAppear {
            addDefaultMuscleGroups()
        }
    }

    private func addExercise(to muscleGroup: MuscleGroup, name: String) {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        modelContext.insert(Exercise(localizaedName: name, muscleGroup: muscleGroup))
        try! modelContext.save()
        newGroupNames[muscleGroup.id] = "" // Clear the text field
    }


    private func addDefaultMuscleGroups() {
        guard items.isEmpty else { return }
        let legsMuscles = MuscleGroup(localizaedName: "Legs", exercises: [])
        let shoulderMuscles = MuscleGroup(localizaedName: "Shoulders", exercises: [])
        let absMuscles = MuscleGroup(localizaedName: "Abs", exercises: [])

        let chestMuscles = MuscleGroup(localizaedName: "Chest", exercises: [])
        let backMuscles = MuscleGroup(localizaedName: "Back", exercises: [])

        let bicepMuscles = MuscleGroup(localizaedName: "Biceps", exercises: [])
        let tricepMuscles = MuscleGroup(localizaedName: "Triceps", exercises: [])
        let forearmsMuscles = MuscleGroup(localizaedName: "Forearms", exercises: [])

        let allMuscles: [MuscleGroup] = [legsMuscles, shoulderMuscles, absMuscles, chestMuscles, backMuscles, bicepMuscles, tricepMuscles, forearmsMuscles]
        allMuscles.forEach(modelContext.insert)
        try! modelContext.save()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: MuscleGroup.self, inMemory: true)
}
