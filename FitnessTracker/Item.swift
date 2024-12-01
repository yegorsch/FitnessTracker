//
//  Item.swift
//  FitnessTracker
//
//  Created by Егор on 30.11.2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

@Model
final class MuscleGroup {
    @Attribute(.unique) var id: Int
    var localizaedName: String

    init(id: Int, localizaedName: String) {
        self.id = id
        self.localizaedName = localizaedName
    }
}

@Model
final class Exercise {
    @Attribute(.unique) var id: Int
    var localizaedName: String
    var muscleGroup: MuscleGroup

    init(id: Int, localizaedName: String, muscleGroup: MuscleGroup) {
        self.id = id
        self.localizaedName = localizaedName
        self.muscleGroup = muscleGroup
    }
}

@Model
final class ExerciseEntry {
    @Attribute(.unique) var id: Int
    var exercise: Exercise
    var entries: [RepitionEntry]
    var date: Date

    init(id: Int, exercise: Exercise, entries: [RepitionEntry]) {
        self.id = id
        self.exercise = exercise
        self.entries = entries
        self.date = .init()
    }
}

@Model
final class RepitionEntry {
    @Attribute(.unique) var id: Int
    var weight: Double
    var reps: Int

    init(id: Int, weight: Double, reps: Int) {
        self.id = id
        self.weight = weight
        self.reps = reps
    }
}
