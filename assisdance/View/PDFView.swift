//
//  PDFView.swift
//  assisdance
//
//  Created by Cynthia Z France on 11/29/23.
//

import SwiftUI

struct PDFView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var pdf_exp: Bool = false
    @State var set: SetModel
    
    var body: some View {
        HStack {
            Spacer()
            Button("Cancel") {
                self.mode.wrappedValue.dismiss()
            }
            .padding()
        }
        HStack(alignment: .center) {
            Spacer()
            Text("Export Formations")
                .font(.title)
            Spacer()
        }
        HStack {
            Spacer()
            ZStack {
                GeometryReader { geometry in
                    Rectangle()
                        .fill(.white)
                        .scaledToFit()
                        .shadow(radius: 5, x: 0, y: 5)
                    ScrollView() {
                        
                        ForEach(set.formations) { formation in
                            ZStack {
                                FormationViewExport(set: $set, formation: formation, width: geometry.size.width)
                                //                                FormationView(set: $set, formation: formation, transition: .constant(false), formationLen: formation.formationDuration, transitionLen: formation.transitionDuration)
                                //                                    .aspectRatio(contentMode: .fit)
                                Rectangle()
                                    .fill(.white)
                                    .opacity(0.1)
                            }
                        }
                    }
                }
            }
            Spacer()
        }
        HStack(alignment: .center) {
            //MARK: user chooses to either export as pdf to Coredata, or as image to the photos app
            Spacer()
            Button("export to CoreData") {
                pdf_exp.toggle()
                exportPDFCoreData()
            }
            .buttonStyle(.borderedProminent)
            .alert(isPresented: $pdf_exp){
                self.mode.wrappedValue.dismiss()
                return Alert(title: Text("Export Successful"), message: Text("exported to CoreData"), dismissButton: .default(Text("ok"), action: {self.mode.wrappedValue.dismiss()}))
            }
            
            Spacer()
            
//            Button("send formations to email") {
//                image_exp.toggle()
//                saveImage()
//            }
//            .buttonStyle(.borderedProminent)
//            .alert(isPresented: $image_exp){
//                return Alert(title: Text("Export Successful"), message: Text("exported to photos"), dismissButton: .default(Text("ok"), action: {self.mode.wrappedValue.dismiss()}))
//            }
//            Spacer()
//            
//            Button("save formations as photo") {
//                image_exp.toggle()
//                saveImage()
//            }
//            .buttonStyle(.borderedProminent)
//            .alert(isPresented: $image_exp){
//                return Alert(title: Text("Export Successful"), message: Text("exported to photos"), dismissButton: .default(Text("ok"), action: {self.mode.wrappedValue.dismiss()}))
//            }
//            Spacer()
        }
        .padding(.bottom)
    }
    
//    func getView(formation: FormationModel, width: CGFloat) -> any View {
//        return VStack {
//            VStack {
//                Spacer()
//                Text(formation.name).font(.system(size: 24, weight: .bold, design: .default))
//                Spacer()
//            }
//            .padding(.top, 25)
//            SingleFormationView(set: $set, formation: formation, transition: .constant(false))
//                .frame(width: width, height: width*0.75)
//            HStack {
//                Spacer()
//                Text("Formation Length: \(formation.formationDuration) s")
//                .font(.system(size: 24, design: .default))
//                Spacer()
//            }
//            HStack {
//                Spacer()
//                Text("Formation Length: \(formation.transitionDuration) s")
//                .font(.system(size: 24, design: .default))
//                Spacer()
//            }
//        }
//    }
    
    @MainActor
    func exportPDFCoreData() {
        //MARK: create the path and renders the PDF
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let renderedUrl = documentDirectory.appending(path: "\(set.name)_formations.pdf")
        
        let width: CGFloat = 600
        var box = CGRect(x: 0, y: 0, width: width, height: width*1.3)
        
        guard let pdf = CGContext(renderedUrl as CFURL, mediaBox: &box, nil) else {
            return
        }
        
        var index = 0
        for f in set.formations {

            // Start a new PDF page
            pdf.beginPDFPage(nil)

            // Render necessary views
//            for num in 0..<viewsPerPage {
//            let renderer = ImageRenderer(content: FormationView(set: $set, formation: f, transition: .constant(false), formationLen: f.formationDuration, transitionLen: f.transitionDuration).aspectRatio(contentMode: .fit))
            let renderer = ImageRenderer(content: FormationViewExport(set: $set, formation: f, width: width))
            renderer.render { size, context in

                // Will place the view in the middle of pdf on x-axis
                let xTranslation = box.size.width / 2 - size.width / 2

                // Spacing between the views on y-axis
                let spacing: CGFloat = 20

                // TODO: - View starts printing from bottom, need to inverse Y position
                pdf.translateBy(
                    x: xTranslation - min(max(CGFloat(1) * xTranslation, 0), xTranslation),
                    y: size.width*1.3 + spacing //size.height + spacing
                )

                // Render the SwiftUI view data onto the page
                context(pdf)
                // End the page and close the file
            }
            index += 1

//            }
            pdf.endPDFPage()
        }
        pdf.closePDF()
//        return url
//        }
//        if let consumer = CGDataConsumer(url: renderedUrl as CFURL),
//           let pdfContext = CGContext(consumer: consumer, mediaBox: nil, nil) {
//            for f in set.formations {
//                let renderer = ImageRenderer(content: FormationView(set: $set, formation: f, transition: .constant(false), formationLen: f.formationDuration, transitionLen: f.transitionDuration)
//                    .aspectRatio(contentMode: .fit))
//                renderer.render { size, renderer in
//                    //MARK: creates and saves the pdf to the specified path
//                    let options: [CFString: Any] = [
//                        kCGPDFContextMediaBox: CGRect(origin: .zero, size: size)
//                    ]
//                    pdfContext.beginPDFPage(options as CFDictionary)
//                    renderer(pdfContext)
//                    pdfContext.endPDFPage()
//                    pdfContext.closePDF()
//                }
//            }
//            let renderer = ImageRenderer(content: getView())
//            
//            renderer.render { size, renderer in
//                //MARK: creates and saves the pdf to the specified path
//                let options: [CFString: Any] = [
//                    kCGPDFContextMediaBox: CGRect(origin: .zero, size: size)
//                ]
//                pdfContext.beginPDFPage(options as CFDictionary)
//                renderer(pdfContext)
//                pdfContext.endPDFPage()
//                pdfContext.closePDF()
//            }
//        }
        print("Saving PDF to \(renderedUrl.path())")
    }
}

//#Preview {
//    PDFView()
//}
