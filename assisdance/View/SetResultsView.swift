//
//  SetResultsView.swift
//  assisdance
//
//  Created by Cynthia Z France on 12/3/23.
//

import SwiftUI

struct SetResultsView: View {
    let setResults: [String: Any]

    var body: some View {
        VStack {
            Text("Set Results")
                .font(.largeTitle)
                .padding()

            Spacer()
            HStack {
                //make width 750
                Spacer()
                StatisticView(title: "Dancers", value: String(setResults["dancers"] as? Int ?? 0), unit: "")
                Spacer()
                StatisticView(title: "Total Length", value: String(setResults["total_len"] as? Int ?? 0), unit: " s")
                Spacer()
            }
            HStack {
                Spacer()
                StatisticView(title: "Dance Time", value: String(setResults["dance_time"] as? Int ?? 0), unit: " s")
                Spacer()
                StatisticView(title: "Transition Time", value: String(setResults["transition_time"] as? Int ?? 0), unit: " s")
                Spacer()
            }
            HStack {
                Spacer()
                StatisticView(title: "Total Distance", value: String(setResults["total_distance"] as? Int ?? 0), unit: "")
                Spacer()
                StatisticView(title: "Avg Transition Speed", value: String(setResults["avg_transition_speed"] as? Double ?? 0), unit: " dist/s")
                Spacer()
            }
            HStack {
                Spacer()
                StatisticView(title: "Avg Formation Size", value: " \(String(setResults["avg_formation_w"] as? Double ?? 0)) x \(String(setResults["avg_formation_h"] as? Double ?? 0))", unit: "")
                Spacer()
            }
            
            Spacer()
        }
        .padding()
    }
}

struct StatisticView: View {
    let title: String
    let value: String
    let unit: String

    var body: some View {
        VStack {
            Text("\(value)\(unit)")
                .font(.system(size: 500).weight(.black))
                .minimumScaleFactor(0.01)
                .foregroundColor(.teal)
                .padding()
//                .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.5), value: 50)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(CGSize(width: 0, height: 50))
            Text(title)
                .foregroundColor(.teal)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .font(.system(size: 40).weight(.bold))
                .minimumScaleFactor(0.01)
                .multilineTextAlignment(.center)
            
        }
        .padding(.vertical, 5)
        .background(Color.white)
    }
}

struct SetResultsView_Previews: PreviewProvider {
    static var previews: some View {
        SetResultsView(setResults: [
            "dancers": 8,
            "total_len": 120,
            "dance_time": 80,
            "transition_time": 40,
            "total_distance": 150,
            "avg_transition_speed": 2.5,
            "avg_formation_w": 10.0,
            "avg_formation_h": 5.0
        ])
    }
}
