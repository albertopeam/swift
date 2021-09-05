//
//  MultiModuleApp.swift
//  MultiModule
//
//  Created by Alberto Penas Amor on 4/9/21.
//

import SwiftUI

@main
struct MultiModuleApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainView()
            }
        }
    }
}
//TODO: fix test plan
//TODO: fix image from bundle

//list test plan
//xcodebuild -scheme MultiModule -showTestPlans
//run test plan
//xcodebuild test -scheme MultiModule -destination 'platform=iOS Simulator,OS=14.4,name=iPhone 11' -testPlan MultiModuleUnitTestPlan
