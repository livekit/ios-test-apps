//
//  RoomViewController.swift
//  LKUIKitTest
//
//  Created by Russell D'Sa on 1/16/21.
//

import UIKit
import LiveKit

class RoomViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let host: String = "bd94ac45495a.ngrok.io"
        let httpPort: String = "7880"
        let rtcPort: String = "7881"
        let roomId: String = "RM_qpK6GD7Vxp7w4XVw5oAaRM"
        let roomName: String = "i"
        let token: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MTEwMDU2MTAsImlzcyI6IkFQSUFnRnlYREpaSkxlODdyNG5kNUVqU1AiLCJqdGkiOiJpb3MiLCJuYmYiOjE2MTA5MTkyMTAsInZpZGVvIjp7InJvb20iOiJpIiwicm9vbV9qb2luIjp0cnVlfX0.XK-eIShKbYUhXA8o6esFpRaaHC3xuBfvZHPLKMtxPn4"
        
        LiveKit.connect(options: ConnectOptions(token: token, block: { builder in
            builder.roomId = roomId
            builder.roomName = roomName
            builder.host = host
            builder.rtcPort = UInt32(rtcPort)!
            builder.httpPort = UInt32(httpPort)!
        }), delegate: self)
    }
}

extension RoomViewController: RoomDelegate {
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

extension RoomViewController: RemoteParticipantDelegate {
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
        
        if let track = videoTrack.videoTrack {
            DispatchQueue.main.async {
                let videoView = VideoView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
                track.addRenderer(videoView)
                self.view.addSubview(videoView)
            }
        }
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
