//
//  VideoView.swift
//  iOSLiveKitTest
//
//  Created by Russell D'Sa on 1/9/21.
//

import Foundation
import SwiftUI
import LiveKit
import CoreMedia
import WebRTC

struct VideoViewComponent: UIViewRepresentable, Identifiable {
    var id: String
    var track: VideoTrack
    var renderingType: VideoRenderingType = .opengles
    var delegate: VideoViewDelegate?
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    func makeUIView(context: Context) -> UIView {
        let renderer = VideoView(frame: .zero)
        track.addRenderer(renderer)
        return renderer
    }
}
