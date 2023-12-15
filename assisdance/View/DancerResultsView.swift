//
//  DancerResultsView.swift
//  assisdance
//
//  Created by Cynthia Z France on 12/5/23.
//

import SwiftUI

struct DancerResultsView: View {
    let dancerResults: [String: [String: Any]]

    var body: some View {
        VStack {
            Text("Dancer Summary")
                .font(.largeTitle)
                .padding()
            Spacer()
            VStack {
                Text("Dancer Information")
                    .font(.title3)
//                ScrollView() {
//                    ForEach(Array(dancerResults.keys), id: \.self) { key in
//                        Text(dancerResults[key]!["number"])
//                        DancerCard(num: String(dancerResults[key]!["number"]),
//                                   name: String(dancerResults[key]!["name"]),
//                                   distance: String(dancerResults[key]!["distance"] as? Double ?? 0),
//                                   lTime: String(dancerResults[key]!["lTime"] as? Double ?? 0),
//                                   rTime: String(dancerResults[key]!["rTime"] as? Double ?? 0),
//                                   cTime: String(dancerResults[key]!["cTime"] as? Double ?? 0),
//                                   fTime: String(dancerResults[key]!["fTime"] as? Double ?? 0),
//                                   bTime: String(dancerResults[key]!["bTime"] as? Double ?? 0))
//                    }
//                    ForEach(0..<dancerResults.count) { i in
//                        DancerCard(num: String(i), name: String(dancerResults[String(i)]!["name"]), distance: String(dancerResults[String(i)]!["distance"] as? Double ?? 0), lTime: String(dancerResults[String(i)]!["lTime"] as? Double ?? 0), rTime: String(dancerResults[String(i)]!["rTime"] as? Double ?? 0), cTime: String(dancerResults[String(i)]!["cTime"] as? Double ?? 0), fTime: String(dancerResults[String(i)]!["fTime"] as? Double ?? 0), bTime: String(dancerResults[String(i)]!["bTime"] as? Double ?? 0))
//                            .frame(maxWidth: .infinity, minHeight: 300)
//                        //path: dancerResults[String(i)]!["path"] as? [Any] ?? []
//                    }
//                }
            }
        }
        .padding()
    }
}

struct DancerCard: View {
    let num: String
    let name: String
    let distance: String
    let lTime: String
    let rTime: String
    let cTime: String
    let fTime: String
    let bTime: String
//    let path: [Any]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("hi")
//            if (name != "") {
//                Text("\(name)")
//                    .font(.title2)
//            }
//            else {
//                Text("Dancer \(num)")
//                    .font(.title2)
//            }
//            Spacer()
//            VStack {
//                Label("center time: \(cTime)", systemImage: "star")
//                HStack {
//                    Spacer()
//                    VStack {
//                        Text("Horizontal Movement")
//                            .font(.title3)
//                        Text("Left: \(lTime)")
//                        Text("Right: \(rTime)")
//                    }
//                    Spacer()
//                    VStack {
//                        Text("Vertical Movement")
//                            .font(.title3)
//                        Text("Front: \(fTime)")
//                        Text("Back: \(bTime)")
//                    }
//                    Spacer()
//                }
//            }
        }
        .padding()
        .background(Color.mint.opacity(0.5))
        .cornerRadius(15)
    }
}

#Preview {
    DancerResultsView(dancerResults: [
        "20AA3439-1FB8-4D8B-A069-1966B75DEF75": [
          "name": "",
          "number": 1,
          "distance": 0,
          "lTime": 15,
          "rTime": 0,
          "cTime": 5,
          "fTime": 5,
          "bTime": 10,
          "path": []
        ],
        "746102F1-B426-487C-B99E-43BFD42329D0": [
          "name": "",
          "number": 2,
          "distance": 0,
          "lTime": 5,
          "rTime": 5,
          "cTime": 10,
          "fTime": 0,
          "bTime": 10,
          "path": []
        ],
        "9F530CA0-BC4C-43E6-A703-ABFEEFC01F67": [
          "name": "",
          "number": 3,
          "distance": 0,
          "lTime": 0,
          "rTime": 0,
          "cTime": 20,
          "fTime": 0,
          "bTime": 0,
          "path": []
        ],
        "79680441-C6E8-4C25-993D-30F3120C5402": [
          "name": "",
          "number": 4,
          "distance": 0,
          "lTime": 0,
          "rTime": 15,
          "cTime": 5,
          "fTime": 10,
          "bTime": 5,
          "path": []
        ],
        "99E691AD-32A8-47AD-A33C-EC3D921A427C": [
          "name": "",
          "number": 5,
          "distance": 0,
          "lTime": 5,
          "rTime": 15,
          "cTime": 0,
          "fTime": 0,
          "bTime": 20,
          "path": []
        ]
    ])
}
