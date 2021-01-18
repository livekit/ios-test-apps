//
//  ContentView.swift
//  Shared
//
//  Created by Russell D'Sa on 12/6/20.
//

import SwiftUI

struct ContentView: View {
    @State private var host: String = "e7235595684e.ngrok.io"
    @State private var httpPort: String = "7880"
    @State private var rtcPort: String = "7881"
    @State private var roomId: String = "RM_HMET78YkDcnRvmXgo5nSYK"
    @State private var roomName: String = "d"
    @State private var token: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MTAzMjYzMjQsImlzcyI6IkFQSUFnRnlYREpaSkxlODdyNG5kNUVqU1AiLCJqdGkiOiJpb3MiLCJuYmYiOjE2MTAzMjU3MjQsInZpZGVvIjp7InJvb20iOiJkIiwicm9vbV9qb2luIjp0cnVlfX0.oiZJRajVBqsztFqwsUhvYOaJRPuzG7_NEQVxS_Hu_uc"
    @State private var showRoom: Bool = false
        
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Host")
                TextField("RTC Host", text: $host)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.bottom, 24)
            
            VStack(alignment: .leading) {
                Text("RTC Port")
                TextField("RTC Port", text: $rtcPort)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.bottom, 24)
            
            VStack(alignment: .leading) {
                Text("HTTP Port")
                TextField("HTTP Port", text: $httpPort)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            VStack(alignment: .leading) {
                Text("Room ID")
                TextField("R-XXXXXX", text: $roomId)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.bottom, 24)
            
            VStack(alignment: .leading) {
                Text("Room Name")
                TextField("", text: $roomName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.bottom, 24)
            
            VStack(alignment: .leading) {
                Text("Token")
                TextField("Token", text: $token)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.bottom, 24)
            
            Button(action: {
                showRoom = true
            }) {
                Text("Connect")
            }
            .padding(.top, 40)
        }
        .padding()
        .fullScreenCover(isPresented: $showRoom, content: {
            RoomView(host: host, httpPort: httpPort, rtcPort: rtcPort, roomId: roomId, roomName: roomName, token: token)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
