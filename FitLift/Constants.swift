//
//  ExerciseSets.swift
//  FitLift
//
//  Created by Gerald Morna on 14/5/17.
//  Copyright © 2017 Gerald Morna. All rights reserved.
//

import Foundation

//Workouts consist of several WorkoutRoutines. WorkoutRotines consist of multiple ExerciseRoutines, which are made up of Exercises

class Exercise: NSObject, NSCoding {
  
  let name: String
  let imageName: String
  
  init(name: String, imageName: String) {
    self.name = name
    self.imageName = imageName
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: "name")
    aCoder.encode(imageName, forKey: "imageName")
  }
  
  required init?(coder aDecoder: NSCoder) {
    name = aDecoder.decodeObject(forKey: "name") as! String
    imageName = aDecoder.decodeObject(forKey: "imageName") as! String
  }
}

class ExerciseRoutine: NSObject, NSCoding {
  
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
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(exercise, forKey: "exercise")
    aCoder.encode(sets, forKey: "sets")
    aCoder.encode(reps, forKey: "reps")
    aCoder.encode(weight, forKey: "weight")
    aCoder.encode(restPeriod, forKey: "restPeriod")
    aCoder.encode(increaseWeightAmount, forKey: "increaseWeightAmount")
  }
  
  required init?(coder aDecoder: NSCoder) {
    exercise = aDecoder.decodeObject(forKey: "exercise") as! Exercise
    sets = aDecoder.decodeInteger(forKey: "sets")
    reps = aDecoder.decodeInteger(forKey: "reps")
    weight = aDecoder.decodeFloat(forKey: "weight")
    restPeriod = aDecoder.decodeInteger(forKey: "restPeriod")
    increaseWeightAmount = aDecoder.decodeFloat(forKey: "increaseWeightAmount")
  }
}

class WorkoutRoutine: NSObject, NSCoding {
  
  let exercises: [ExerciseRoutine]
  
  init(exercises: [ExerciseRoutine]) {
    self.exercises = exercises
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(exercises, forKey: "exercises")
  }
  
  required init?(coder aDecoder: NSCoder) {
    exercises = aDecoder.decodeObject(forKey: "exercises") as! [ExerciseRoutine]
  }
}

class Workout: NSObject, NSCoding {
  
  let name: String
  let imageName: String
  let routine: [WorkoutRoutine]
  let shortDescription: String
  let longDescription: String
  
  init(name: String, imageName: String, routine: [WorkoutRoutine], shortDescription: String, longDescription: String) {
    self.name = name
    self.imageName = imageName
    self.routine = routine
    self.shortDescription = shortDescription
    self.longDescription = longDescription
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: "name")
    aCoder.encode(imageName, forKey: "imageName")
    aCoder.encode(routine, forKey: "routine")
    aCoder.encode(shortDescription, forKey: "shortDescription")
    aCoder.encode(longDescription, forKey: "longDescription")
  }
  
  required init?(coder aDecoder: NSCoder) {
    name = aDecoder.decodeObject(forKey: "name") as! String
    imageName = aDecoder.decodeObject(forKey: "imageName") as! String
    routine = aDecoder.decodeObject(forKey: "routine") as! [WorkoutRoutine]
    shortDescription = aDecoder.decodeObject(forKey: "shortDescription") as! String
    longDescription = aDecoder.decodeObject(forKey: "longDescription") as! String
  }
}

class SavedWorkout: NSObject, NSCoding {
  let workout: Workout
  let completionCounter: [Bool]
  let date: NSDate
  let routineIndex: Int
  
  init(workout: Workout, completionCounter: [Bool], date: NSDate, routineIndex: Int) {
    self.workout = workout
    self.completionCounter = completionCounter
    self.date = date
    self.routineIndex = routineIndex
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(workout, forKey: "workout")
    aCoder.encode(completionCounter, forKey: "completionCounter")
    aCoder.encode(date, forKey: "date")
    aCoder.encode(routineIndex, forKey: "routineIndex")
  }
  
  required init?(coder aDecoder: NSCoder) {
    workout = aDecoder.decodeObject(forKey: "workout") as! Workout
    completionCounter = aDecoder.decodeObject(forKey: "completionCounter") as! [Bool]
    date = aDecoder.decodeObject(forKey: "date") as! NSDate
    routineIndex = aDecoder.decodeInteger(forKey: "routineIndex")
  }
}

