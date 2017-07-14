//
//  ExerciseSets.swift
//  FitLift
//
//  Created by Gerald Morna on 14/5/17.
//  Copyright © 2017 Gerald Morna. All rights reserved.
//

import Foundation

//Workouts consist of several WorkoutRoutines. WorkoutRotines consist of multiple ExerciseRoutins, which are made up of Exercises

class Exercise {
  
  let name: String
  let imageName: String
  
  init(name: String, imageName: String) {
    self.name = name
    self.imageName = imageName
  }
}

class ExerciseRoutine {
  
  let exercise: Exercise
  let sets: Int
  let reps: Int
  let restPeriod: Int
  let increaseWeightAmount: Float
  var weight: Float
  
  init(exercise: Exercise, sets: Int, reps: Int, weight: Float, restPeriod: Int, increaseWeightAmount: Float) {
    self.exercise = exercise
    self.sets = sets
    self.reps = reps
    self.weight = weight
    self.restPeriod = restPeriod
    self.increaseWeightAmount = increaseWeightAmount
  }
}

class WorkoutRoutine {
  
  let exercises: [ExerciseRoutine]
  
  init(exercises: [ExerciseRoutine]) {
    self.exercises = exercises
  }
}

class Workout {
  
  let name: String
  let imageName: String
  let routine: [WorkoutRoutine]
  let shortDescription: String
  
  init(name: String, imageName: String, routine: [WorkoutRoutine], shortDescription: String) {
    self.name = name
    self.imageName = imageName
    self.routine = routine
    self.shortDescription = shortDescription
  }
}

struct Exercises {
  static let benchPress: Exercise = Exercise(name: "benchpress", imageName: "benchpress")
  static let squat: Exercise = Exercise(name: "squat", imageName: "squat")
  static let deadLift: Exercise = Exercise(name: "deadlift", imageName: "deadlift")
}

struct ExerciseRoutines {
  static let benchPress5x5: ExerciseRoutine = ExerciseRoutine(exercise: Exercises.benchPress, sets: 5, reps: 5, weight: 0.0, restPeriod: 180, increaseWeightAmount: 2.5)
  static let squat5x5: ExerciseRoutine = ExerciseRoutine(exercise: Exercises.squat, sets: 5, reps: 5, weight: 0.0, restPeriod: 180, increaseWeightAmount: 2.5)
  static let deadLift5x5: ExerciseRoutine = ExerciseRoutine(exercise: Exercises.deadLift, sets: 5, reps: 5, weight: 0.0, restPeriod: 180, increaseWeightAmount: 5.0)
  
  static let benchPress3x3: ExerciseRoutine = ExerciseRoutine(exercise: Exercises.benchPress, sets: 3, reps: 3, weight: 0.0, restPeriod: 180, increaseWeightAmount: 2.5)
  static let squat3x3: ExerciseRoutine = ExerciseRoutine(exercise: Exercises.squat, sets: 3, reps: 3, weight: 0.0, restPeriod: 180, increaseWeightAmount: 2.5)
  static let deadLift3x3: ExerciseRoutine = ExerciseRoutine(exercise: Exercises.deadLift, sets: 3, reps: 3, weight: 0.0, restPeriod: 180, increaseWeightAmount: 5.0)
}

struct WorkoutRoutines {
  static let startingStrengthRoutineA = WorkoutRoutine(exercises: [ExerciseRoutines.squat5x5, ExerciseRoutines.benchPress5x5, ExerciseRoutines.deadLift5x5])
  static let startingStrengthRoutineB = WorkoutRoutine(exercises: [ExerciseRoutines.squat5x5, ExerciseRoutines.deadLift5x5, ExerciseRoutines.benchPress5x5])
  
  static let strength33A = WorkoutRoutine(exercises: [ExerciseRoutines.squat3x3, ExerciseRoutines.benchPress3x3, ExerciseRoutines.deadLift3x3])
  static let strength33B = WorkoutRoutine(exercises: [ExerciseRoutines.squat3x3, ExerciseRoutines.deadLift3x3, ExerciseRoutines.benchPress3x3])
}

struct Workouts {
  static let startingStrength: Workout = Workout(name: "Starting Strength", imageName: "StartingStrength", routine: [WorkoutRoutines.startingStrengthRoutineA, WorkoutRoutines.startingStrengthRoutineB], shortDescription: "ss")
  
  static let strength33 : Workout = Workout(name: "Strength 3x3", imageName: "Strength33", routine: [WorkoutRoutines.strength33A, WorkoutRoutines.strength33B], shortDescription: "ss33")
}


let allWorkouts: [Workout] = [Workouts.startingStrength, Workouts.strength33]










