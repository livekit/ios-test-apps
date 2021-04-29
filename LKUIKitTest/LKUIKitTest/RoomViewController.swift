//
//  RoomViewController.swift
//  LKUIKitTest
//
//  Created by Russell D'Sa on 1/16/21.
//

import AVFoundation
import LiveKit
import UIKit

class RoomViewController: UIViewController {
    var room: Room?
    var remoteVideo: VideoView?
    var localVideo: VideoView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let url: String = "ws://livekit-demo-http-1682066792.us-east-1.elb.amazonaws.com"
//        let url: String = "ws://192.168.93.78:7880"
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
                _ = localParticipant.publishVideoTrack(track: videoTrack)
            } catch {
                print("\(error)")
            }

//            let audioTrack = LocalAudioTrack.createTrack(name: "localAudio")
//            _ = localParticipant.publishAudioTrack(track: audioTrack)
        }
    }

    func isReconnecting(room _: Room) {
        print("room delegate --- reconnecting")
    }

    func didReconnect(room _: Room) {
        print("room delegate --- reconnected")
    }

    func didDisconnect(room _: Room, error _: Error?) {
        print("room delegate --- did disconnect")
        dismiss(animated: true)
    }

    func didFailToConnect(room _: Room, error _: Error) {
        print("room delegate --- did fail to connect")
    }

    func didSubscribe(track: Track, publication _: RemoteTrackPublication, participant _: RemoteParticipant) {
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
                    videoView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                ])

                videoTrack.addRenderer(videoView.renderer!)
            }
        }
    }

    func activeSpeakersDidChange(speakers: [Participant], room _: Room) {
        print("active speakers \(speakers)")
    }
}
