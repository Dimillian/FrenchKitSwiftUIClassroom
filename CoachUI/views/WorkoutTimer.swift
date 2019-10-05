//
//  WorkoutTimer.swift
//  CoachUI
//
//  Created by Nicolas Zinovieff on 9/5/19.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

extension Double {
    public static func ~= (lhs: Double, rhs: Double) -> Bool {
        let epsilon = 0.05 // roughly equal
        return abs(lhs-rhs) < epsilon
    }
}

struct WorkoutTimer: View {
    @ObservedObject var workout: Workout
    
    @Binding var exercise: Exercise?
    @Binding var isStarted: Bool
    @Binding var showResultView: Bool
    
    @State private var progress : Double = 0
    @State private var timerTick: Timer?
    
    private func startExercice() {
        if let exercice = exercise {
            self.progress = 0
            self.isStarted = true
            self.timerTick = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
                if self.progress < 1 {
                    self.progress += 0.2 / (self.exercise?.duration ?? 0.0001)
                } else {
                    self.isStarted = false
                    self.timerTick?.invalidate()
                    
                    if let next = self.workout.nextExercise(exercice: exercice) {
                        self.exercise = next
                        self.startExercice()
                    } else {
                        self.showResultView = true
                    }
                }
            })
        }
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Path { (path) in
                    let size: CGFloat = min(geometry.size.width, geometry.size.height) * 0.7
                    let center = CGPoint(x: geometry.size.width*0.5, y: geometry.size.height*0.5)
                    
                    path.addEllipse(in: CGRect(x: center.x-size*0.5, y: center.y-size*0.5, width: size, height: size))
                    
                }.fill(LinearGradient(
                    gradient: .init(colors: [Color.blue, Color.red]),
                    startPoint: .init(x: 0.5, y: 0),
                    endPoint: .init(x: 0.5, y: 0.6)
                ))
            }
            GeometryReader { geometry in
                Path { (path) in
                    let size: CGFloat = min(geometry.size.width, geometry.size.height) * 0.7
                    let center = CGPoint(x: geometry.size.width*0.5, y: geometry.size.height*0.5)
                    
                    path.addEllipse(in: CGRect(x: center.x-size*0.5, y: center.y-size*0.5, width: size, height: size))
                    
                }.stroke(lineWidth: 10).foregroundColor(Color.gray)
            }
            GeometryReader { geometry in
                Path { (path) in
                    let size: CGFloat = min(geometry.size.width, geometry.size.height) * 0.7
                    let center = CGPoint(x: geometry.size.width*0.5, y: geometry.size.height*0.5)
                    
                    path.addArc(center: center, radius: size*0.5, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: (360*self.progress)-90), clockwise: false)
                    
                }
                .stroke(lineWidth: 10)
                .foregroundColor(Color.green)
                .animation(self.isStarted ? .easeInOut : nil)
            }
            
            VStack {
                Text(exercise?.type.name ?? "")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.yellow)
                    .animation(nil)
                Button(action: {
                    if !self.isStarted {
                        self.startExercice()
                    } else {
                        self.isStarted = false
                        self.timerTick?.invalidate()
                        self.progress = 0
                    }
                }) {
                    Text("GO!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.yellow)
                        .background(RoundedRectangle(cornerRadius: 4).padding(-4).foregroundColor(Color.gray))
                }.padding(2)
                
            }
        }.onDisappear {
            self.timerTick?.invalidate()
            self.timerTick = nil
        }
        .scaleEffect(isStarted ? 1.2 : 1.0)
        .animation(Animation.easeInOut.repeatCount(isStarted ? .max : 0))
    }
}

struct WorkoutTimer_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutTimer(workout: WorkoutsStore().workouts.first!,
                     exercise: .constant(Exercise(type: .pushups, amount: 20)),
                     isStarted: .constant(false),
                     showResultView: .constant(false))
    }
}
