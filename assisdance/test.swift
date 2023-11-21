//
//  test.swift
//  assisdance
//
//  Created by Cynthia Z France on 11/19/23.
//

import Foundation
import SwiftUI

class CircleView: UIView {
    var body: some View {
        Circle()
            .fill(Color.gray)
            .position(x: 100, y: 100)
            .frame(width: 30, height: 30)
    }
}

struct PathAnimationView: UIViewRepresentable {
    let path: Path
    let view: UIView
    
    func makeUIView(context: Context) -> UIView {
        let keyFrameAnimation = CAKeyframeAnimation(keyPath:"position")
        keyFrameAnimation.path = path.cgPath
        keyFrameAnimation.duration = 2.0
        keyFrameAnimation.isRemovedOnCompletion = false
        view.layer.add(keyFrameAnimation, forKey: "animation")
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        print("updating")
    }
}

//struct PathAnimatingView<Content>: UIViewRepresentable where Content: View {
//    let path: Path
//    let content: () -> Content
//    let view: UIView
//
//    func makeUIView(context: UIViewRepresentableContext<PathAnimatingView>) -> UIView {
//        view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        view.layer.cornerRadius = 50
//        view.clipsToBounds = true
//
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.borderWidth = 2.0
//
//        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
//            animation.duration = CFTimeInterval(3)
//            animation.repeatCount = 3
//            animation.path = path.cgPath
//            animation.isRemovedOnCompletion = false
//            animation.fillMode = .forwards
//            animation.timingFunction = CAMediaTimingFunction(name: .linear)
//
//        let sub = UIHostingController(rootView: content())
//        sub.view.translatesAutoresizingMaskIntoConstraints = false
//
//        view.addSubview(sub.view)
//        sub.view.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        sub.view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//
//        view.layer.add(animation, forKey: "someAnimationName")
//        return view
//    }
//
//    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PathAnimatingView>) {
//    }
//
//    typealias UIViewType = UIView
//}

struct TestAnimationByPath: View {
    var view = UIView()
    
    var body: some View {
        VStack {
            PathAnimationView(path: Circle().path(in:
                                                    CGRect(x: 100, y: 100, width: 50, height: 50)), view: view)
//            PathAnimatingView(path: Circle().path(in:
//                              CGRect(x: 100, y: 100, width: 50, height: 50))) {
//                Circle()
//                    .fill(Color.gray)
//                    .position(x: 100, y: 100)
//                    .frame(width: 30, height: 30)
//            }
        }
    }
    
    func animationTest() {
        let dancer = CALayer()
        dancer.frame = CGRect(x: 100, y: 100, width: 50, height: 50)
        dancer.contents = Circle().fill(Color.gray)
            .position(x: 100, y: 100)
            .frame(width: 30, height: 30)
        
        
    }
}

