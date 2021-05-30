//
//  AppDelegate.swift
//  LKUIKitTest
//
//  Created by Russell D'Sa on 1/16/21.
//

import Logging
import UIKit
import WebRTC

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func logFactory(label: String) -> LogHandler {
        var handler = StreamLogHandler.standardError(label: label)
        handler.logLevel = .debug
        return handler
    }

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Customize logging. LiveKit uses SwiftLog
        LoggingSystem.bootstrap(logFactory)
//        RTCSetMinDebugLogLevel(RTCLoggingSeverity.warning)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
