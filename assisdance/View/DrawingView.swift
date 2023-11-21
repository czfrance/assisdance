//
//  DrawingView.swift
//  assisdance
//
//  Created by Cynthia Z France on 11/1/23.
//

import SwiftUI
import PencilKit

struct DrawingView: View {
    @Environment(\.undoManager) var undoManager
    @State var canvas = PKCanvasView()
    @State var button_enabled: Bool = false

    
    var body: some View {
        VStack(spacing: 10) {
//            Button("Clear") {
//                canvas.drawing = PKDrawing()
//            }
//            Button("Undo") {
//                undoManager?.undo()
//            }
//            Button("Redo") {
//                undoManager?.redo()
//            }
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
//                Rectangle()
//                    .fill(.red)
//                    .frame(width:200, height:200)
//                    .position(x: 100, y: 0)
                DrawView(canvas: $canvas, button_enabled: $button_enabled)
                    .border(.red, width: 5)
            }
        }
            .border(.blue, width: 4)
    }
}

struct DrawView: UIViewRepresentable {
    @Binding var canvas: PKCanvasView
    @Binding var button_enabled: Bool

    let ink = PKInkingTool(.pen, color: .black, width: 10)
    
    func makeUIView(context: Context) -> PKCanvasView {
        print("HIIII")
        canvas.drawingPolicy = .anyInput
        canvas.tool = ink
        canvas.backgroundColor = .clear
        canvas.isOpaque = false
        canvas.delegate = context.coordinator
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        print("updating")
    }
    
    func makeCoordinator() -> Coordinator {
      Coordinator(canvasView: $canvas, button_enabled: $button_enabled)
    }
    
}

class Coordinator: NSObject {
    var canvasView: Binding<PKCanvasView>
    @Binding var button_enabled: Bool

    init(canvasView: Binding<PKCanvasView>, button_enabled: Binding<Bool>) {
        self.canvasView = canvasView
        self._button_enabled = button_enabled
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

          var path = Path()
          let pathPoints = points.map { CGPoint(x: $0.location.x, y: $0.location.y) }
          path.addLines(pathPoints)
          
          for point in points {
              print(point.location)
          }
          print("-----done-----")
          
//          PathAnimatingView(path: path) {
//              Circle()
//                  .fill(Color.gray)
//          }
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
