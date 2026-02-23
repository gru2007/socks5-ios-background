//
//  Socks5App.swift
//  Socks5
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func applicationDidEnterBackground(_ application: UIApplication) {
        BackgroundAudioPlayer.shared.start()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        BackgroundAudioPlayer.shared.stop()
    }
}

@main
struct Socks5App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
