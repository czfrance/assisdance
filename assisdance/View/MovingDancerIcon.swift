//
//  DancerIcon.swift
//  assisdance
//
//  Created by Cynthia Z France on 11/2/23.
//

import SwiftUI

struct MovingDancerIcon: Shape {
    @EnvironmentObject var formationBook: FormationBookViewModel
    @State var formation: FormationModel
    @State var dancer: DancerModel
    @State var posx: CGFloat
    @State var posy: CGFloat
    @State var isDragging = false
    @State var move = false
    @Binding var screenWidth: CGFloat
    @Binding var screenHeight: CGFloat
    var circleSize: CGFloat
    @State var orientation = UIDevice.current.orientation
    @State var dragAmount = CGSize.zero
    @State var path    : [[CGFloat]]
    @State var start   : CGPoint
    @State var duration: Double = 1
    @State var isMovingForward = false
    var tMax : CGFloat { isMovingForward ? 1 : 0 }  // Same expressions,
    var opac : Double  { isMovingForward ? 1 : 0 }  // different meanings.
    
    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
            .makeConnectable()
            .autoconnect()
    
    func path(in rect: CGRect) -> Path {
        return Path()
    }
    
    func modifyPath(path: [[CGFloat]]) -> Path {
        var result = Path()
        result.move(to: CGPoint(x: self.posx*screenWidth, y: self.posy*screenHeight))

        for i in 1..<path.count {
            result.addLine(to: CGPoint(x: path[i][0]*screenWidth, y: path[i][1]*screenHeight))
        }
        return result
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.gray)
                .frame(width: isDragging == true ? circleSize*1.3*1.1 : circleSize*1.3, height: isDragging == true ? circleSize*1.3*1.1 : circleSize*1.3)
                .position(x: self.posx*screenWidth, y: self.posy*screenHeight)
                .zIndex(isDragging == false ? 0 : 1)
                .modifier(MovingModifier(time: tMax, path: modifyPath(path: path), start: CGPoint(x: self.posx*screenWidth, y: self.posy*screenHeight), offset: CGPoint(x: (0.5-self.posx)*screenWidth, y: (0.5-self.posy)*screenHeight)))

                .animation(.easeInOut(duration: duration), value: tMax)
                .opacity(opac)
                .onReceive(orientationChanged) { _ in
                    self.orientation = UIDevice.current.orientation
                    _ = self.position(x: posx*screenWidth, y: posy*screenHeight)
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isMovingForward = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration + 0.1) {
                        isMovingForward = false
                    }
                }
            Circle()
                .fill(Color.red)
                .frame(width: isDragging == true ? circleSize*1.1 : circleSize, height: isDragging == true ? circleSize*1.1 : circleSize)
                .position(x: self.posx*screenWidth, y: self.posy*screenHeight)
                .zIndex(isDragging == false ? 0 : 1)
                .modifier(MovingModifier(time: tMax, path: modifyPath(path: path), start: CGPoint(x: self.posx*screenWidth, y: self.posy*screenHeight), offset: CGPoint(x: (0.5-self.posx)*screenWidth, y: (0.5-self.posy)*screenHeight)))

                .animation(.easeInOut(duration: duration), value: tMax)
                .opacity(opac)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isMovingForward = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration + 0.1) {
                        isMovingForward = false
                    }
                }
            Text(dancer.name == "" ? String(dancer.number) : dancer.name)
                .position(x: self.posx*screenWidth, y: self.posy*screenHeight)
                .zIndex(isDragging == false ? 0 : 1)
                .modifier(MovingModifier(time: tMax, path: modifyPath(path: path), start: CGPoint(x: self.posx*screenWidth, y: self.posy*screenHeight), offset: CGPoint(x: (0.5-self.posx)*screenWidth, y: (0.5-self.posy)*screenHeight)))
                .animation(.easeInOut(duration: duration), value: tMax)
                .opacity(opac)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isMovingForward = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration + 0.1) {
                        isMovingForward = false
                    }
                }
        }
    }
}

struct MovingModifier: AnimatableModifier {
    var time : CGFloat  // Normalized from 0...1.
    let path : Path
    let start: CGPoint  // Could derive from path.
    let offset : CGPoint

    var animatableData: CGFloat {
        get { time }
        set { time = newValue }
    }

    func body(content: Content) -> some View {
        content
            .position(
                path.trimmedPath(from: 0, to: time).currentPoint == nil ?
                CGPoint(x: start.x + offset.x, y: start.y + offset.y) :
                    CGPoint(x: path.trimmedPath(from: 0, to: time).currentPoint!.x + offset.x,
                            y: path.trimmedPath(from: 0, to: time).currentPoint!.y + offset.y)
            )
    }
}

//struct MovingDancerIcon_Previews: PreviewProvider {
//    static var previews: some View {
//        let dancer = DancerModel(number: 1, position: [0.5, 0.5])
//        let formation = FormationModel(name: "formation", dancers: [], tag: 0)
//        MovingDancerIcon(formation: formation, dancer: dancer, posx: 0.5, posy: 0.5, screenWidth: .constant(800.0), screenHeight: .constant(600.0), circleSize: 50, pageIndex: .constant(0))
//    }
//}
