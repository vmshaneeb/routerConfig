//
//  routerConfigApp.swift
//  routerConfigwatchOS WatchKit Extension
//
//  Created by M Shaneeb on 16/8/2020.
//

import SwiftUI

@main
struct routerConfigApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
