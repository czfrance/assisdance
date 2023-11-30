//
//  DrawingView.swift
//  assisdance
//
//  Created by Cynthia Z France on 11/1/23.
//

import SwiftUI
import PencilKit

struct DrawingView: View {
    @State var canvas = PKCanvasView()
    @State var button_enabled: Bool = false
    @State var pathDrawn: [[CGFloat]] = []

    
    var body: some View {
        VStack(spacing: 10) {
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
            
            ZStack() {
                DrawView(canvas: $canvas, button_enabled: $button_enabled, pathDrawn: $pathDrawn, screenSize: .constant(.zero))
                    .border(.red, width: 5)
            }
        }
            .border(.blue, width: 4)
    }
}

struct DrawView: UIViewRepresentable {
    @Binding var canvas: PKCanvasView
    @Binding var button_enabled: Bool
    @Binding var pathDrawn: [[CGFloat]]
    @Binding var screenSize: CGSize

    let ink = PKInkingTool(.pen, color: .black, width: 10)
    
    func makeUIView(context: Context) -> PKCanvasView {
        print("HIIII")
        canvas.drawingPolicy = .anyInput
        canvas.tool = ink
        canvas.backgroundColor = .clear
        canvas.isOpaque = false
        canvas.delegate = context.coordinator
        screenSize = UIScreen.main.bounds.size
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        print("updating")
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(canvasView: $canvas, button_enabled: $button_enabled, pathDrawn: $pathDrawn)
    }
    
}

class Coordinator: NSObject {
    var canvasView: Binding<PKCanvasView>
    @Binding var button_enabled: Bool
    @Binding var pathDrawn: [[CGFloat]]

    init(canvasView: Binding<PKCanvasView>, button_enabled: Binding<Bool>, pathDrawn: Binding<[[CGFloat]]>) {
        self.canvasView = canvasView
        self._button_enabled = button_enabled
        self._pathDrawn = pathDrawn
    }
}

extension Coordinator: PKCanvasViewDelegate {
    //when the drawing changes
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
      
        let strokes = canvasView.drawing.strokes
        print(strokes.count)
        //get the points of the line drawn
        for stroke in strokes {
            let points = stroke.path.interpolatedPoints(by: .distance(3))
            let pathPoints = points.map { [$0.location.x / canvasView.bounds.width, $0.location.y / canvasView.bounds.height] }
            
            pathDrawn = pathPoints
            print("-----done-----")

        }
      
        //only allow user to draw one line
        if (strokes.count > 0) {
            print("no more drawing")
            canvasView.drawingGestureRecognizer.isEnabled = false
            button_enabled = true
        }
        else {
            print("drawing allowed")
            canvasView.drawingGestureRecognizer.isEnabled = true
            button_enabled = false
        }
    }
}

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView()
    }
}
