//
//  RoomViewController.swift
//  LKUIKitTest
//
//  Created by Russell D'Sa on 1/16/21.
//

import UIKit
import AVFoundation
import LiveKit

class RoomViewController: UIViewController {
    
    var room: Room?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let host: String = "d7dbc8e3e2b7.ngrok.io"
        let token: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MTU5NjY0MDUsImlzcyI6IkFQSUFnRnlYREpaSkxlODdyNG5kNUVqU1AiLCJqdGkiOiJtb2JpbGUiLCJuYmYiOjE2MTMzNzQ0MDUsInZpZGVvIjp7InJvb21Kb2luIjp0cnVlfX0.3zMSgU5Xc69LyN4YfRgRFeVszyuDbftVAUkr_nOnJE8"
        
        room = LiveKit.connect(options: ConnectOptions.options(token: token, block: { builder in
            builder.host = host
        }), delegate: self)
    }
}

extension RoomViewController: RoomDelegate {
    /* Room Delegate Methods */
    func didConnect(room: Room) {
        print("room delegate --- did connect")
        print("room view --- remote participants length: \(room.remoteParticipants.count)")
        room.remoteParticipants.forEach { $0.delegate = self }
        
//        if let localParticipant = room.localParticipant {
//            localParticipant.delegate = self
            
//            if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
//                let videoTrack = LocalVideoTrack.track(source: device, enabled: true, name: "localVideo")
//                localParticipant.publishVideoTrack(track: videoTrack)
//            }
            
//            let audioTrack = LocalAudioTrack.track(name: "localAudio")
//            localParticipant.publishAudioTrack(track: audioTrack)
//        }
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

extension RoomViewController: LocalParticipantDelegate {
    func didPublishAudioTrack(track: LocalAudioTrack) {
        print("local participant delegate --- published local audio track")
    }
    
    func didFailToPublishAudioTrack(error: Error) {
        print("local participant delegate --- error publishing audio track: \(error)")
    }
    
    func didPublishVideoTrack(track: LocalVideoTrack) {
        print("local participant delegate --- published local video track")
    }
    
    func didFailToPublishVideoTrack(error: Error) {
        print("local participant delegate --- error publishing video track: \(error)")
    }
    
    func didPublishDataTrack(track: LocalDataTrack) {
        print("local participant delegate --- published local data track")
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
                let videoView = VideoView(frame: .zero)
                videoView.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(videoView)
                
                NSLayoutConstraint.activate([
                    videoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                    videoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                    videoView.topAnchor.constraint(equalTo: self.view.topAnchor),
                    videoView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
                ])
                
                track.addRenderer(videoView.renderer!)
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
