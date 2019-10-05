//
//  WorkoutsView.swift
//  CoachUI
//
//  Created by Thomas Ricouard on 02/09/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct WorkoutsView: View {
    @EnvironmentObject var store: WorkoutsStore
    @State private var isWorkoutFormPresented = false
    
    private var addWorkoutButton: some View {
        Button(action: {
            self.isWorkoutFormPresented = true
        }, label: {
            Image(systemName: "plus.circle").imageScale(.large)
        })
    }
    
    private func workoutContextMenu(workout: Workout) -> some View {
        VStack {
                Button(action: {
                    self.store.toggleFavorite(workout: workout)
                }, label: {
                    HStack {
                        Image(systemName: store.favorites.contains(workout.id) ? "star.fill" : "star")
                        Text(store.favorites.contains(workout.id) ? "Remove from favorite" : "Add to favorite")
                    }
                })
        }
    }
    
    private func workoutRow(workout: Workout) -> some View {
        NavigationLink(destination: WorkoutDetailView(workout: workout)) {
            Text(workout.name)
                .contextMenu(menuItems: { self.workoutContextMenu(workout: workout) })
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Favorites")) {
                    ForEach(store.workouts.filter{ store.favorites.contains($0.id) }) { workout in
                        self.workoutRow(workout: workout)
                    }
                }
                Section(header: Text("All")) {
                    ForEach(store.workouts) { workout in
                        self.workoutRow(workout: workout)
                    }.onDelete { indexes in
                        self.store.removeWorkout(at: indexes.first!)
                    }
                }
            }
        .navigationBarTitle("Workouts")
        .navigationBarItems(trailing: addWorkoutButton)
        .sheet(isPresented: $isWorkoutFormPresented,
               content: { WorkoutCreatorView().environmentObject(self.store) })
        }
    }
}

struct WorkoutsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsView().environmentObject(WorkoutsStore())
    }
}
