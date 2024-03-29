//
//  ViewController.swift
//  LKUIKitTest
//
//  Created by Russell D'Sa on 1/16/21.
//

import UIKit
import ReplayKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let button = UIButton(type: .system)
        button.setTitle("Connect", for: .normal)
        button.frame = CGRect(x: 0, y: 0,
                              width: button.intrinsicContentSize.width,
                              height: button.intrinsicContentSize.height)
        button.center = view.center
        button.addTarget(self, action: #selector(connectToRoom), for: .touchUpInside)
        view.addSubview(button)
    }

    @objc func connectToRoom(sender _: UIButton) {
        present(RoomViewController(), animated: true, completion: nil)
    }

    @objc func record() {
        let broadcastPicker = RPSystemBroadcastPickerView(frame: CGRect(x: 50,
                                                                        y: 50,
                                                                        width: view.bounds.width,
                                                                        height: 50))
        broadcastPicker.preferredExtension = "io.livekit.example.screen-broadcaster"
        view.addSubview(broadcastPicker)
    }
}
