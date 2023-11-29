//
//  SetView.swift
//  assisdance
//
//  Created by Cynthia Z France on 10/5/23.
//

import SwiftUI

struct SetView: View {
    
    @EnvironmentObject var formationBook: FormationBookViewModel
    @State var set: SetModel
    @State var pageIndex = 0
    private let dotAppearance = UIPageControl.appearance()
    @State var transition: Bool = false
    
    var body: some View {
        GeometryReader{ geometry in
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        Text(set.name).font(.system(size: 24, weight: .bold, design: .default))
                        Text("number of dancers: " + String(set.numDancers))
                    }
                    Spacer()
                }
                Spacer()
                
                ZStack {
                    ForEach(set.formations) { formation in
                        HStack() {
                            Spacer()
                            if formation == set.formations.first {
                                Button {} label: {
                                    Image(systemName: "arrow.left")
                                        .foregroundColor(.gray)
                                }
                            } else {
                                Button {
                                    decrementPage()
                                } label: {
                                    Image(systemName: "arrow.left")
                                }
                            }
                            Spacer()
                            FormationView(set: $set, formation: formation, pageIndex: $pageIndex, transition: $transition, formationLen: formation.formationDuration, transitionLen: formation.transitionDuration)
                                .aspectRatio(contentMode: .fit)
                            Spacer()
                            if formation == set.formations.last {
                                Button {} label: {
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(.gray)
                                }
                            } else {
                                Button {
                                    self.transition = true
                                    let duration = currFormation(currtag: pageIndex)!.transitionDuration
                                    print("duration: \(duration)")
                                    DispatchQueue.main.asyncAfter(deadline: .now() + duration + 0.1) {
                                        self.transition = false
                                        print("incrementing")
                                        incrementPage()
                                    }
                                } label: {
                                    Image(systemName: "arrow.right")
                                }
                            }
                            Spacer()
                        }
                        .tag(formation.tag)
                        .opacity(pageIndex == formation.tag ? 1 : 0)
                    }
                }
                .ignoresSafeArea()
                
                Spacer()
                Button("Add Formation") {
                    let lastFormation = set.formations.last!
                    var newDancers: [DancerModel] = []
                    for d in lastFormation.dancers {
                        newDancers.append(DancerModel(id: d.id, number: d.number, position: [d.position[0], d.position[1]]))
                    }
                    let newFormation = FormationModel(name: "formation \(set.formations.count + 1)", dancers: newDancers, tag: set.formations.count)
                    set.addFormation(newFormation)
                    formationBook.saveSets()
                    print(set)
                    for s in formationBook.sets {
                        print(s)
                    }
                    incrementPage()
                }
                .buttonStyle(.borderedProminent)
                Spacer()
                HStack {
                    Button("Save") {
                        formationBook.addSet(set)
                        formationBook.saveSets()
                        print(set)
                        for s in formationBook.sets {
                            print(s)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    Menu("Export") {
//                        Button("PDF", action: )
//                        Button("Video", action: )
//                        Button("Cancel", action: )
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
    
    func currFormation(currtag: Int) -> FormationModel? {
        for f in set.formations {
            if f.tag == currtag {
                return f
            }
        }
        return nil
    }
    
    func decrementPage() {
        if pageIndex > 0 {
            pageIndex -= 1
        }
    }
    
    func incrementPage() {
        if pageIndex < set.formations.count-1 {
            pageIndex += 1
        }
    }
    
    func goToPage(page: Int) {
        if (0 <= page) && (page < set.formations.count) {
            pageIndex = page
        }
    }
}


struct SetView_Previews_wrapper : View {
    func preview() -> SetModel {
        var curr_set = SetModel(name: "set", numDancers: 5)
        let dancer1 = DancerModel(number: 1, position: [25.0, 25.0])
        let dancer2 = DancerModel(number: 2, position: [50.0, 50.0])
        let formation1 = FormationModel(name: "formation 1", dancers: [dancer1, dancer2], tag: 0)
        let formation2 = FormationModel(name: "formation 2", dancers: [dancer1, dancer2], tag: 1)
        curr_set.addFormation(formation1)
        curr_set.addFormation(formation2)
        return curr_set
    }
    
    var body: some View {
        SetView(set: preview())
    }
}

struct SetView_Previews: PreviewProvider {
    static var previews: some View {
        SetView_Previews_wrapper()
//            .previewInterfaceOrientation(.landscapeLeft)
    }
}
