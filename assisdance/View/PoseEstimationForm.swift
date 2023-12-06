//
//  PoseEstimationForm.swift
//  assisdance
//
//  Created by Cynthia Z France on 12/5/23.
//

import SwiftUI

let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)

struct PoseEstimationForm: View {
    @State var ogPath: String = ""
    @State var ogStart: String = ""
    @State var userPath: String = ""
    @State var userStart: String = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var waitAlert = false
    @State private var failAlert = false
     
    var body: some View {
        VStack {
            Text("Analyze Your Dancing!")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.bottom, 75)
             
            VStack(alignment: .leading) {
                Text("Original Choreography")
                    .font(.headline)
                    .padding(.bottom, 10)
                TextField("path to original choreography", text: $ogPath)
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .shadow(radius: 5)
                    .frame(maxWidth: 600)
            }
             
            VStack(alignment: .leading) {
                Text("Orignal Choreography Start Timestamp")
                    .font(.headline)
                    .padding(.bottom, 10)
                TextField("Timestamp (s.ms)", text: $ogStart)
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .shadow(radius: 5)
                    .frame(maxWidth: 600)
            }
            
            VStack(alignment: .leading) {
                Text("Your Dancing")
                    .font(.headline)
                    .padding(.bottom, 10)
                TextField("path to original choreography", text: $userPath)
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .shadow(radius: 5)
                    .frame(maxWidth: 600)
            }
             
            VStack(alignment: .leading) {
                Text("Your Start Timestamp")
                    .font(.headline)
                    .padding(.bottom, 10)
                TextField("Timestamp (s.ms)", text: $userStart)
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .shadow(radius: 5)
                    .frame(maxWidth: 600)
            }
            .padding(.bottom, 30)
             
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Maybe Later")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(15.0)
                        .shadow(radius: 5)
                        .border(Color.red, width: 4)
                }
                .padding(.trailing, 10)
                
                Button(action: {
                    let data = [
                        "choreo_vid": ogPath,
                        "choreo_timestamp": ogStart,
                        "user_vid": userPath,
                        "user_timestamp": userStart
                    ]
                    let encoder = JSONEncoder()
                    if let jsonData = try? encoder.encode(data) {
                        let json = String(data: jsonData, encoding: String.Encoding.utf8)
                        makePostRequest(body: json!, endpoint: "pose")
                        waitAlert.toggle()
                    }
                    else {
                        failAlert.toggle()
                    }
                }) {
                    Text("Get Results")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color.mint.opacity(0.8))
                        .cornerRadius(15.0)
                        .shadow(radius: 5)
                        .border(Color.mint, width: 4)
                }
                .alert("Analyzing...Please wait for result!", isPresented: $waitAlert) {
                    Button("OK", role: .cancel) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .alert("Request failed. Please try again.", isPresented: $failAlert) {
                    Button("OK", role: .cancel) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    PoseEstimationForm()
}
