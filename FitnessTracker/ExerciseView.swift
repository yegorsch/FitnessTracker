//
//  ExerciseView.swift
//  FitnessTracker
//
//  Created by Егор on 01.12.2024.
//

import Foundation
import SwiftUI
import SwiftData
import Charts

struct AddExerciseEntryView: View {
    @State private var weight: String = ""
    @State private var reps: Int = 8
    @State private var date: Date = Date()
    @State private var exerciseName: String = ""
    @State private var isExpanded: Bool = false
    private var exercise: Exercise

    @Query private var exerciseEntries: [ExerciseEntry]
    @Environment(\.modelContext) private var modelContext

    init(exercise: Exercise) {
        self.exercise = exercise
        _exerciseName = State(initialValue: exercise.localizaedName)
        let exerciseId = exercise.id
        _exerciseEntries =  Query(filter: #Predicate<ExerciseEntry> { $0.exercise.id == exerciseId }, sort: \.date, order: .reverse)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Muscle Group")) {
                    Text(exercise.muscleGroup.localizaedName)
                }

                Section(header: Text("Exercise")) {
                    TextField("Enter exercise name", text: $exerciseName).onChange(of: exerciseName) {
                        exercise.localizaedName = exerciseName
                    }
                }

                Section(header: Text("Repetition Details")) {
                    TextField("Weight (kg)", text: $weight)
                        .keyboardType(.decimalPad)
                    Stepper("Reps: \(reps)", value: $reps, in: 1...100)
                    Button("Add Repetition Entry") {
                        let newEntry = ExerciseEntry(weight: Double(weight) ?? 0.0,
                                                     reps: reps,
                                                     exercise: exercise,
                                                     date: .init())
                        modelContext.insert(newEntry)
                        // Reset fields for new entry
                        weight = ""
                        reps = 8
                    }
                }

                if !exerciseEntries.isEmpty {
                    Section {
                        DisclosureGroup(isExpanded: $isExpanded) {
                            List {
                                ForEach(exerciseEntries, id: \.id) { entry in
                                    VStack(alignment: .leading) {
                                        Text("Weight: \(formattedWeight(entry.weight)) kg")
                                        Text("Reps: \(entry.reps)")
                                    }
                                }
                                .onDelete { offsets in
                                    for index in offsets {
                                        let entryToDelete = exerciseEntries[index]
                                        deleteExerciseEntry(entry: entryToDelete)
                                    }
                                }
                            }
                        } label: {
                            Text("Repetition Entries")
                                .font(.headline)
                        }
                    }
                }

                // Chart Section
                Section(header: Text("Progress Chart")) {
                    Chart(exerciseEntries) { entry in
                        LineMark(
                            x: .value("Date", entry.date),
                            y: .value("Weight", entry.weight)
                        )
                        .foregroundStyle(.blue)
                        .symbol(Circle())
                    }
                    .frame(height: 200)
                }
                .chartXScale(domain: .automatic)
                .chartXAxis {
                    AxisMarks(values: .automatic) // Adjust stride for your needs (e.g., day, week, month)
                }

            }
        }.navigationTitle("Add Exercise Entry")
         .navigationBarTitleDisplayMode(.inline)
    }

    private func deleteExerciseEntry(entry: ExerciseEntry) {
        modelContext.delete(entry)
        try! modelContext.save()
    }

    private func formattedWeight(_ weight: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1 // Show up to 1 decimal place
        formatter.minimumFractionDigits = 0 // Avoid trailing zeros for whole numbers
        return formatter.string(from: NSNumber(value: weight)) ?? "\(weight)"
    }



}


