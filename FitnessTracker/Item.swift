//
//  Item.swift
//  FitnessTracker
//
//  Created by Егор on 30.11.2024.
//

import Foundation
import SwiftData

@Model
final class MuscleGroup {
    @Attribute(.unique) var id: UUID
    var localizaedName: String

    init(id: UUID, localizaedName: String) {
        self.id = id
        self.localizaedName = localizaedName
    }
}

@Model
final class Exercise {
    @Attribute(.unique) var id: UUID
    var localizaedName: String
    var muscleGroup: MuscleGroup

    init(id: UUID, localizaedName: String, muscleGroup: MuscleGroup) {
        self.id = id
        self.localizaedName = localizaedName
        self.muscleGroup = muscleGroup
    }
}

@Model
final class ExerciseEntry {
    @Attribute(.unique) var id: UUID
    var weight: Double
    var reps: Int
    var exercise: Exercise
    var date: Date

    init(id: UUID, weight: Double, reps: Int, exercise: Exercise, date: Date) {
        self.id = id
        self.weight = weight
        self.reps = reps
        self.exercise = exercise
        self.date = date
    }
}
