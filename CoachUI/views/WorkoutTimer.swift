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

struct Hand : Identifiable, Hashable {
    let id = UUID().uuidString
    
    let i : Int
}
struct WorkoutTimer: View {
    @ObservedObject var workout: Workout
    
    @Binding var exercise: Exercise?
    @Binding var isStarted: Bool
    @Binding var showResultView: Bool
    
    @State private var progress : Double = 0
    @State private var timerTick: Timer?
    
    private let hands : [Hand] = [Hand(i:1),Hand(i:2),Hand(i:3),Hand(i:4),Hand(i:5),Hand(i:6),Hand(i:7),Hand(i:8),Hand(i:9),Hand(i:10),Hand(i:11),Hand(i:12)]
    
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
    
    static let defaultClockSize : CGFloat = 140.0
    private func handPosition(hour : Int, clockSize: CGFloat = defaultClockSize) -> CGSize {
        let angle : CGFloat = CGFloat(hour)*CGFloat.pi*2/12.0 - (CGFloat.pi / 2)
        let posX = cos(angle)*clockSize
        let posY = sin(angle)*clockSize
        return CGSize(width: posX, height: posY)
    }
    
    var body: some View {
        ZStack {
            // the middle will animate, the flames won't
            ZStack {
                // Gradient
                GeometryReader { geometry in
                    Path { (path) in
                        let size: CGFloat = min(geometry.size.width, geometry.size.height) * 0.7
                        let center = CGPoint(x: geometry.size.width*0.5, y: geometry.size.height*0.5)
                        
                        path.addEllipse(in: CGRect(x: center.x-size*0.5, y: center.y-size*0.5, width: size, height: size))
                        
                    }.fill(LinearGradient(
                        gradient: .init(colors: [Color.gray, Color.gray.opacity(0.7)]),
                        startPoint: .init(x: 0.5, y: 0),
                        endPoint: .init(x: 0.5, y: 0.6)
                    ))
                }
                // Border
                GeometryReader { geometry in
                    Path { (path) in
                        let size: CGFloat = min(geometry.size.width, geometry.size.height) * 0.7
                        let center = CGPoint(x: geometry.size.width*0.5, y: geometry.size.height*0.5)
                        
                        path.addEllipse(in: CGRect(x: center.x-size*0.5, y: center.y-size*0.5, width: size, height: size))
                        
                    }.stroke(lineWidth: 10).foregroundColor(Color.gray)
                }
                // Progress
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
                        Text("GO!",tableName: nil,bundle: nil, comment: nil)
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
            .scaleEffect(isStarted ? 1.1 : 1.0)
            .animation(Animation.easeInOut.repeatCount(isStarted ? .max : 0))
            
            // Saint Seiya - like / tower clock with flames to be extinguished
            // No for loop, unfortunately
            // This is a bug. There is a maximum of items in a view/stack
            ZStack {
                Image(systemName: "flame.fill").foregroundColor(Color.blue)
                    .offset(self.handPosition(hour: 1))
                    .opacity((self.progress * 12.0 < 1.0) ? 1.0 : 0.0)
                Image(systemName: "flame.fill").foregroundColor(Color.blue)
                    .offset(self.handPosition(hour: 2))
                    .opacity((self.progress * 12.0 < 2.0) ? 1.0 : 0.0)
                Image(systemName: "flame.fill").foregroundColor(Color.blue)
                    .offset(self.handPosition(hour: 3))
                    .opacity((self.progress * 12.0 < 3.0) ? 1.0 : 0.0)
                Image(systemName: "flame.fill").foregroundColor(Color.blue)
                    .offset(self.handPosition(hour: 4))
                    .opacity((self.progress * 12.0 < 4.0) ? 1.0 : 0.0)
                Image(systemName: "flame.fill").foregroundColor(Color.blue)
                    .offset(self.handPosition(hour: 5))
                    .opacity((self.progress * 12.0 < 5.0) ? 1.0 : 0.0)
                Image(systemName: "flame.fill").foregroundColor(Color.blue)
                    .offset(self.handPosition(hour: 6))
                    .opacity((self.progress * 12.0 < 6.0) ? 1.0 : 0.0)
                Image(systemName: "flame.fill").foregroundColor(Color.blue)
                    .offset(self.handPosition(hour: 7))
                    .opacity((self.progress * 12.0 < 7.0) ? 1.0 : 0.0)
                Image(systemName: "flame.fill").foregroundColor(Color.blue)
                    .offset(self.handPosition(hour: 8))
                    .opacity((self.progress * 12.0 < 8.0) ? 1.0 : 0.0)
                Image(systemName: "flame.fill").foregroundColor(Color.blue)
                    .offset(self.handPosition(hour: 9))
                    .opacity((self.progress * 12.0 < 9.0) ? 1.0 : 0.0)
            }
            
            Image(systemName: "flame.fill").foregroundColor(Color.blue)
                .offset(self.handPosition(hour: 10))
                .opacity((self.progress * 12.0 < 10.0) ? 1.0 : 0.0)
            Image(systemName: "flame.fill").foregroundColor(Color.blue)
                .offset(self.handPosition(hour: 11))
                .opacity((self.progress * 12.0 < 11.0) ? 1.0 : 0.0)
            Image(systemName: "flame.fill").foregroundColor(Color.blue)
                .offset(self.handPosition(hour: 12))
                .opacity((self.progress * 12.0 < 12.0) ? 1.0 : 0.0)
        }
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
