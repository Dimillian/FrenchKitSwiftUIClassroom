//
//  ExerciseRow.swift
//  CoachUI
//
//  Created by Thomas Ricouard on 02/09/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct ExerciseRow: View {
    let exercise: Exercise
    
    var body: some View {
        HStack {
            Text(exercise.type.rawValue.capitalized)
            Spacer()
            Text("\(exercise.amount)").foregroundColor(.secondary)
        }
    }
}

struct ExerciseRow_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseRow(exercise: Exercise(type: .pushups, amount: 10))
    }
}
