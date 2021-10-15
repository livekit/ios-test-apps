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

    var isRearCamera: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.toggleCamera(_:))))

        let url: String = "wss://rtc.unxpected.co.jp"
        // swiftlint:disable:next line_length
        let token: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MzQyMjgzNDksIm5iZiI6MTYzNDIyNjU0OSwiaXNzIjoiQVBJd2NWRFNSUjRTRkE2IiwianRpIjoiZGVidWciLCJ2aWRlbyI6eyJyb29tIjoicm9vbWE0OGM5ZmUxLTQ5OGQtNGE5OC1iYzdmLTE4YmI2YWI3M2QzYiIsInJvb21DcmVhdGUiOnRydWUsInJvb21Kb2luIjp0cnVlLCJyb29tTGlzdCI6dHJ1ZSwicm9vbVJlY29yZCI6dHJ1ZSwicm9vbUFkbWluIjp0cnVlLCJjYW5QdWJsaXNoIjp0cnVlLCJjYW5TdWJzY3JpYmUiOnRydWV9fQ.QV6TEZBXQKurRAkxMQUiTDdhoOSMMMphOqr2CWsgpZU"

        room = LiveKit.connect(options: ConnectOptions(url: url, token: token), delegate: self)
    }

    override func viewDidDisappear(_ animated: Bool) {
        room?.disconnect()
        room = nil
        //        LiveKit.releaseAudioSession()
    }

    @objc func toggleCamera(_ sender: UITapGestureRecognizer) throws {
        //
        let pub = room?.localParticipant?.videoTracks.values.first
        let track = pub?.track as? LocalVideoTrack

        var options = LocalVideoTrackOptions()
        options.captureParameter = VideoParameters.presetHD169
        options.position = isRearCamera ? .front: .back
        isRearCamera = !isRearCamera

        try track?.restartTrack(options: options)
    }

}

extension RoomViewController: RoomDelegate {

    /* Room Delegate Methods */
    func room(_ room: Room, didConnect isReconnect: Bool) {
        print("[Publish] attempt publish local tracks")

        if let localParticipant = room.localParticipant {

            if isReconnect {
                print("[Publish] ignoring publish since it is reconnect")
                return
            }

            DispatchQueue.global(qos: .background).async {
                do {
                    var videoOpts = LocalVideoTrackOptions()
                    videoOpts.captureParameter = VideoParameters.presetHD43

                    var publishOptions = LocalVideoTrackPublishOptions()
                    publishOptions.simulcast = true

                    let videoTrack = try LocalVideoTrack.createTrack(name: "localVideo", options: videoOpts)
                    localParticipant.publishVideoTrack(track: videoTrack, options: publishOptions).then({ _ in
                        print("[Publish] video success")
                    }).catch({ error in
                        print("[Publish] error \(error)")
                    })

                } catch {
                    print("\(error)")
                }

                let audioTrack = LocalAudioTrack.createTrack(name: "localAudio")
                _ = localParticipant.publishAudioTrack(track: audioTrack)
            }
        }
    }

    func room(_ room: Room, didDisconnect error: Error?) {
        print("room delegate --- did disconnect")
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }

    //    func room(_ room: Room, didFailToConnect error: Error) {
    //        print("room delegate --- did fail to connect")
    //        DispatchQueue.main.async {
    //            self.dismiss(animated: true)
    //        }
    //    }

    func room(_ room: Room, participant: RemoteParticipant, didUnsubscribe trackPublication: RemoteTrackPublication) {
        print("room delegate --- didUnsubscribe")
        if trackPublication.kind == .video {
            DispatchQueue.main.async {
                self.remoteVideo?.removeFromSuperview()
                self.remoteVideo = nil
            }
        }
    }

    func room(_ room: Room, participant: RemoteParticipant,
              didSubscribe trackPublication: RemoteTrackPublication, track: Track) {
        print("room delegate --- didSubscribe")

        if let videoTrack = track as? VideoTrack {
            DispatchQueue.main.async {
                let videoView = VideoView(frame: .zero)
                videoView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                      action: #selector(self.toggleCamera(_:))))

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

                videoTrack.addRenderer(videoView.renderer)
            }
        }
    }
}
