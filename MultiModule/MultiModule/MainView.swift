//
//  ContentView.swift
//  MultiModule
//
//  Created by Alberto Penas Amor on 4/9/21.
//

import SwiftUI
import Module1
import Module2
import Interface

struct MainView: View {
    var body: some View {
        VStack {
            PhotosView()
        }
        .navigationBarTitle("Multi-module")
        .navigationBarTitleDisplayMode(.inline)
        .navigationViewStyle(StackNavigationViewStyle())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: SettingsView()) {
                    Text("Settings")
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
