//
//  WatchView.swift
//  VoS Assistant WatchKit Extension
//
//  Created by William Chilcote on 12/12/19.
//  Copyright © 2019 William Chilcote. All rights reserved.
//

import SwiftUI

struct WatchView: View {
    
    @State var editState = false
    let contentView = ContentView()
    let settings = Timeline.settings
    
    var body: some View {
        Group {
            if editState {
                SettingsView().environmentObject(settings)
            } else {
                contentView
            }
        }
        
        // Force-touch button for notifications interface
//        .contextMenu(menuItems: {
//            Button(action: {
//                self.editState = false
//            }, label: {
//                VStack{
//                    Image(systemName: "clock")
//                        .font(.title)
//                    Text("Current")
//                }
//            })
//            Button(action: {
//                self.editState = true
//            }, label: {
//                VStack{
//                    Image(systemName: "app.badge").font(.title)
//                    Text("Notifications")
//                }
//            })
//        })
    }
}

struct WatchView_Previews: PreviewProvider {
    static var previews: some View {
        WatchView()
    }
}
