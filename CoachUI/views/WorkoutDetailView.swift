//
//  WorkoutDetailView.swift
//  CoachUI
//
//  Created by Thomas Ricouard on 02/09/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct WorkoutDetailView: View {
    @EnvironmentObject var store: WorkoutsStore
    let workout: Workout
    
    private var favButton: some View {
        Button(action: {
            self.store.toggleFavorite(workout: self.workout)
        }, label: {
            Image(systemName: store.favorites.contains(workout.id) ? "star.fill" : "star")
                .imageScale(.large)
                .foregroundColor(.yellow)
        })
    }
    var body: some View {
        List {
            Section(header: Text("Exercices")) {
                ForEach(workout.exercises, id: \.self) { exercise in
                    ExerciseRow(exercise: exercise)
                }
            }
            
            Section(header: Text("Details")) {
                Text("Workout duration: \(String(format: "%.f", workout.duration)) seconds")
                Text("Pause between exercises: 30 seconds")
                NavigationLink(destination: WorkoutProgressView(workout: workout)) {
                    Text("Start")
                        .foregroundColor(.green)
                }
            }
        }
        .navigationBarItems(trailing: favButton)
        .listStyle(GroupedListStyle())
        .navigationBarTitle(workout.name)
    }
}

struct WorkoutDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutDetailView(workout: WorkoutsStore().workouts.first!)
    }
}
