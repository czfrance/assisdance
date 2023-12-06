//
//  SetView.swift
//  assisdance
//
//  Created by Cynthia Z France on 10/5/23.
//

import SwiftUI

enum SheetView: Identifiable {
    var id: Self { self }
    case formations, video
}

struct SetView: View {
    
    @EnvironmentObject var formationBook: FormationBookViewModel
    @State var set: SetModel
    @State var pageIndex = 0
    private let dotAppearance = UIPageControl.appearance()
    @State var transition: Bool = false
//    @State var expPDF: Bool = false
    @State private var showSheet: SheetView? = nil
    @State private var showResults = false
    @State var result: [String: AnyObject] = [:]
    @State private var failAlert = false
    
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
                            FormationView(set: $set, formation: formation, transition: $transition, formationLen: formation.formationDuration, transitionLen: formation.transitionDuration)
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
                    Button("Analyze") {
                        let data = set.getJSON()
                        if data != nil {
                            let temp = makePostRequest(body: data!, endpoint: "calc")
                            if temp != nil {
                                result = makePostRequest(body: data!, endpoint: "calc")!
//                                Task { @MainActor in
//                                    try await Task.sleep(for: .seconds(10))
//                                    result = [
//                                        "set_results": [
//                                          "dancers": 5,
//                                          "total_len": 25,
//                                          "dance_time": 20,
//                                          "transition_time": 5.000000000000001,
//                                          "total_distance": 572.5538705153201,
//                                          "avg_transition_speed": 22.9021548206128,
//                                          "avg_formation_w": 41.431475029036,
//                                          "avg_formation_h": 29.81029810298103
//                                        ],
//                                        "dancer_results": [
//                                          "20AA3439-1FB8-4D8B-A069-1966B75DEF75": [
//                                            "name": "",
//                                            "number": 1,
//                                            "distance": 0,
//                                            "lTime": 15,
//                                            "rTime": 0,
//                                            "cTime": 5,
//                                            "fTime": 5,
//                                            "bTime": 10,
//                                            "path": []
//                                          ],
//                                          "746102F1-B426-487C-B99E-43BFD42329D0": [
//                                            "name": "",
//                                            "number": 2,
//                                            "distance": 0,
//                                            "lTime": 5,
//                                            "rTime": 5,
//                                            "cTime": 10,
//                                            "fTime": 0,
//                                            "bTime": 10,
//                                            "path": []
//                                          ],
//                                          "9F530CA0-BC4C-43E6-A703-ABFEEFC01F67": [
//                                            "name": "",
//                                            "number": 3,
//                                            "distance": 0,
//                                            "lTime": 0,
//                                            "rTime": 0,
//                                            "cTime": 20,
//                                            "fTime": 0,
//                                            "bTime": 0,
//                                            "path": []
//                                          ],
//                                          "79680441-C6E8-4C25-993D-30F3120C5402": [
//                                            "name": "",
//                                            "number": 4,
//                                            "distance": 0,
//                                            "lTime": 0,
//                                            "rTime": 15,
//                                            "cTime": 5,
//                                            "fTime": 10,
//                                            "bTime": 5,
//                                            "path": []
//                                          ],
//                                          "99E691AD-32A8-47AD-A33C-EC3D921A427C": [
//                                            "name": "",
//                                            "number": 5,
//                                            "distance": 0,
//                                            "lTime": 5,
//                                            "rTime": 15,
//                                            "cTime": 0,
//                                            "fTime": 0,
//                                            "bTime": 20,
//                                            "path": []
//                                          ]
//                                        ],
//                                        "formation_results": [
//                                          "0": [
//                                            "formation_time": 5,
//                                            "width": 40,
//                                            "height": 0
//                                          ],
//                                          "1": [
//                                            "formation_time": 5,
//                                            "width": 60.09291521486644,
//                                            "height": 11.924119241192411
//                                          ],
//                                          "2": [
//                                            "formation_time": 5,
//                                            "width": 44.8780487804878,
//                                            "height": 41.65698799845141
//                                          ],
//                                          "3": [
//                                            "formation_time": 5,
//                                            "width": 20.75493612078978,
//                                            "height": 65.66008517228029
//                                          ]
//                                        ],
//                                        "transition_results": [
//                                          "0": [
//                                            "transition_time": 1,
//                                            "total_distance": 137.54365989393364,
//                                            "avg_speed": 27.508731978786727
//                                          ],
//                                          "1": [
//                                            "transition_time": 1,
//                                            "total_distance": 249.8144927428778,
//                                            "avg_speed": 49.96289854857556
//                                          ],
//                                          "2": [
//                                            "transition_time": 2.000000000000001,
//                                            "total_distance": 185.1957178785087,
//                                            "avg_speed": 37.03914357570174
//                                          ],
//                                          "3": [
//                                            "transition_time": 1,
//                                            "total_distance": 0,
//                                            "avg_speed": 0
//                                          ]
//                                        ],
//                                        "general_results": [
//                                          [
//                                            "total_len": 6,
//                                            "dancers": [
//                                              "20AA3439-1FB8-4D8B-A069-1966B75DEF75": [
//                                                "number": 1,
//                                                "name": "",
//                                                "distance": 18.257991180701257,
//                                                "speed": 18.257991180701257,
//                                                "center": false,
//                                                "left": true,
//                                                "front": false,
//                                                "path": [
//                                                  [
//                                                    0.1,
//                                                    0.5
//                                                  ],
//                                                  [
//                                                    0.18304297328687574,
//                                                    0.33739837398373984
//                                                  ]
//                                                ]
//                                              ],
//                                              "746102F1-B426-487C-B99E-43BFD42329D0": [
//                                                "number": 2,
//                                                "name": "",
//                                                "distance": 19.305583159137363,
//                                                "speed": 19.305583159137363,
//                                                "center": true,
//                                                "left": false,
//                                                "front": false,
//                                                "path": [
//                                                  [
//                                                    0.2,
//                                                    0.5
//                                                  ],
//                                                  [
//                                                    0.2847851335656214,
//                                                    0.3265582655826558
//                                                  ]
//                                                ]
//                                              ],
//                                              "9F530CA0-BC4C-43E6-A703-ABFEEFC01F67": [
//                                                "number": 3,
//                                                "name": "",
//                                                "distance": 29.056774092006524,
//                                                "speed": 29.056774092006524,
//                                                "center": true,
//                                                "left": false,
//                                                "front": false,
//                                                "path": [
//                                                  [
//                                                    0.30000000000000004,
//                                                    0.5
//                                                  ],
//                                                  [
//                                                    0.45911730545876894,
//                                                    0.25687185443283
//                                                  ]
//                                                ]
//                                              ],
//                                              "79680441-C6E8-4C25-993D-30F3120C5402": [
//                                                "number": 4,
//                                                "name": "",
//                                                "distance": 37.196581404301675,
//                                                "speed": 37.196581404301675,
//                                                "center": false,
//                                                "left": false,
//                                                "front": false,
//                                                "path": [
//                                                  [
//                                                    0.4,
//                                                    0.5
//                                                  ],
//                                                  [
//                                                    0.6427409988385598,
//                                                    0.21815718157181574
//                                                  ]
//                                                ]
//                                              ],
//                                              "99E691AD-32A8-47AD-A33C-EC3D921A427C": [
//                                                "number": 5,
//                                                "name": "",
//                                                "distance": 33.72673005778683,
//                                                "speed": 33.72673005778683,
//                                                "center": false,
//                                                "left": false,
//                                                "front": false,
//                                                "path": [
//                                                  [
//                                                    0.5,
//                                                    0.5
//                                                  ],
//                                                  [
//                                                    0.7839721254355401,
//                                                    0.31804103755323265
//                                                  ]
//                                                ]
//                                              ]
//                                            ],
//                                            "formation_time": 5,
//                                            "width": 40,
//                                            "height": 0,
//                                            "transition_time": 1,
//                                            "total_distance": 137.54365989393364,
//                                            "avg_speed": 27.508731978786727
//                                          ],
//                                          [
//                                            "total_len": 6,
//                                            "dancers": [
//                                              "20AA3439-1FB8-4D8B-A069-1966B75DEF75": [
//                                                "number": 1,
//                                                "name": "",
//                                                "distance": 37.71160891154512,
//                                                "speed": 37.71160891154512,
//                                                "center": false,
//                                                "left": true,
//                                                "front": false,
//                                                "path": [
//                                                  [
//                                                    0.18304297328687574,
//                                                    0.33739837398373984
//                                                  ],
//                                                  [
//                                                    0.12380952380952381,
//                                                    0.7098335269066977
//                                                  ]
//                                                ]
//                                              ],
//                                              "746102F1-B426-487C-B99E-43BFD42329D0": [
//                                                "number": 2,
//                                                "name": "",
//                                                "distance": 43.33630367386515,
//                                                "speed": 43.33630367386515,
//                                                "center": false,
//                                                "left": true,
//                                                "front": false,
//                                                "path": [
//                                                  [
//                                                    0.2847851335656214,
//                                                    0.3265582655826558
//                                                  ],
//                                                  [
//                                                    0.2632984901277584,
//                                                    0.759388308168796
//                                                  ]
//                                                ]
//                                              ],
//                                              "9F530CA0-BC4C-43E6-A703-ABFEEFC01F67": [
//                                                "number": 3,
//                                                "name": "",
//                                                "distance": 44.82467431999879,
//                                                "speed": 44.82467431999879,
//                                                "center": true,
//                                                "left": false,
//                                                "front": false,
//                                                "path": [
//                                                  [
//                                                    0.45911730545876894,
//                                                    0.25687185443283
//                                                  ],
//                                                  [
//                                                    0.3342624854819977,
//                                                    0.6873790166473093
//                                                  ]
//                                                ]
//                                              ],
//                                              "79680441-C6E8-4C25-993D-30F3120C5402": [
//                                                "number": 4,
//                                                "name": "",
//                                                "distance": 46.215607283211064,
//                                                "speed": 46.215607283211064,
//                                                "center": false,
//                                                "left": false,
//                                                "front": true,
//                                                "path": [
//                                                  [
//                                                    0.6427409988385598,
//                                                    0.21815718157181574
//                                                  ],
//                                                  [
//                                                    0.47665505226480837,
//                                                    0.6494386372435152
//                                                  ]
//                                                ]
//                                              ],
//                                              "99E691AD-32A8-47AD-A33C-EC3D921A427C": [
//                                                "number": 5,
//                                                "name": "",
//                                                "distance": 77.72629855425768,
//                                                "speed": 77.72629855425768,
//                                                "center": false,
//                                                "left": false,
//                                                "front": false,
//                                                "path": [
//                                                  [
//                                                    0.7839721254355401,
//                                                    0.31804103755323265
//                                                  ],
//                                                  [
//                                                    0.5725900116144018,
//                                                    1.0660085172280294
//                                                  ]
//                                                ]
//                                              ]
//                                            ],
//                                            "formation_time": 5,
//                                            "width": 60.09291521486644,
//                                            "height": 11.924119241192411,
//                                            "transition_time": 1,
//                                            "total_distance": 249.8144927428778,
//                                            "avg_speed": 49.96289854857556
//                                          ],
//                                          [
//                                            "total_len": 7.000000000000001,
//                                            "dancers": [
//                                              "20AA3439-1FB8-4D8B-A069-1966B75DEF75": [
//                                                "number": 1,
//                                                "name": "",
//                                                "distance": 61.03080848702087,
//                                                "speed": 30.51540424351042,
//                                                "center": false,
//                                                "left": true,
//                                                "front": true,
//                                                "path": [
//                                                  [
//                                                    0.12380952380952381,
//                                                    0.7098335269066977
//                                                  ],
//                                                  [
//                                                    0.7329849012775842,
//                                                    0.6726674409601239
//                                                  ]
//                                                ]
//                                              ],
//                                              "746102F1-B426-487C-B99E-43BFD42329D0": [
//                                                "number": 2,
//                                                "name": "",
//                                                "distance": 51.68408826945412,
//                                                "speed": 25.84204413472705,
//                                                "center": true,
//                                                "left": false,
//                                                "front": false,
//                                                "path": [
//                                                  [
//                                                    0.2632984901277584,
//                                                    0.759388308168796
//                                                  ],
//                                                  [
//                                                    0.7801393728222996,
//                                                    0.759388308168796
//                                                  ]
//                                                ]
//                                              ],
//                                              "9F530CA0-BC4C-43E6-A703-ABFEEFC01F67": [
//                                                "number": 3,
//                                                "name": "",
//                                                "distance": 34.3586614483902,
//                                                "speed": 17.179330724195093,
//                                                "center": true,
//                                                "left": false,
//                                                "front": false,
//                                                "path": [
//                                                  [
//                                                    0.3342624854819977,
//                                                    0.6873790166473093
//                                                  ],
//                                                  [
//                                                    0.6472706155632986,
//                                                    0.5456833139759969
//                                                  ]
//                                                ]
//                                              ],
//                                              "79680441-C6E8-4C25-993D-30F3120C5402": [
//                                                "number": 4,
//                                                "name": "",
//                                                "distance": 38.122159673643516,
//                                                "speed": 19.06107983682175,
//                                                "center": false,
//                                                "left": false,
//                                                "front": true,
//                                                "path": [
//                                                  [
//                                                    0.47665505226480837,
//                                                    0.6494386372435152
//                                                  ],
//                                                  [
//                                                    0.7728222996515679,
//                                                    0.40940766550522645
//                                                  ]
//                                                ]
//                                              ],
//                                              "99E691AD-32A8-47AD-A33C-EC3D921A427C": [
//                                                "number": 5,
//                                                "name": "",
//                                                "distance": 0,
//                                                "speed": 0,
//                                                "center": false,
//                                                "left": false,
//                                                "front": false,
//                                                "path": [
//                                                  [
//                                                    0.5725900116144018,
//                                                    1.0660085172280294
//                                                  ],
//                                                  [
//                                                    0.5725900116144018,
//                                                    1.0660085172280294
//                                                  ]
//                                                ]
//                                              ]
//                                            ],
//                                            "formation_time": 5,
//                                            "width": 44.8780487804878,
//                                            "height": 41.65698799845141,
//                                            "transition_time": 2.000000000000001,
//                                            "total_distance": 185.1957178785087,
//                                            "avg_speed": 37.03914357570174
//                                          ],
//                                          [
//                                            "total_len": 6,
//                                            "dancers": [
//                                              "20AA3439-1FB8-4D8B-A069-1966B75DEF75": [
//                                                "number": 1,
//                                                "name": "",
//                                                "distance": 0,
//                                                "speed": 0,
//                                                "center": true,
//                                                "left": false,
//                                                "front": false,
//                                                "path": [
//                                                  [
//                                                    0.7329849012775842,
//                                                    0.6726674409601239
//                                                  ]
//                                                ]
//                                              ],
//                                              "746102F1-B426-487C-B99E-43BFD42329D0": [
//                                                "number": 2,
//                                                "name": "",
//                                                "distance": 0,
//                                                "speed": 0,
//                                                "center": false,
//                                                "left": false,
//                                                "front": false,
//                                                "path": [
//                                                  [
//                                                    0.7801393728222996,
//                                                    0.759388308168796
//                                                  ]
//                                                ]
//                                              ],
//                                              "9F530CA0-BC4C-43E6-A703-ABFEEFC01F67": [
//                                                "number": 3,
//                                                "name": "",
//                                                "distance": 0,
//                                                "speed": 0,
//                                                "center": true,
//                                                "left": false,
//                                                "front": false,
//                                                "path": [
//                                                  [
//                                                    0.6472706155632986,
//                                                    0.5456833139759969
//                                                  ]
//                                                ]
//                                              ],
//                                              "79680441-C6E8-4C25-993D-30F3120C5402": [
//                                                "number": 4,
//                                                "name": "",
//                                                "distance": 0,
//                                                "speed": 0,
//                                                "center": true,
//                                                "left": false,
//                                                "front": false,
//                                                "path": [
//                                                  [
//                                                    0.7728222996515679,
//                                                    0.40940766550522645
//                                                  ]
//                                                ]
//                                              ],
//                                              "99E691AD-32A8-47AD-A33C-EC3D921A427C": [
//                                                "number": 5,
//                                                "name": "",
//                                                "distance": 0,
//                                                "speed": 0,
//                                                "center": false,
//                                                "left": true,
//                                                "front": false,
//                                                "path": [
//                                                  [
//                                                    0.5725900116144018,
//                                                    1.0660085172280294
//                                                  ]
//                                                ]
//                                              ]
//                                            ],
//                                            "formation_time": 5,
//                                            "width": 20.75493612078978,
//                                            "height": 65.66008517228029,
//                                            "transition_time": 1,
//                                            "total_distance": 0,
//                                            "avg_speed": 0
//                                          ]
//                                        ]
//                                      ]
//                                    showResults.toggle()
//                                }
//                                showResults.toggle()
                            }
                            else {
                                failAlert.toggle()
                            }
                        }
                        else {
                            print("no data")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .sheet(isPresented: $showResults) {
                        ResultsView(analysisResults: result)
                    }
                    .alert("Analysis failed. Please try again.", isPresented: $failAlert) {
                        Button("OK", role: .cancel) {}
                    }
                    
                    Menu("Export") {
                        Button("Formations") {
                            showSheet = .formations
                        }
                        Button("Video") {
                            showSheet = .video
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .sheet(item: $showSheet) { mode in
            content(for: mode)
        }
    }
    
    @ViewBuilder
    func content(for mode: SheetView) -> some View {
        switch mode {
        case .formations:
            PDFView(set: set)
        case .video:
            PDFView(set: set)
//            EditAsset(showSheet: $showSheet)
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
