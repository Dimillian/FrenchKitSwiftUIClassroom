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
    @ObservedObject var workout: Workout
    @State private var isWorkoutFormPresented = false
    
    private var favButton: some View {
        Button(action: {
            self.store.toggleFavorite(workout: self.workout)
        }, label: {
            Image(systemName: store.favorites.contains(workout.id) ? "star.fill" : "star")
                .imageScale(.large)
                .foregroundColor(.yellow)
        })
    }
    
    private var deleteButton: some View {
        Button(action: {
            if let index = self.store.workouts.firstIndex(of: self.workout) {
                self.store.removeWorkout(at: index)
            }
        }, label: {
            Image(systemName: "trash")
                .imageScale(.large)
                .foregroundColor(.red)
        })
    }
    
    
    private var editButton: some View {
        Button(action: {
            self.isWorkoutFormPresented = true
        }, label: {
            Text("Edit").foregroundColor(.blue)
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
        .navigationBarItems(trailing:
            HStack {
                favButton.padding()
                deleteButton
                editButton
            })
        .listStyle(GroupedListStyle())
        .navigationBarTitle(workout.name)
        .sheet(isPresented: $isWorkoutFormPresented,
               content: { WorkoutCreatorView(editingWorkout: self.workout).environmentObject(self.store)
                
        })
    }
}

struct WorkoutDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutDetailView(workout: WorkoutsStore().workouts.first!)
    }
}
