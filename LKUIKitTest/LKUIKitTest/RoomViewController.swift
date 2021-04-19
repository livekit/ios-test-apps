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
    var remoteVideo: VideoView?
    var localVideo: VideoView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let url: String = "ws://192.168.93.78:7880"
        let token: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MjA4ODMyMzUsImlzcyI6IkFQSU1teGlMOHJxdUt6dFpFb1pKVjlGYiIsImp0aSI6ImlvcyIsIm5iZiI6MTYxODI5MTIzNSwidmlkZW8iOnsicm9vbSI6Im15cm9vbSIsInJvb21Kb2luIjp0cnVlfX0.n1btpTuGp-vZAjkgMCoSkS3MlpJ42ZxzxcbQ_8R4j0g"
        
        room = LiveKit.connect(options: ConnectOptions(url: url, token: token), delegate: self)
    }
}

extension RoomViewController: RoomDelegate {
    /* Room Delegate Methods */
    func didConnect(room: Room) {
        if let localParticipant = room.localParticipant {
            do {
                let videoTrack = try LocalVideoTrack.createTrack(name: "localVideo")
                localParticipant.publishVideoTrack(track: videoTrack)
            } catch {
                print("\(error)")
            }

//            let audioTrack = LocalAudioTrack.track(name: "localAudio")
//            localParticipant.publishAudioTrack(track: audioTrack)
        }
    }
    
    func didDisconnect(room: Room, error: Error?) {
        print("room delegate --- did disconnect")
    }
    
    func didFailToConnect(room: Room, error: Error) {
        print("room delegate --- did fail to connect")
    }
    
    func didSubscribe(track: Track, publication: RemoteTrackPublication, participant: RemoteParticipant) {
        print("room delegate --- didSubscribe")
        
        if let videoTrack = track as? VideoTrack {
            DispatchQueue.main.async {
                let videoView = VideoView(frame: .zero)
                self.remoteVideo = videoView
                videoView.translatesAutoresizingMaskIntoConstraints = false
                
                if let localVideo = self.localVideo {
                    self.view.insertSubview(videoView, belowSubview: localVideo)
                } else {
                    self.view.addSubview(videoView)
                }
                
                NSLayoutConstraint.activate([
                    videoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                    videoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                    videoView.topAnchor.constraint(equalTo: self.view.topAnchor),
                    videoView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
                ])
                
                videoTrack.addRenderer(videoView.renderer!)
            }
        }
    }
}

//extension RoomViewController: ParticipantDelegate {
//    func metadataDidChange(participant: Participant) {
//        print("participant delegate --- metdata did change")
//    }
//
//    func isSpeakingDidChange(participant: Participant) {
//        print("participant delegate --- isSpeakingDidChange")
//    }
//
//    func didPublishRemoteTrack(publication: RemoteTrackPublication, participant: RemoteParticipant) {
//        print("participant delegate --- didPublishRemoteTrack")
//    }
//
//    func didUnpublishRemoteTrack(publication: RemoteTrackPublication, particpant: RemoteParticipant) {
//        print("participant delegate --- didUnpublishRemoteTrack")
//    }
//
//    func didFailToSubscribe(sid: String, error: Error, participant: RemoteParticipant) {
//        print("participant delegate --- didFailToSubscribe")
//    }
//
//    func didUnsubscribe(track: Track, publication: RemoteTrackPublication, participant: RemoteParticipant) {
//        print("participant delegate --- didUnsubscribe")
//    }
//
//    func didReceive(data: Data, dataTrack: RemoteTrackPublication, participant: RemoteParticipant) {
//        print("participant delegate --- didReceive")
//    }
//}
