//
//  SingleFormationView.swift
//  assisdance
//
//  Created by Cynthia Z France on 11/15/23.
//

import SwiftUI

struct SingleFormationView: View {
    @EnvironmentObject var formationBook: FormationBookViewModel
    @State var formation: FormationModel
    @State var orientation = UIDevice.current.orientation
    @State var screenWidth: CGFloat = 0.0
    @State var screenHeight: CGFloat = 0.0
    @Binding var pageIndex: Int
    
    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
            .makeConnectable()
            .autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    let numberOfHorizontalGridLines = 9
                    let numberOfVerticalGridLines = 9
                    for index in 0...numberOfVerticalGridLines {
                        let vOffset: CGFloat = CGFloat(index) * 0.1 * screenWidth
                        path.move(to: CGPoint(x: vOffset, y: 0))
                        path.addLine(to: CGPoint(x: vOffset, y: screenHeight))
                    }
                    for index in 0...numberOfHorizontalGridLines {
                        let hOffset: CGFloat = CGFloat(index) * 0.1 * screenHeight
                        path.move(to: CGPoint(x: 0, y: hOffset))
                        path.addLine(to: CGPoint(x: screenWidth, y: hOffset))
                    }
                }
                .stroke()
                .opacity(0.25)
                
                ForEach(formation.dancers) { dancer in
                    DancerIcon(formation: formation, dancer: dancer, posx: dancer.position[0], posy: dancer.position[1], screenWidth: $screenWidth, screenHeight: $screenHeight, circleSize: geometry.size.width*0.05, pageIndex: $pageIndex)
                }
                
//                Button("check") {
//                    for dancer in formation.dancers {
//                        print(dancer.path)
//                    }
//                }
//                .buttonStyle(.borderedProminent)
            }
            .frame(width: geometry.size.width > geometry.size.height ? geometry.size.height*(4/3) : geometry.size.width, height: geometry.size.width > geometry.size.height ? geometry.size.height : geometry.size.width * 0.75)
            .onAppear {
                Task { @MainActor in
                    try await Task.sleep(for: .seconds(0.1))
                    self.screenWidth = geometry.size.width
                    self.screenHeight = geometry.size.height
//                    print("\(screenWidth), \(screenHeight)")
                }
            }
            .onReceive(orientationChanged) { _ in
                Task { @MainActor in
                    try await Task.sleep(for: .seconds(0.1))
                    self.orientation = UIDevice.current.orientation
                    self.screenWidth = geometry.size.width
                    self.screenHeight = geometry.size.height
//                    print("\(screenWidth), \(screenHeight)")
                }
            }
        }
        .cornerRadius(20)
//        .scaledToFit()
        .shadow(radius: 5, x: 0, y: 5)
        .border(.green, width: 10)
    }
}

struct SingleFormationView_Previews: PreviewProvider {
    static var previews: some View {
        let dancer1 = DancerModel(number: 1, position: [25.0, 25.0])
        let dancer2 = DancerModel(number: 2, position: [50.0, 50.0])
        let formation = FormationModel(name: "Formation 1", dancers: [dancer1, dancer2], tag: 0)
        SingleFormationView(formation: formation, pageIndex: .constant(0))
//            .previewInterfaceOrientation(.landscapeLeft)
    }
}
