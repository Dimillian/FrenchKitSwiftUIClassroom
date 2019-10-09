//
//  WorkoutCreatorView.swift
//  CoachUI
//
//  Created by Thomas Ricouard on 02/09/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct WorkoutCreatorView: View {
    
    //MARK: - Properties
    @EnvironmentObject var store: WorkoutsStore
    @Environment(\.presentationMode) var presentationMode
    
    var editingWorkout: Workout?
    
    @State private var workoutName = ""
    @State private var exercises: [Exercise] = []
    @State private var inInsertMode = false
    @State private var selectedExercice: ExerciseType = .pushups
    @State private var selectedAmount: Double = 10
    
    // MARK: - nav buttons
    private var saveButton: some View {
        Button(action: {
            if let editing = self.editingWorkout {
                self.editingWorkout?.name = self.workoutName
                self.editingWorkout?.exercises = self.exercises
            } else {
                let workout = Workout(name: self.workoutName)
                for exercise in self.exercises {
                    workout.addExercise(exercise: exercise)
                }
                self.store.insertWorkout(workout: workout)
            }
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Save")
        })
    }
    
    private var cancelButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Cancel")
                .foregroundColor(.red)
        })
    }
    
    // MARK: - Sections views
    private var basicInfoSection: some View {
        Section(header: Text("Basic infos")) {
            HStack {
                Text("Workout name:")
                TextField("My cool workout", text: $workoutName)
            }
        }
    }
    
    private var exercicesSection: some View {
        Section(header: Text("Exercises")) {
            ForEach(exercises, id: \.self) { exercise in
                ExerciseRow(exercise: exercise)
            }.onDelete { indexes in
                self.exercises.remove(at: indexes.first!)
            }
        }
    }
    
    private var addExerciseSection: some View {
        Section {
            if inInsertMode {
                Text("\(Int(selectedAmount)) \(selectedExercice.rawValue.capitalized)")
                Picker(selection: $selectedExercice, label: Text("")) {
                    ForEach(ExerciseType.allCases, id: \.self) { exerciseType in
                        Text(exerciseType.rawValue.capitalized)
                    }
                }.pickerStyle(WheelPickerStyle())
                Slider(value: $selectedAmount, in: 1...50, step: 1)
                Button(action: {
                    self.inInsertMode = false
                    self.exercises.append(Exercise(type: self.selectedExercice, amount: Int(self.selectedAmount)))
                }, label: {
                    Text("Add this exercise")
                })
            } else {
                Button(action: {
                    self.inInsertMode = true
                }, label: {
                    Text("Add exercise")
                })
            }
        }
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            Form {
                basicInfoSection
                if exercises.count > 0 {
                    exercicesSection
                }
                addExerciseSection
            }
            .onAppear{
                if let editing = self.editingWorkout {
                    self.workoutName = editing.name
                    self.exercises = editing.exercises
                }
            }
            .navigationBarTitle("Create a new workout",
                                displayMode: .inline)
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
            
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct WorkoutCreatorView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutCreatorView()
    }
}
