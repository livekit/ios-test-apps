//
//  RoomView.swift
//  iOSLiveKitTest
//
//  Created by Russell D'Sa on 1/3/21.
//

import SwiftUI
import LiveKit

struct RoomView: View {
    private var host: String
    private var httpPort: String
    private var rtcPort: String
    private var roomId: String
    private var roomName: String
    private var token: String
    
    @State private var room: Room?
    @State private var videoViews: [VideoViewComponent] = []
    
    init(host: String, httpPort: String, rtcPort: String, roomId: String, roomName: String, token: String) {
        self.host = host
        self.httpPort = httpPort
        self.rtcPort = rtcPort
        self.roomId = roomId
        self.roomName = roomName
        self.token = token
    }
    
    @ViewBuilder var body: some View {
        if room == nil {
            ZStack {
                ProgressView {
                    Text("Joining room...")
                }
            }.onAppear {
                connectToRoom()
            }
        } else {
            VStack {
                Text("Connected")
//                ForEach(videoViews) { videoView in
//                    videoView
//                }
            }
        }
    }
    
    func connectToRoom() {
        LiveKit.connect(options: ConnectOptions(token: token, block: { builder in
            builder.roomId = roomId
            builder.roomName = roomName
            builder.host = host
            builder.rtcPort = UInt32(rtcPort)!
            builder.httpPort = UInt32(httpPort)!
        }), delegate: self).then { room in
            self.room = room
        }
    }
}

extension RoomView: RoomDelegate {
    /* Room Delegate Methods */
    func didConnect(room: Room) {
        print("room delegate --- did connect")
        print("room view --- remote participants length: \(room.remoteParticipants.count)")
        room.remoteParticipants.forEach { $0.delegate = self }
    }
    
    func didDisconnect(room: Room, error: Error?) {
        print("room delegate --- did disconnect")
    }
    
    func didFailToConnect(room: Room, error: Error) {
        print("room delegate --- did fail to connect")
    }
    
    func isReconnecting(room: Room, error: Error) {
        print("room delegate --- is reconnecting")
    }
    
    func didReconnect(room: Room) {
        print("room delegate --- did reconnect")
    }
    
    func participantDidConnect(room: Room, participant: Participant) {
        print("room delegate --- participant did connect")
    }
    
    func participantDidDisconnect(room: Room, participant: Participant) {
        print("room delegate --- participant did disconnect")
    }
    
    func didStartRecording(room: Room) {
        print("room delegate --- did start recording")
    }
    
    func didStopRecording(room: Room) {
        print("room delegate --- did stop recording")
    }
    
    func dominantSpeakerDidChange(room: Room, participant: Participant) {
        print("room delegate --- dominant speaker change")
    }
}

extension RoomView: RemoteParticipantDelegate {
    func didPublish(audioTrack: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        print("remote participant delegate --- did publish audio")
    }
    
    func didUnpublish(audioTrack: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        print("remote participant delegate --- did unpublish audio")
    }
    
    func didPublish(videoTrack: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        print("remote participant delegate --- did publish video")
    }
    
    func didUnpublish(videoTrack: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        print("remote participant delegate --- did unpublish video")
    }
    
    func didPublish(dataTrack: RemoteDataTrackPublication, participant: RemoteParticipant) {
        print("remote participant delegate --- did publish data")
    }
    
    func didUnpublish(dataTrack: RemoteDataTrackPublication, participant: RemoteParticipant) {
        print("remote participant delegate --- did unpublish data")
    }
    
    func didEnable(audioTrack: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        print("remote participant delegate --- did enable audio")
    }
    
    func didDisable(audioTrack: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        print("remote participant delegate --- did disable audio")
    }
    
    func didEnable(videoTrack: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        print("remote participant delegate --- did enable video")
    }
    
    func didDisable(videoTrack: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        print("remote participant delegate --- did diable video")
    }
    
    func didSubscribe(audioTrack: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        print("remote participant delegate --- did subscribe audio")
    }
    
    func didFailToSubscribe(audioTrack: RemoteAudioTrackPublication, error: Error, participant: RemoteParticipant) {
        print("remote participant delegate --- did fail to subscribe audio")
    }
    
    func didUnsubscribe(audioTrack: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        print("remote participant delegate --- did unsubscribe audio")
    }
    
    func didSubscribe(videoTrack: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        print("remote participant delegate --- did subscribe video")
        
//        if let track = videoTrack.videoTrack {
//            let videoView = VideoViewComponent(id: videoTrack.trackSid, track: track)
//            videoViews.append(videoView)
//        }
    }
    
    func didFailToSubscribe(videoTrack: RemoteVideoTrackPublication, error: Error, participant: RemoteParticipant) {
        print("remote participant delegate --- did fail to subscribe video")
    }
    
    func didUnsubscribe(videoTrack: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        print("remote participant delegate --- did unsubscribe video")
    }
    
    func switchedOffVideo(track: RemoteVideoTrack, participant: RemoteParticipant) {
        print("remote participant delegate --- swiftched off video")
    }
    
    func switchedOnVideo(track: RemoteVideoTrack, participant: RemoteParticipant) {
        print("remote participant delegate --- switched on video")
    }
}
