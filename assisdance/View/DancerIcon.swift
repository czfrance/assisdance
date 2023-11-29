//
//  DancerIcon.swift
//  assisdance
//
//  Created by Cynthia Z France on 11/2/23.
//

import SwiftUI

struct DancerIcon: Shape {
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
    @Binding var pageIndex: Int
    @Binding var op: Bool
    
    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
            .makeConnectable()
            .autoconnect()
    
//    init(dId: UUID, posx: CGFloat, posy: CGFloat) {
//        self.posx = posx
//        self.posy = posy
//    }
    
    func path(in rect: CGRect) -> Path {
        return Path()
    }
    
    
    func update_pos() {
        posx += self.dragAmount.width / screenWidth
        posy += self.dragAmount.height / screenHeight
        _ = self.position(x: posx, y: posy)
        self.dragAmount = CGSize.zero
        print("dimenstions: (\(screenWidth), \(screenHeight))")
        print("(x: \(posx), y: \(posy))")
        dancer.updatePosition(x: posx, y: posy)
        print(formation)
        formation.updateDancer(dId: dancer.id, x: posx, y: posy)
        print(formation)
    }
    
//    func movePos(xAmount: CGFloat, yAmount: CGFloat, duration: TimeInterval) {
//        print("dancer: \(dancer.number)")
//        print(xAmount)
//        withAnimation(.linear(duration: duration)) {
//            self.dragAmount = CGSize(width: xAmount, height: yAmount)
//        }
//        print(self.dragAmount)
//    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.gray)
                .frame(width: isDragging == true ? circleSize*1.3*1.1 : circleSize*1.3, height: isDragging == true ? circleSize*1.3*1.1 : circleSize*1.3)
                .position(x: self.posx*screenWidth, y: self.posy*screenHeight)
                .offset(dragAmount)
                .zIndex(isDragging == false ? 0 : 1)
                .gesture(
                    DragGesture(coordinateSpace: .global)
                        .onChanged {
                            self.isDragging = true
                            self.dragAmount = CGSize(width: $0.translation.width, height: $0.translation.height)
                        }
                        .onEnded {_ in
                            self.isDragging = false
                            update_pos()
                        }
                )
                .animation(Animation.timingCurve(0.2, 0.8, 0.2, 1, duration: 5.0), value: move)
                .onReceive(orientationChanged) { _ in
                    self.orientation = UIDevice.current.orientation
                    _ = self.position(x: posx*screenWidth, y: posy*screenHeight)
                }
            Circle()
                .fill(Color.mint)
                .frame(width: isDragging == true ? circleSize*1.1 : circleSize, height: isDragging == true ? circleSize*1.1 : circleSize)
                .position(x: self.posx*screenWidth, y: self.posy*screenHeight)
                .offset(dragAmount)
                .zIndex(isDragging == false ? 0 : 1)
                .gesture(
                    DragGesture(coordinateSpace: .global)
                        .onChanged {
                            self.isDragging = true
                            self.dragAmount = CGSize(width: $0.translation.width, height: $0.translation.height)
                        }
                        .onEnded {_ in
                            self.isDragging = false
                            update_pos()
                        }
                )
            Text(dancer.name == "" ? String(dancer.number) : dancer.name)
                .position(x: self.posx*screenWidth, y: self.posy*screenHeight)
                .offset(dragAmount)
                .zIndex(isDragging == false ? 0 : 1)
                .gesture(
                    DragGesture(coordinateSpace: .global)
                        .onChanged {
                            self.isDragging = true
                            self.dragAmount = CGSize(width: $0.translation.width, height: $0.translation.height)
                        }
                        .onEnded {_ in
                            self.isDragging = false
                            update_pos()
                        }
                )
        }
        .opacity(op == true ? 0 : 1)
    }
}

struct DancerIcon_Previews: PreviewProvider {
    static var previews: some View {
        let dancer = DancerModel(number: 1, position: [0.5, 0.5])
        let formation = FormationModel(name: "formation", dancers: [], tag: 0)
        DancerIcon(formation: formation, dancer: dancer, posx: 0.5, posy: 0.5, screenWidth: .constant(800.0), screenHeight: .constant(600.0), circleSize: 50, pageIndex: .constant(0), op: .constant(false))
    }
}
