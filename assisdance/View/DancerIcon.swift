//
//  DancerIcon.swift
//  assisdance
//
//  Created by Cynthia Z France on 11/2/23.
//

import SwiftUI
//var circleSize: CGFloat = 50
//var outlineSize: CGFloat = circleSize*1.3

struct DancerIcon: Shape {
    @EnvironmentObject var formationBook: FormationBookViewModel
    @State var formation: FormationModel
    @State var dancer: DancerModel
    @State var posx: CGFloat
    @State var posy: CGFloat
    @State var isDragging = false
    @State var move = false
    var circleSize: CGFloat
    
//    init(dId: UUID, posx: CGFloat, posy: CGFloat) {
//        self.posx = posx
//        self.posy = posy
//    }
    
    func path(in rect: CGRect) -> Path {
        return Path()
    }
    
    @State var dragAmount = CGSize.zero
    
    func update_pos() {
        posx += self.dragAmount.width
        posy += self.dragAmount.height
        _ = self.position(x: posx, y: posy)
        self.dragAmount = CGSize.zero
        print("(x: \(posx), y: \(posy))")
        dancer.updatePosition(x: posx, y: posy)
        print(formation)
        formation.updateDancer(dId: dancer.id, x: posx, y: posy)
        print(formation)
    }
    
    var body: some View {
        Circle()
            .fill(Color.gray)
            .frame(width: isDragging == true ? circleSize*1.3*1.1 : circleSize*1.3, height: isDragging == true ? circleSize*1.3*1.1 : circleSize*1.3)
            .position(x: self.posx, y: self.posy)
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
//            .onTapGesture{
//                posx += 300
//                posy += 300
//                move = true
//                _ = self.position(x: posx, y: posy)
//            }
        Circle()
            .fill(Color.mint)
            .frame(width: isDragging == true ? circleSize*1.1 : circleSize, height: isDragging == true ? circleSize*1.1 : circleSize)
            .position(x: self.posx, y: self.posy)
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
            .position(x: self.posx, y: self.posy)
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
}

struct DancerIcon_Previews: PreviewProvider {
    static var previews: some View {
        let dancer = DancerModel(number: 1, position: [50.0, 50.0])
        let formation = FormationModel(name: "formation", dancers: [], tag: 0)
        DancerIcon(formation: formation, dancer: dancer, posx: 100.0, posy: 100.0, circleSize: 50)
    }
}
