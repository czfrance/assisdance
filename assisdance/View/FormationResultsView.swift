//
//  FormationResultsView.swift
//  assisdance
//
//  Created by Cynthia Z France on 12/5/23.
//

import SwiftUI
import Charts

struct FormationResultsView: View {
    let formationResults: [String: [String: Any]]
    
    func getFormationTimes() -> [(Int, Double)] {
        var formations: [[String: Any]] = []
        for i in 0..<formationResults.count {
            formations.append(formationResults[String(i)]!)
        }
        
        var times: [(Int, Double)] = []
        for (i, formation) in formations.enumerated() {
            times.append((i, formation["formation_time"] as? Double ?? 0))
        }
        
        return times
    }
    
    func getWidths() -> [(Int, Double)] {
        var formations: [[String: Any]] = []
        for i in 0..<formationResults.count {
            formations.append(formationResults[String(i)]!)
        }
        
        var widths: [(Int, Double)] = []
        for (i, formation) in formations.enumerated() {
            widths.append((i, formation["width"] as? Double ?? 0))
        }
        return widths
    }
    
    func getHeights() -> [(Int, Double)] {
        var formations: [[String: Any]] = []
        for i in 0..<formationResults.count {
            formations.append(formationResults[String(i)]!)
        }
        
        var heights: [(Int, Double)] = []
        for (i, formation) in formations.enumerated() {
            heights.append((i, formation["height"] as? Double ?? 0))
        }
        return heights
    }

    var body: some View {
        VStack {
            Text("Formation Summary")
                .font(.largeTitle)
                .padding()

            Spacer()
            VStack {
                Text("Time Distribution")
                    .font(.title3)
                Chart {
                    ForEach(getFormationTimes(), id:\.0) { formation in
                        LineMark(
                            x: .value("formation", formation.0),
                            y: .value("seconds", formation.1)
                        )
                        .foregroundStyle(.mint)
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .chartXAxisLabel(position: .bottom, alignment: .center) {
                    Text("Formation (number)")
                }
                .chartPlotStyle { plotArea in
                    plotArea
                        .background(.gray.opacity(0.1))
                }
                .padding()
            }
            Spacer()
            VStack {
                Text("Formation Dimensions Distribution")
                    .font(.title3)
                Chart {
                    ForEach(getWidths(), id:\.0) { width in
                        LineMark(
                            x: .value("width", width.0),
                            y: .value("value", width.1),
                            series: .value("measurement", "A")
                        )
                        .foregroundStyle(.red)
                    }
                    ForEach(getHeights(), id:\.0) { height in
                        LineMark(
                            x: .value("height", height.0),
                            y: .value("value", height.1),
                            series: .value("measurement", "B")
                        )
                        .foregroundStyle(.black)
                    }
                }
                .chartForegroundStyleScale([
                    "Width": Color.red,
                    "Height": Color.purple,
                ])
                .chartLegend(position: .bottom)
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .chartXAxisLabel(position: .bottom, alignment: .center) {
                    Text("Formation (number)")
                }
                .chartPlotStyle { plotArea in
                    plotArea
                        .background(.gray.opacity(0.1))
                }
                .padding()
            }
            Spacer()
            VStack {
                Text("Formations Information")
                    .font(.title3)
                ScrollView() {
                    ForEach(0..<formationResults.count) { i in
                        FormationCard(num: String(i), time: String(formationResults[String(i)]!["formation_time"] as? Double ?? 0), width: String(formationResults[String(i)]!["width"] as? Double ?? 0), height: String(formationResults[String(i)]!["height"] as? Double ?? 0))
                            .frame(maxWidth: .infinity, minHeight: 100)
                    }
                }
            }
            Spacer()
        }
        .padding()
    }
}

struct FormationCard: View {
    let num: String
    let time: String
    let width: String
    let height: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Formation \(num)")
                .font(.title2)
            Spacer()
            HStack {
                Label("\(time)", systemImage: "clock")
                Spacer()
                Label("\(width) x \(height)", systemImage: "square.resize")
            }
            .font(.headline)
        }
        .padding()
        .background(Color.gray.opacity(0.25))
        .cornerRadius(15)
    }
}

#Preview {
    FormationResultsView(formationResults: [
        "0": [
            "formation_time": 5.1,
            "width": 40.0,
            "height": 0
        ],
        "1": [
            "formation_time": 3.2,
          "width": 60.09291521486644,
          "height": 11.924119241192411
        ],
        "2": [
            "formation_time": 1.4,
          "width": 44.8780487804878,
          "height": 41.65698799845141
        ],
        "3": [
            "formation_time": 10.1,
          "width": 20.75493612078978,
          "height": 65.66008517228029
        ],
        "4": [
            "formation_time": 3.9,
            "width": 67.1239873485034,
          "height": 65.66008517228029
        ],
        "5": [
            "formation_time": 4.5,
            "width": 35.3049581972348,
            "height": 55.204983509348
        ],
        "6": [
            "formation_time": 5.0,
            "width": 12.1232549435496,
            "height": 74.109345834096
        ],
        "7": [
            "formation_time": 7.2,
            "width": 90.1029438594596,
            "height": 84.120493850349
        ],
        "8": [
            "formation_time": 0.5,
            "width": 46.1304953459385,
            "height": 7.0284572490104
        ]
    ])
}
