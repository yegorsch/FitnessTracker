//
//  ExerciseView.swift
//  FitnessTracker
//
//  Created by Егор on 01.12.2024.
//

import Foundation
import SwiftUI
import SwiftData

struct AddExerciseEntryView: View {
    @State private var weight: String = ""
    @State private var reps: Int = 8
    @State private var date: Date = Date()
    @State private var exerciseName: String = ""
    @State private var repetitionEntries: [ExerciseEntry] = []
    private var exercise: Exercise
    private var muscleGroup: MuscleGroup

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    init(muscleGroup: MuscleGroup,
         exercise: Exercise?) {
        self.muscleGroup = muscleGroup
        self.exercise = exercise ?? Exercise(id: .init(),
                                             localizaedName: "",
                                             muscleGroup: muscleGroup)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Muscle Group")) {
                    Text(muscleGroup.localizaedName)
                }

                Section(header: Text("Exercise")) {
                    Text(exerciseName)
                }

                Section(header: Text("Repetition Details")) {
                    TextField("Weight (kg)", text: $weight)
                        .keyboardType(.decimalPad)
                    Stepper("Reps: \(reps)", value: $reps, in: 1...100)
                    Button("Add Repetition Entry") {
                        let newEntry = ExerciseEntry(id: .init(),
                                                     weight: Double(weight) ?? 0.0,
                                                     reps: reps,
                                                     exercise: exercise,
                                                     date: .init())
                        repetitionEntries.append(newEntry)
                        // Reset fields for new entry
                        weight = ""
                        reps = 8
                    }
                }

                if !repetitionEntries.isEmpty {
                    Section(header: Text("Repetition Entries")) {
                        List(repetitionEntries, id: \.id) { entry in
                            VStack(alignment: .leading) {
                                Text("Weight: \(entry.weight, specifier: "%.2f") kg")
                                Text("Reps: \(entry.reps)")
                            }
                        }
                    }
                }
            }
        }.navigationTitle("Add Exercise Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveExerciseEntry()
                    }
                }
            }
    }

    private func saveExerciseEntry() {
        for entry in repetitionEntries {
            modelContext.insert(entry)
        }
    }
}

#Preview {
    AddExerciseEntryView(muscleGroup: .init(id: .init(), localizaedName: "Chest", exercises: []), exercise: .init(id: .init(), localizaedName: "Bench Press", muscleGroup: .init(id: .init(), localizaedName: "Chest", exercises: [])))
}
