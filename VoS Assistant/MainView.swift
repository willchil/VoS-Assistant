//
//  MainView.swift
//  VoS Assistant
//
//  Created by William Chilcote on 12/12/19.
//  Copyright © 2019 William Chilcote. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    @State var editState = false
    let contentView = ContentView()
    var settings = Timeline.settings
    
    var body: some View {
        NavigationView {
            contentView
            .sheet(isPresented: $editState) {
                NavigationView {
                    SettingsView().environmentObject(self.settings)
                    .navigationBarTitle("Toggle Notifications")
                    .navigationBarItems(trailing:
                        Button(action: { self.editState = false }) {
                            Text("Done")
                        }
                    )
                }.navigationViewStyle(StackNavigationViewStyle())
            }
            .navigationBarTitle("Voice of Seren")
            
            // Button to toggle notifications interface
//            .navigationBarItems(trailing:
//                Button(action: { self.editState = true }) {
//                    Image(systemName: "gear").imageScale(.large)
//                }
//            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
