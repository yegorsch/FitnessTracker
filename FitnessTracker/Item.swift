//
//  Item.swift
//  FitnessTracker
//
//  Created by Егор on 30.11.2024.
//

import Foundation
import SwiftData

@Model
final class Workout {
    @Attribute(.unique) var id: UUID
    var localizedName: String
    var muscleGroups: [MuscleGroup]

    init(localizedName: String, muscleGroups: [MuscleGroup]) {
        self.id = .init()
        self.localizedName = localizedName
        self.muscleGroups = muscleGroups
    }
}

@Model
final class MuscleGroup {
    @Attribute(.unique) var id: UUID
    var localizaedName: String
    var exercises: [Exercise]

    init(localizaedName: String, exercises: [Exercise]) {
        self.id = .init()
        self.localizaedName = localizaedName
        self.exercises = exercises
    }
}

@Model
final class Exercise {
    @Attribute(.unique) var id: UUID
    var localizaedName: String
    var muscleGroup: MuscleGroup

    init(localizaedName: String, muscleGroup: MuscleGroup) {
        self.id = .init()
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

    init(weight: Double, reps: Int, exercise: Exercise, date: Date) {
        self.id = .init()
        self.weight = weight
        self.reps = reps
        self.exercise = exercise
        self.date = date
    }
}