struct Exercises {
  static let benchPress: Exercise = Exercise(name: "benchpress", imageName: "benchpress")
  static let squat: Exercise = Exercise(name: "squat", imageName: "squat")
  static let deadLift: Exercise = Exercise(name: "deadlift", imageName: "deadlift")
}

struct ExerciseRoutines {
  static let benchPress5x5: ExerciseRoutine = ExerciseRoutine(exercise: Exercises.benchPress, sets: 5, reps: 5, weight: 20.0, restPeriod: 180, increaseWeightAmount: 2.5)
  static let squat5x5: ExerciseRoutine = ExerciseRoutine(exercise: Exercises.squat, sets: 5, reps: 5, weight: 20.0, restPeriod: 180, increaseWeightAmount: 2.5)
  static let deadLift5x5: ExerciseRoutine = ExerciseRoutine(exercise: Exercises.deadLift, sets: 5, reps: 5, weight: 20.0, restPeriod: 180, increaseWeightAmount: 5.0)
  
  static let benchPress3x3: ExerciseRoutine = ExerciseRoutine(exercise: Exercises.benchPress, sets: 3, reps: 3, weight: 20.0, restPeriod: 180, increaseWeightAmount: 2.5)
  static let squat3x3: ExerciseRoutine = ExerciseRoutine(exercise: Exercises.squat, sets: 3, reps: 3, weight: 20.0, restPeriod: 180, increaseWeightAmount: 2.5)
  static let deadLift3x3: ExerciseRoutine = ExerciseRoutine(exercise: Exercises.deadLift, sets: 3, reps: 3, weight: 20.0, restPeriod: 180, increaseWeightAmount: 5.0)
}

struct WorkoutRoutines {
  static let startingStrengthRoutineA = WorkoutRoutine(exercises: [ExerciseRoutines.squat5x5, ExerciseRoutines.benchPress5x5, ExerciseRoutines.deadLift5x5])
  static let startingStrengthRoutineB = WorkoutRoutine(exercises: [ExerciseRoutines.squat5x5, ExerciseRoutines.deadLift5x5, ExerciseRoutines.benchPress5x5])
  
  static let strength33A = WorkoutRoutine(exercises: [ExerciseRoutines.squat3x3, ExerciseRoutines.benchPress3x3, ExerciseRoutines.deadLift3x3])
  static let strength33B = WorkoutRoutine(exercises: [ExerciseRoutines.squat3x3, ExerciseRoutines.deadLift3x3, ExerciseRoutines.benchPress3x3])
}

struct Workouts {
  static let startingStrength: Workout = Workout(name: "Starting Strength", imageName: "StartingStrength", routine: [WorkoutRoutines.startingStrengthRoutineA, WorkoutRoutines.startingStrengthRoutineB], shortDescription: "ss", longDescription: "Starting Strength is a beginner program that focuses on large compound lifts with heavy weights and low repitition.")
  
  static let strength33 : Workout = Workout(name: "Strength 3x3", imageName: "Strength33", routine: [WorkoutRoutines.strength33A, WorkoutRoutines.strength33B], shortDescription: "ss33", longDescription: "You think water moves fast? You should see ice. It moves like it has a mind. Like it knows it killed the world once and got a taste for murder. After the avalanche, it took us a week to climb out. Now, I dont know exactly when we turned on each other, but I know that seven of us survived the slide... and only five made it out. Now we took an oath, that Im breaking now. We said wed say it was the snow that killed the other two, but it wasnt. Nature is lethal but it doesnt hold a candle to man. You think water moves fast? You should see ice. It moves like it has a mind. Like it knows it killed the world once and got a taste for murder. After the avalanche, it took us a week to climb out. Now, I dont know exactly when we turned on each other, but I know that seven of us survived the slide... and only five made it out. Now we took an oath, that Im breaking now. We said wed say it was the snow that killed the other two, but it wasnt. Nature is lethal but it doesnt hold a candle to man. Normally, both your asses would be dead as fucking fried chicken, but you happen to pull this shit while Im in a transitional period so I dont wanna kill you, I wanna help you. But I cant give you this case, it dont belong to me. Besides, Ive already been through too much shit this morning over this case to hand it over to your dumb ass.")
}


let allWorkouts: [Workout] = [Workouts.startingStrength, Workouts.strength33]










