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
        
        let url: String = "ws://192.168.91.198:7880"
        let token: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MTgyMDg0MzksImlzcyI6IkFQSU1teGlMOHJxdUt6dFpFb1pKVjlGYiIsImp0aSI6ImlvcyIsIm5iZiI6MTYxNTYxNjQzOSwidmlkZW8iOnsicm9vbSI6Im15cm9vbSIsInJvb21Kb2luIjp0cnVlfX0.Hdk5EfkRyHBNA3XiHCezFbm9gkzu1ph-_FU1e_EggLU"
        
        room = LiveKit.connect(options: ConnectOptions.options(token: token, block: { builder in
            builder.url = url
        }), delegate: self)
    }
}

extension RoomViewController: RoomDelegate {
    /* Room Delegate Methods */
    func didConnect(room: Room) {
        room.remoteParticipants.values.forEach { $0.delegate = self }
        
        if let localParticipant = room.localParticipant {
            localParticipant.delegate = self
            
            do {
                let videoTrack = try LocalVideoTrack.track(enabled: true, name: "localVideo")
                localParticipant.publishVideoTrack(track: videoTrack)
            } catch {
                print("\(error)")
            }

//            let audioTrack = LocalAudioTrack.track(name: "localAudio")
//            localParticipant.publishAudioTrack(track: audioTrack)
        }
    }
    
    func activeSpeakersDidChange(speakers: [Participant], room: Room) {
        print("room delegate --- active speakers did change")
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
    
    func participantDidConnect(room: Room, participant: RemoteParticipant) {
        participant.delegate = self
    }
    
    func participantDidDisconnect(room: Room, participant: RemoteParticipant) {
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
    
    func didSubscribe(track: Track, publication: TrackPublication, participant: RemoteParticipant) {
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

extension RoomViewController: ParticipantDelegate {
    func metadataDidChange(participant: Participant) {
        print("participant delegate --- metdata did change")
    }
    
    func isSpeakingDidChange(participant: Participant) {
        print("participant delegate --- isSpeakingDidChange")
    }
    
    func didPublishRemoteTrack(publication: TrackPublication, participant: RemoteParticipant) {
        print("participant delegate --- didPublishRemoteTrack")
    }
    
    func didUnpublishRemoteTrack(publication: TrackPublication, particpant: RemoteParticipant) {
        print("participant delegate --- didUnpublishRemoteTrack")
    }
    
    func didMute(publication: TrackPublication, participant: RemoteParticipant) {
        print("participant delegate --- didMute")
    }
    func didUnmute(publication: TrackPublication, participant: RemoteParticipant) {
        print("participant delegate --- didUnmute")
    }

    func didFailToSubscribe(sid: String, error: Error, participant: RemoteParticipant) {
        print("participant delegate --- didFailToSubscribe")
    }
    
    func didUnsubscribe(track: Track, publication: TrackPublication, participant: RemoteParticipant) {
        print("participant delegate --- didUnsubscribe")
    }

    func didReceive(data: Data, dataTrack: TrackPublication, participant: RemoteParticipant) {
        print("participant delegate --- didReceive")
    }
}
