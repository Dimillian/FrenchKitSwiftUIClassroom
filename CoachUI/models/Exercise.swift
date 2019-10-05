//
//  Exercise.swift
//  CoachUI
//
//  Created by Thomas Ricouard on 02/09/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation

enum ExerciseType: String, CaseIterable, Codable {
    case pushups, squats, lunges, deadlifts
    
    func duration() -> Int {
        switch self {
        case .pushups: return 3
        case .squats, .lunges: return 4
        case .deadlifts: return 5
        }
    }
    
    var name : String {
        switch self {
        case .pushups:
            return "Pushups"
        case .squats:
            return "Squats"
        case .lunges:
            return "Lunges"
        case .deadlifts:
            return "Deadlifts"
        }
    }
}

struct Exercise: Hashable, Equatable, Codable {
    let id = UUID().uuidString
    
    let type: ExerciseType
    let amount: Int
    var duration: Double {
        Double(type.duration() * amount)
    }
}
