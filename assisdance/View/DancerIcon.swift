//
//  DancerIcon.swift
//  assisdance
//
//  Created by Cynthia Z France on 11/2/23.
//

import SwiftUI
var circleSize: CGFloat = 50
var outlineSize: CGFloat = 65

struct DancerIcon: Shape {
    
    @State var posx: CGFloat
    @State var posy: CGFloat
    @State var isDragging = false
    
    init(posx: CGFloat, posy: CGFloat) {
        self.posx = posx
        self.posy = posy
    }
    
    func path(in rect: CGRect) -> Path {
        return Path()
    }
    
    @State var dragAmount = CGSize.zero
    
    func update_pos() {
        posx += self.dragAmount.width
        posy += self.dragAmount.height
        _ = self.position(x: posx, y: posy)
        self.dragAmount = CGSize.zero
        print("(x: \(posx), y: \(posy)")
    }
    
    var body: some View {
        Circle()
            .fill(Color.gray)
            .frame(width: isDragging == true ? outlineSize*1.1 : outlineSize, height: isDragging == true ? outlineSize*1.1 : outlineSize)
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
        
    }
}

struct DancerIcon_Previews: PreviewProvider {
    static var previews: some View {
        DancerIcon(posx: 100.0, posy: 100.0)
    }
}
