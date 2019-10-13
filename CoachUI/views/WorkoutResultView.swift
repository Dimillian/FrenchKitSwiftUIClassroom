//
//  WorkoutResultView.swift
//  CoachUI
//
//  Created by Thomas Ricouard on 09/09/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

func rangeOfRanges<C: Collection>(_ ranges: C) -> Range<Double>
    where C.Element == Range<Double> {
        guard !ranges.isEmpty else { return 0..<0 }
        let low = ranges.lazy.map { $0.lowerBound }.min()!
        let high = ranges.lazy.map { $0.upperBound }.max()!
        return low..<high
}

func magnitude(of range: Range<Double>) -> Double {
    return range.upperBound - range.lowerBound
}

struct GraphCapsule: View {
    var index: Int
    var height: CGFloat
    var range: Range<Double>
    var overallRange: Range<Double>
    
    var heightRatio: CGFloat {
        max(CGFloat(magnitude(of: range) / magnitude(of: overallRange)), 0.15)
    }
    
    var offsetRatio: CGFloat {
        CGFloat((range.lowerBound - overallRange.lowerBound) / magnitude(of: overallRange))
    }
    
    var animation: Animation {
        Animation.spring(dampingFraction: 0.5)
            .speed(2)
            .delay(0.03 * Double(index))
    }
    
    var body: some View {
        Capsule()
            .fill(Color.white)
            .frame(height: height * heightRatio, alignment: .bottom)
            .offset(x: 0, y: height * -offsetRatio)
            .animation(animation)
    }
}

enum GraphType {
    case duration
    case count
}

struct ToggleTextButton: View {
    @Binding var isOn: Bool
    @Binding var type : GraphType
    var body: some View {
        Button(
            action: {
                self.isOn.toggle()
                self.type = self.isOn ? .duration : .count
        },
            label: { Text(self.isOn ? "Duration" : "Count") }
        )
    }
}

// from https://stackoverflow.com/questions/24051314/precision-string-format-specifier-in-swift
extension Double {
    func format(_ f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

struct WorkoutResultView: View {
    @ObservedObject var workout: Workout
    @State var type : GraphType = .duration
    @State var toggle : Bool = true
    
    var color : Color {
        switch type {
        case .duration:
            return Color.orange
        case .count:
            return Color.purple
        @unknown default:
            break
        }
    }
    
    struct GraphElement : Identifiable {
        let id = UUID().uuidString
        let index : Int
        let count : Double
        let duration : Double
    }
    var stats : [GraphElement] {
        var result = [GraphElement]()
        var cursor = 0
        var dateCursor = Calendar.autoupdatingCurrent.date(bySettingHour: 12, minute: 0, second: 0, of: Date(timeIntervalSinceNow: -7*24*3600)) ?? Date()
        let now = Date()
        
        while dateCursor < now {
            let filtered = Workout.history.filter { $0.date == dateCursor }
            let counts = filtered.map( { $0.exercise.amount} ).reduce(0,+)
            let durations = filtered.map( { $0.exercise.duration} ).reduce(0,+)
            let ge = GraphElement(index: cursor, count: Double(counts), duration: durations)
            
            result.append(ge)
            cursor += 1
            dateCursor = dateCursor.addingTimeInterval(24*3600)
        }
        
        return result
    }
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        // last 7 days
        let cStats = stats
        let overallRange = rangeOfRanges(cStats.map { (self.type == .duration ? Range(uncheckedBounds: (0.0, $0.duration)) : Range(uncheckedBounds: (0.0, $0.count)) ) } )
        let maxMagnitude = overallRange.upperBound
        let heightRatio = 1 - CGFloat(maxMagnitude / magnitude(of: overallRange))
        return
            VStack {
                ToggleTextButton(isOn: $toggle, type: $type)
                GeometryReader { geom in
                    ZStack {
                        HStack(alignment: .bottom, spacing: geom.size.width / 120) {
                            ForEach(cStats) { datum in
                                ZStack {
                                    GraphCapsule(index: datum.index,
                                                 height: geom.size.height,
                                                 range: Range(uncheckedBounds: (0, self.type == .duration ? datum.duration : datum.count)),
                                                 overallRange: overallRange
                                    ).colorMultiply(self.color)
                                    Text("\(self.type == .duration ? datum.duration.format(".0") : datum.count.format(".0"))").rotationEffect(Angle(degrees: -90))
                                }
                            }.offset(x: 0, y: geom.size.height * heightRatio)
                        }.padding()
                    }
                }
                if self.type == .duration {
                    Text("Total duration in s")
                } else {
                    Text("Total count")
                }
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Close")
                }
            }
            .frame(height: 250)
    }
}

struct WorkoutResultView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutResultView(workout: WorkoutsStore().workouts.first!)
    }
}
