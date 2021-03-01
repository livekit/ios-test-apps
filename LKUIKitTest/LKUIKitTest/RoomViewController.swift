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
        
        let host: String = "35960668c154.ngrok.io"
        let token: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MTcxNDkxNTgsImlzcyI6IkFQSUFnRnlYREpaSkxlODdyNG5kNUVqU1AiLCJqdGkiOiJtb2JpbGUiLCJuYmYiOjE2MTQ1NTcxNTgsInZpZGVvIjp7InJvb21Kb2luIjp0cnVlfX0.tmaDiyg9NCQ7NOkdEyKKv0Em-BegpG9md_dBZmomiNc"
        
        room = LiveKit.connect(options: ConnectOptions.options(token: token, block: { builder in
            builder.host = host
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
}

extension RoomViewController: LocalParticipantDelegate {
    func didPublishAudioTrack(track: LocalAudioTrack) {
        print("local participant delegate --- published local audio track with sid: \(track.sid!)")
    }
    
    func didFailToPublishAudioTrack(error: Error) {
        print("local participant delegate --- error publishing audio track: \(error)")
    }
    
    func didPublishVideoTrack(track: LocalVideoTrack) {
        print("local participant delegate --- published local video track with sid: \(track.sid!)")
        
        DispatchQueue.main.async {
            let videoView = VideoView(frame: .zero)
            self.localVideo = videoView
            
            videoView.translatesAutoresizingMaskIntoConstraints = false
            videoView.layer.cornerRadius = 5.0
            videoView.layer.borderWidth = 3
            videoView.layer.borderColor = UIColor.white.cgColor
            
            if let remoteVideo = self.remoteVideo {
                self.view.insertSubview(videoView, aboveSubview: remoteVideo)
            } else {
                self.view.addSubview(videoView)
            }
            
            let screenSize = UIScreen.main.bounds
            let width = screenSize.width * 0.2
            let height = screenSize.height * 0.2
            NSLayoutConstraint.activate([
                videoView.widthAnchor.constraint(equalToConstant: width),
                videoView.heightAnchor.constraint(equalToConstant: height),
                videoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
                videoView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16)
            ])
        
            track.addRenderer(videoView.renderer!)
        }
    }
    
    func didFailToPublishVideoTrack(error: Error) {
        print("local participant delegate --- error publishing video track: \(error)")
    }
    
    func didPublishDataTrack(track: LocalDataTrack) {
        print("local participant delegate --- published local data track")
    }
}

extension RoomViewController: RemoteParticipantDelegate {
    func didFailToSubscribe(audioTrack: RemoteAudioTrack, error: Error, participant: RemoteParticipant) {
        print("remote participant delegate --- did fail to subscribe to audio")
    }
    
    func didFailToSubscribe(videoTrack: RemoteVideoTrack, error: Error, participant: RemoteParticipant) {
        print("remote participant delegate --- did fail to subscribe to video")
    }
    
    func didSubscribe(dataTrack: RemoteDataTrackPublication, participant: RemoteParticipant) {
        print("remote participant delegate --- did subscribe to data track")
    }
    
    func didUnsubscribe(dataTrack: RemoteDataTrackPublication, participant: RemoteParticipant) {
        print("remote participant delegate --- did unsubscribe from data track")
    }
    
    func didReceive(data: Data, dataTrack: RemoteDataTrackPublication, participant: RemoteParticipant) {
        print("remote participant delegate --- did receive data from data track")
    }
    
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
