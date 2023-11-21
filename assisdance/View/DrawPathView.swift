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
    @State var formation2: FormationModel
    @Environment(\.undoManager) var undoManager
    @State var canvas = PKCanvasView()
    @State var button_enabled: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            Color(red: 242/255, green: 242/255, blue: 242/255)
            VStack(spacing: 10) {
                HStack {
                    Spacer()
                    Text(formation1.name).font(.system(size: 24, weight: .bold, design: .default))
                    Spacer()
                }
                .padding(.top, 25)
                ZStack {
                    SingleFormationView(formation: formation1)
                    SingleFormationView(formation: formation2)
                        .opacity(0.25)
                    DrawView(canvas: $canvas, button_enabled: $button_enabled)
                        .border(.red, width: 5)
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
                    action: {print("confirm")},
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
        let dancer1 = DancerModel(number: 1, position: [25.0, 25.0])
        let dancer2 = DancerModel(number: 2, position: [50.0, 50.0])
        let formation = FormationModel(name: "Formation 1", dancers: [dancer1, dancer2], tag: 0)
        let dancer3 = DancerModel(number: 1, position: [200.0, 200.0])
        let dancer4 = DancerModel(number: 2, position: [300.0, 300.0])
        let formation2 = FormationModel(name: "Formation 2", dancers: [dancer3, dancer4], tag: 1)
        DrawPathView(formation1: formation, formation2: formation2)
    }
}
