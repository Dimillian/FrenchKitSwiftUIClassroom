//
//  Workout.swift
//  CoachUI
//
//  Created by Thomas Ricouard on 02/09/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation

struct HistoryItem : Codable, Identifiable {
    let id = UUID().uuidString

    let date: Date
    let exercise : Exercise
}

class Workout: ObservableObject, Identifiable, Equatable {
    let id = UUID().uuidString
    
    @Published var name: String
    @Published var exercises: [Exercise] = []
    
    static var history : [HistoryItem] {
        get {
            if let saved = UserDefaults.standard.data(forKey: "history"), let extracted = try? JSONDecoder().decode([HistoryItem].self, from: saved) {
                return extracted
            } else {
                // build a fake one
                var result = [HistoryItem]()
                for i in 0..<7 {
                    let store = WorkoutsStore.sharedStore
                    let date = Calendar.autoupdatingCurrent.date(bySettingHour: 12, minute: 0, second: 0, of: Date(timeIntervalSinceNow: -(7-Double(i))*24*3600)) ?? Date()
                    for exo in store?.workouts.randomElement()?.exercises ?? [] {
                        result.append(HistoryItem(date: date, exercise: exo))
                    }
                }
                
                return result
            }
        }
    }
    
    static func saveWorkout(_ workout: Workout) {
        var pastsave = history
        let calendar = NSCalendar.autoupdatingCurrent
        let midday = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: Date()) ?? Date()
        for exo in workout.exercises {
            pastsave.append(HistoryItem(date:midday, exercise: exo))
        }
        
        if let data = try? JSONEncoder().encode(pastsave) {
            UserDefaults.standard.set(data, forKey: "history")
            UserDefaults.standard.synchronize()
        }
    }
    
    var duration: Double {
        exercises.map{ $0.duration }.reduce(0, +)
    }
    
    init(name: String) {
        self.name = name
    }
    
    func addExercise(exercise: Exercise) {
        exercises.append(exercise)
    }
    
    func removeExercice(at index: Int) {
        exercises.remove(at: index)
    }
    
    func previousExercise(exercice: Exercise) -> Exercise? {
        if let index = exercises.firstIndex(of: exercice),
            index > 0 {
            return exercises[index - 1]
        }
        return nil
    }
    
    func nextExercise(exercice: Exercise) -> Exercise? {
        if let index = exercises.firstIndex(of: exercice),
            index < exercises.count - 1 {
            return exercises[index + 1]
        }
        return nil
    }
    
    static func == (lhs: Workout, rhs: Workout) -> Bool {
        lhs.id == rhs.id
    }
}

