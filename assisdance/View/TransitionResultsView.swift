//
//  TransitionResultsView.swift
//  assisdance
//
//  Created by Cynthia Z France on 12/5/23.
//

import SwiftUI
import Charts

struct TransitionResultsView: View {
    let transitionResults: [String: [String: Any]]
    
    func getTransitionTimes() -> [(Int, Double)] {
        var formations: [[String: Any]] = []
        for i in 0..<transitionResults.count {
            formations.append(transitionResults[String(i)]!)
        }
        
        var times: [(Int, Double)] = []
        for (i, formation) in formations.enumerated() {
            times.append((i, formation["transition_time"] as? Double ?? 0))
        }
        
        return times
    }
    
    func getDistance() -> [(Int, Double)] {
        var formations: [[String: Any]] = []
        for i in 0..<transitionResults.count {
            formations.append(transitionResults[String(i)]!)
        }
        
        var widths: [(Int, Double)] = []
        for (i, formation) in formations.enumerated() {
            widths.append((i, formation["total_distance"] as? Double ?? 0))
        }
        return widths
    }
    
    func getSpeed() -> [(Int, Double)] {
        var formations: [[String: Any]] = []
        for i in 0..<transitionResults.count {
            formations.append(transitionResults[String(i)]!)
        }
        
        var heights: [(Int, Double)] = []
        for (i, formation) in formations.enumerated() {
            heights.append((i, formation["avg_speed"] as? Double ?? 0))
        }
        return heights
    }

    var body: some View {
        VStack {
            Text("Transition Summary")
                .font(.largeTitle)
                .padding()
            Spacer()
            VStack {
                Text("Length, Distance & Speed Distribution")
                    .font(.title3)
                Chart {
                    ForEach(getTransitionTimes(), id:\.0) { formation in
                        LineMark(
                            x: .value("transition", formation.0),
                            y: .value("seconds", formation.1),
                            series: .value("measurement", "A")
                        )
                        .foregroundStyle(.mint)
                    }
                    ForEach(getDistance(), id:\.0) { distance in
                        LineMark(
                            x: .value("width", distance.0),
                            y: .value("value", distance.1),
                            series: .value("measurement", "B")
                        )
                        .foregroundStyle(.red)
                    }
                    ForEach(getSpeed(), id:\.0) { speed in
                        LineMark(
                            x: .value("height", speed.0),
                            y: .value("value", speed.1),
                            series: .value("measurement", "C")
                        )
                        .foregroundStyle(.purple)
                    }
                }
                .chartForegroundStyleScale([
                    "Time Length": Color.mint,
                    "Total Distance": Color.red,
                    "Average Speed": Color.purple,
                ])
                .chartLegend(position: .bottom)
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .chartXAxisLabel(position: .bottom, alignment: .center) {
                    Text("Transition (number)")
                }
                .chartPlotStyle { plotArea in
                    plotArea
                        .background(.gray.opacity(0.1))
                }
                .padding()
            }
            .padding(.bottom)
            Spacer()
            VStack {
                Text("Transitions Information")
                    .font(.title3)
                ScrollView() {
                    ForEach(0..<transitionResults.count) { i in
                        TransitionCard(num: String(i), time: String(transitionResults[String(i)]!["transition_time"] as? Double ?? 0), distance: String(transitionResults[String(i)]!["total_distance"] as? Double ?? 0), speed: String(transitionResults[String(i)]!["avg_speed"] as? Double ?? 0))
                            .frame(maxWidth: .infinity, minHeight: 100)
                    }
                }
            }
        }
        .padding()
    }
}

struct TransitionCard: View {
    let num: String
    let time: String
    let distance: String
    let speed: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Formation \(num)")
                .font(.title2)
            Spacer()
            HStack {
                Label("\(time)", systemImage: "clock")
                    .padding(.trailing)
                Label("\(distance)", systemImage: "ruler")
                    .padding(.trailing)
                Label("\(speed)", systemImage: "stopwatch")
                Spacer()
            }
            .font(.headline)
        }
        .padding()
        .background(Color.gray.opacity(0.25))
        .cornerRadius(15)
    }
}

#Preview {
    TransitionResultsView(transitionResults: [
        "0": [
            "transition_time": 1.234,
          "total_distance": 137.54365989393364,
          "avg_speed": 27.508731978786727
        ],
        "1": [
            "transition_time": 1.94726,
          "total_distance": 249.8144927428778,
          "avg_speed": 49.96289854857556
        ],
        "2": [
          "transition_time": 2.000000000000001,
          "total_distance": 185.1957178785087,
          "avg_speed": 37.03914357570174
        ],
        "3": [
            "transition_time": 1.102394,
            "total_distance": 0.0,
            "avg_speed": 0.0
        ]
])
}
