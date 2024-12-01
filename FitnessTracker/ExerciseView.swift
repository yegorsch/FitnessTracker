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
    @State private var repetitionEntries: [RepitionEntry] = []
    private var exercise: Exercise?
    private var muscleGroup: MuscleGroup

    @Environment(\.dismiss) private var dismiss

    init(muscleGroup: MuscleGroup, exercise: Exercise?) {
        self.muscleGroup = muscleGroup
        self.exercise = exercise
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Muscle Group")) {
                    Text(muscleGroup.localizaedName)
                }

                Section(header: Text("Exercise")) {
                    if let exercise = self.exercise {
                        Text(exercise.localizaedName)
                    } else {
                        TextField("Exercise name", text: $exerciseName)
                    }
                }

                Section(header: Text("Repetition Details")) {
                    TextField("Weight (kg)", text: $weight)
                        .keyboardType(.decimalPad)
                    Stepper("Reps: \(reps)", value: $reps, in: 1...100)
                    Button("Add Repetition Entry") {
                        let newEntry = RepitionEntry(id: repetitionEntries.count + 1, weight: Double(weight) ?? 0, reps: reps)
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
        if let exercise {
            let newEntry = ExerciseEntry(
                id: Int.random(in: 1...1000),
                exercise: exercise,
                entries: repetitionEntries
            )
            newEntry.date = date
            // Add saving logic here, e.g., save to a database or observable model
            print("Exercise Entry Saved: \(newEntry)")
            dismiss()
        }
    }
}

#Preview {
    AddExerciseEntryView(muscleGroup: .init(id: 0, localizaedName: "Chest"), exercise: .init(id: 0, localizaedName: "Bench Press", muscleGroup: .init(id: 0, localizaedName: "Chest")))
}
