//
//  DrawPathView.swift
//  assisdance
//
//  Created by Cynthia Z France on 11/20/23.
//

import SwiftUI
import PencilKit

struct DrawPathView: View {
    @EnvironmentObject var formationBook: FormationBookViewModel
    @State var formation1: FormationModel
    @State var formation2: FormationModel?
    @State var selectedDancer: UUID
    @State var canvas = PKCanvasView()
    @State var button_enabled: Bool = false
    @State var pathDrawn: [[CGFloat]] = []
    @Environment(\.presentationMode) var presentationMode
    @State var size: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            Color(red: 242/255, green: 242/255, blue: 242/255)
            VStack(spacing: 10) {
                HStack {
                    Spacer()
                    Text("Transition for Dancer \(formation1.getDancer(dId: selectedDancer)!.name == "" ? String(formation1.getDancer(dId: selectedDancer)!.number) : formation1.getDancer(dId: selectedDancer)!.name) from \(formation1.name) to \(formation2 != nil ? formation2!.name : "next formation")").font(.system(size: 24, weight: .bold, design: .default))
                    Spacer()
                }
                .padding(.top, 25)
                GeometryReader { geo in
                    ZStack {
                        SingleFormationView(formation: formation1, pageIndex: .constant(0), transition: .constant(false))
                        if formation2 != nil {
                            SingleFormationView(formation: formation2!, pageIndex: .constant(0), transition: .constant(false))
                                .opacity(0.25)
                        }
                        DrawView(canvas: $canvas, button_enabled: $button_enabled, pathDrawn: $pathDrawn, screenSize: $size)
                            .border(.red, width: 5)
                    }
                }
                Button(
                    action: {
                        print("clear")
                        canvas.drawing = PKDrawing()
                    },
                    label: {
                        Text("Clear Path")
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .frame(maxWidth: .infinity, maxHeight: 60)
                            .foregroundColor(Color.white)
                            .background(button_enabled ? Color.red : Color.gray)
                            .cornerRadius(10)
                    }
                )
                .disabled(!button_enabled)
                Button(
                    action: {
                        print("confirm")
                        formation1.updateDancerPath(dId: selectedDancer, path: pathDrawn)
                        presentationMode.wrappedValue.dismiss()
                    },
                    label: {
                        Text("Confirm Path")
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .frame(maxWidth: .infinity, maxHeight: 60)
                            .foregroundColor(Color.white)
                            .background(button_enabled ? Color.mint : Color.gray)
                            .cornerRadius(10)
                    }
                )
                .disabled(!button_enabled)
            }
        }
        .cornerRadius(20)
        .scaledToFit()
        .shadow(radius: 5, x: 0, y: 5)
    }
}

struct DrawPathView_Previews: PreviewProvider {
    static var previews: some View {
        let dancer1 = DancerModel(number: 1, position: [0.5, 0.5])
        let dancer2 = DancerModel(number: 2, position: [0.75, 0.75])
        let formation = FormationModel(name: "Formation 1", dancers: [dancer1, dancer2], tag: 0)
        let dancer3 = DancerModel(number: 1, position: [0.25, 0.25])
        let dancer4 = DancerModel(number: 2, position: [0.6, 0.6])
        let formation2 = FormationModel(name: "Formation 2", dancers: [dancer3, dancer4], tag: 1)
        DrawPathView(formation1: formation, formation2: formation2, selectedDancer: dancer1.id)
    }
}
