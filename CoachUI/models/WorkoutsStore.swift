//
//  Workouts.swift
//  CoachUI
//
//  Created by Thomas Ricouard on 02/09/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI

class WorkoutsStore: ObservableObject {
    static var sharedStore : WorkoutsStore!
    
    var workouts: [Workout] = []
    var favorites: [String] = []
    
    init() {
        workouts.append(contentsOf: buildDefaultWorkouts())
        favorites.append(workouts.first!.id)
        favorites.append(workouts.last!.id)
        
        WorkoutsStore.sharedStore = self
    }
    
    func insertWorkout(workout: Workout) {
        workouts.append(workout)
    }
    
    func removeWorkout(at index: Int) {
        let workout = workouts.remove(at: index)
        favorites.removeAll{ $0 == workout.id }
    }
    
    func toggleFavorite(workout: Workout) {
        if favorites.contains(workout.id) {
            favorites.removeAll{ workout.id == $0 }
        } else {
            favorites.append(workout.id)
        }
    }
    
    
    private func buildDefaultWorkouts() -> [Workout] {
        let workout1 = Workout(name: "10 minutes Abs")
        workout1.addExercise(exercise: Exercise(type: .pushups, amount: 20))
        workout1.addExercise(exercise: Exercise(type: .squats, amount: 20))
        workout1.addExercise(exercise: Exercise(type: .pushups, amount: 30))
        workout1.addExercise(exercise: Exercise(type: .pushups, amount: 20))
        workout1.addExercise(exercise: Exercise(type: .squats, amount: 20))
        workout1.addExercise(exercise: Exercise(type: .pushups, amount: 30))
        
        let workout2 = Workout(name: "Back & Chest routine")
        workout2.addExercise(exercise: Exercise(type: .lunges, amount: 20))
        workout2.addExercise(exercise: Exercise(type: .pushups, amount: 20))
        workout2.addExercise(exercise: Exercise(type: .lunges, amount: 30))
        workout2.addExercise(exercise: Exercise(type: .lunges, amount: 20))
        workout2.addExercise(exercise: Exercise(type: .pushups, amount: 20))
        workout2.addExercise(exercise: Exercise(type: .lunges, amount: 30))
        
        let workout3 = Workout(name: "Easy morning")
        workout3.addExercise(exercise: Exercise(type: .lunges, amount: 20))
        workout3.addExercise(exercise: Exercise(type: .pushups, amount: 20))
        workout3.addExercise(exercise: Exercise(type: .lunges, amount: 30))
        
        let workout4 = Workout(name: "Debug workout")
        workout4.addExercise(exercise: Exercise(type: .lunges, amount: 2))
        workout4.addExercise(exercise: Exercise(type: .pushups, amount: 2))
        
        let workout5 = Workout(name: "Forces of Nature")
        workout5.addExercise(exercise: Exercise(type: .lunges, amount: 20))
        workout5.addExercise(exercise: Exercise(type: .pushups, amount: 20))
        workout5.addExercise(exercise: Exercise(type: .lunges, amount: 30))
        
        return [workout1, workout2, workout3, workout4, workout5]
    }
}
