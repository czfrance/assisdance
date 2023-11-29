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
    @State var nextFormation: FormationModel?
    @State var orientation = UIDevice.current.orientation
    @State var screenWidth: CGFloat = 0.0
    @State var screenHeight: CGFloat = 0.0
    @Binding var pageIndex: Int
    
    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
            .makeConnectable()
            .autoconnect()
    
    @State var dancerIcons: [DancerIcon] = []
    @State var transition: Bool = false
    
    func makePath(dancer: DancerModel) -> [[CGFloat]] {
        var result: [[CGFloat]] = []
        result.append([dancer.position[0], dancer.position[1]])
        
        for p in dancer.path {
            print("\(p[0]), \(p[1])")
            result.append([p[0], p[1]])
        }
        
        if nextFormation != nil {
            let nextPos = dancerNextPosition(dId: dancer.id)
            if nextPos != nil {
                result.append([nextPos![0], nextPos![1]])
            }
        }
        
        return result
    }
    
    func dancerNextPosition(dId: UUID) -> [Double]? {
        for d in nextFormation!.dancers {
            if d.id == dId {
                return d.position
            }
        }
        return nil
    }
    
    var body: some View {
        GeometryReader { geometry in
            switch dancerIcons.count {
            case 0:
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
                .onAppear {
                    for dancer in formation.dancers {
                        let icon = DancerIcon(formation: formation, dancer: dancer, posx: dancer.position[0], posy: dancer.position[1], screenWidth: $screenWidth, screenHeight: $screenHeight, circleSize: geometry.size.width*0.05, pageIndex: $pageIndex, op: $transition)
                        dancerIcons.append(icon)
                    }
                }
            default:
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
                    
                    switch transition {
                    case true:
                        ForEach(formation.dancers) { dancer in
                            MovingDancerIcon(formation: formation, dancer: dancer, posx: dancer.position[0], posy: dancer.position[1], screenWidth: $screenWidth, screenHeight: $screenHeight, circleSize: geometry.size.width*0.05, pageIndex: $pageIndex, path: makePath(dancer: dancer), start: CGPoint(x: dancer.position[0], y: dancer.position[1]), duration: 5)
                        }
                    default:
                        EmptyView()
                    }
                    
                    ForEach(formation.dancers) { dancer in
                        DancerIcon(formation: formation, dancer: dancer, posx: dancer.position[0], posy: dancer.position[1], screenWidth: $screenWidth, screenHeight: $screenHeight, circleSize: geometry.size.width*0.05, pageIndex: $pageIndex, op: $transition)
                    }
                    
                    Button(action: {
                        self.transition = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5 + 0.1) {
                            self.transition = false
                        }
                    }) {
                        Text("Move")
                    }
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
//            if dancerIcons.count == 0 {
//                Path { path in
//                    let numberOfHorizontalGridLines = 9
//                    let numberOfVerticalGridLines = 9
//                    for index in 0...numberOfVerticalGridLines {
//                        let vOffset: CGFloat = CGFloat(index) * 0.1 * screenWidth
//                        path.move(to: CGPoint(x: vOffset, y: 0))
//                        path.addLine(to: CGPoint(x: vOffset, y: screenHeight))
//                    }
//                    for index in 0...numberOfHorizontalGridLines {
//                        let hOffset: CGFloat = CGFloat(index) * 0.1 * screenHeight
//                        path.move(to: CGPoint(x: 0, y: hOffset))
//                        path.addLine(to: CGPoint(x: screenWidth, y: hOffset))
//                    }
//                }
//                .stroke()
//                .opacity(0.25)
//                .onAppear {
//                    for dancer in formation.dancers {
//                        let icon = DancerIcon(formation: formation, dancer: dancer, posx: dancer.position[0], posy: dancer.position[1], screenWidth: $screenWidth, screenHeight: $screenHeight, circleSize: geometry.size.width*0.05, pageIndex: $pageIndex)
//                        dancerIcons.append(icon)
//                    }
//                }
//            }
//            else {
//                ZStack {
//                    Button(action: {
//                        dancerIcons[0].movePos(xAmount: 100.0, yAmount: 100.0, duration: 2)
//                    }) {
//                        Text("Press Me")
//                    }
//                    Path { path in
//                        let numberOfHorizontalGridLines = 9
//                        let numberOfVerticalGridLines = 9
//                        for index in 0...numberOfVerticalGridLines {
//                            let vOffset: CGFloat = CGFloat(index) * 0.1 * screenWidth
//                            path.move(to: CGPoint(x: vOffset, y: 0))
//                            path.addLine(to: CGPoint(x: vOffset, y: screenHeight))
//                        }
//                        for index in 0...numberOfHorizontalGridLines {
//                            let hOffset: CGFloat = CGFloat(index) * 0.1 * screenHeight
//                            path.move(to: CGPoint(x: 0, y: hOffset))
//                            path.addLine(to: CGPoint(x: screenWidth, y: hOffset))
//                        }
//                    }
//                    .stroke()
//                    .opacity(0.25)
//                    
//                    ForEach(0..<$dancerIcons.count) { (index) in
//                        dancerIcons[index]
//                    }
//                    
//                    //                ForEach(formation.dancers) { dancer in
//                    //                    DancerIcon(formation: formation, dancer: dancer, posx: dancer.position[0], posy: dancer.position[1], screenWidth: $screenWidth, screenHeight: $screenHeight, circleSize: geometry.size.width*0.05, pageIndex: $pageIndex)
//                    //                }
//                    
//                    //                Button("check") {
//                    //                    for dancer in formation.dancers {
//                    //                        print(dancer.path)
//                    //                    }
//                    //                }
//                    //                .buttonStyle(.borderedProminent)
//                }
//                .frame(width: geometry.size.width > geometry.size.height ? geometry.size.height*(4/3) : geometry.size.width, height: geometry.size.width > geometry.size.height ? geometry.size.height : geometry.size.width * 0.75)
//                .onAppear {
//                    Task { @MainActor in
//                        try await Task.sleep(for: .seconds(0.1))
//                        self.screenWidth = geometry.size.width
//                        self.screenHeight = geometry.size.height
//                        //                    print("\(screenWidth), \(screenHeight)")
//                    }
//                }
//                .onReceive(orientationChanged) { _ in
//                    Task { @MainActor in
//                        try await Task.sleep(for: .seconds(0.1))
//                        self.orientation = UIDevice.current.orientation
//                        self.screenWidth = geometry.size.width
//                        self.screenHeight = geometry.size.height
//                        //                    print("\(screenWidth), \(screenHeight)")
//                    }
//                }
//            }
        }
        .cornerRadius(20)
        .shadow(radius: 5, x: 0, y: 5)
        .border(.gray, width: 2)
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
