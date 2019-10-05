//
//  WorkoutProgressView.swift
//  CoachUI
//
//  Created by Thomas Ricouard on 04/09/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct WorkoutProgressView: View {
    @ObservedObject var workout: Workout
    
    @State private var isStarted = false
    @State private var currentExercice: Exercise!
    @State private var showResultView: Bool = false
    
    private var buttonsView: some View {
        HStack(alignment: .center, spacing: 32) {
            Button(action: {
                if let exercice = self.workout.previousExercise(exercice: self.currentExercice) {
                    self.currentExercice = exercice
                }
            }, label: {
                Image(systemName: "backward")
                    .font(.title)
            })
            Button(action: {
                self.isStarted.toggle()
            }, label: {
                Image(systemName: self.isStarted ? "pause.circle" : "play.circle")
                    .font(.title)
            })
            Button(action: {
                if let exercice = self.workout.nextExercise(exercice: self.currentExercice) {
                    self.currentExercice = exercice
                }
            }, label: {
                Image(systemName: "forward")
                    .font(.title)
            })
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            if self.currentExercice != nil {
                // exerciseView
                WorkoutTimer(workout: workout,
                             exercise: $currentExercice,
                             isStarted: $isStarted,
                             showResultView: $showResultView)
                    .frame(height: 300)
                
                Rectangle()
                    .frame(height: 2)
                    .background(Color.secondary)
                buttonsView
            }
        }.onAppear {
            self.currentExercice = self.workout.exercises.first
        }.sheet(isPresented: $showResultView, content: { WorkoutResultView(workout: self.workout) })
    }
}

struct WorkoutProgressView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutProgressView(workout: WorkoutsStore().workouts.first!)
    }
}
