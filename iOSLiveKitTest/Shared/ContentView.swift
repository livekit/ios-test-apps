//
//  ContentView.swift
//  Shared
//
//  Created by Russell D'Sa on 12/6/20.
//

import SwiftUI

struct ContentView: View {
    @State private var host: String = "localhost:7880"
    @State private var token: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MTU0MzI3NjUsImlzcyI6IkFQSUFnRnlYREpaSkxlODdyNG5kNUVqU1AiLCJqdGkiOiJtb2JpbGUiLCJuYmYiOjE2MTI4NDA3NjUsInZpZGVvIjp7InJvb21Kb2luIjp0cnVlfX0.2jKIdabWTCZLvAhhVtqZeCKA7clbLVCb35zozFWASKw"
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
            RoomView(host: host, token: token)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
