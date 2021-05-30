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

        let url: String = "ws://<your_host>"
        let token: String = "<your_token>"

        room = LiveKit.connect(options: ConnectOptions(url: url, token: token), delegate: self)
    }
}

extension RoomViewController: RoomDelegate {
    /* Room Delegate Methods */
    func didConnect(room: Room) {
        if let localParticipant = room.localParticipant {
            DispatchQueue.global(qos: .background).async {
                do {
                    var videoOpts = LocalVideoTrackOptions()
                    videoOpts.captureParameter = VideoPreset.hd.capture
                    let videoTrack = try LocalVideoTrack.createTrack(name: "localVideo", options: videoOpts)
                    _ = localParticipant.publishVideoTrack(track: videoTrack)
                } catch {
                    print("\(error)")
                }

                let audioTrack = LocalAudioTrack.createTrack(name: "localAudio")
                _ = localParticipant.publishAudioTrack(track: audioTrack)
            }
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
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }

    func didFailToConnect(room _: Room, error _: Error) {
        print("room delegate --- did fail to connect")
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
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

                videoTrack.addRenderer(videoView.renderer)
            }
        }
    }

    func activeSpeakersDidChange(speakers: [Participant], room _: Room) {
    }
}
