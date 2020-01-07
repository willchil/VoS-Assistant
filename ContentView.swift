//
//  ContentView.swift
//  VoS Assistant
//
//  Created by William Chilcote on 9/22/19.
//  Copyright © 2019 William Chilcote. All rights reserved.
//

import SwiftUI

#if os(iOS)
import SerenFramework
#elseif os(watchOS)
import SerenFrameworkWatch
#endif

var isWatch: Bool { get {
#if os(watchOS)
return true
#else
return false
#endif
}}

struct ContentView: View {
        
    @ObservedObject var voiceState = VoiceState()
    static var timer: Timer = Timer()
    static var updatedComplications = false
    
    var body: some View {
        Form {
            if (voiceState.current == nil) {
                Section(header: Text("Now")) {
                    SectionList(list: $voiceState.current)
                }
            } else {
                NowHeader(list: $voiceState.current)
            }
            Section (header: Text("Up next (random)")) {
                SectionList(list: $voiceState.next)
            }
            Section(header: Text("Previously")) {
                SectionList(list: $voiceState.past)
            }
        }
    }
    
    private func updateTimer () {
        ContentView.timer.invalidate()
        var fireDate = Timeline.nextHour
        var timerBlock: ()->Void = updateUI
        if Timeline.shouldUpdateCurrent {
            fireDate = Timeline.nextUpdate
            timerBlock = onEnter
        }
//        print("starting foreground timer at \(Date()) for \(fireDate) (\(Timeline.shouldUpdateCurrent))")
        ContentView.timer = Timer(fire: fireDate, interval: 0, repeats: false) { timer in
            timerBlock()
        }
        RunLoop.current.add(ContentView.timer, forMode: .common)
    }
    
    private func updateUI () {
//        print("running UI refresh at", Date())
        voiceState.update()
        updateTimer()
    }
    
    func onEnter () {
//        print("running onEnter at", Date())
        let neededUpdate = Timeline.shouldUpdateCurrent
        Timeline.refresh() {
            self.updateUI()
            #if os(watchOS)
            if neededUpdate && !Timeline.shouldUpdateCurrent {
                ContentView.updatedComplications = true
                ExtensionDelegate.updateComplications()
            }
            #endif
        }
    }
    
    func onExit () {
        ContentView.timer.invalidate()
//        print("exit")
//        #if os(watchOS)
//        if ContentView.updatedComplications {
//            ComplicationController.scheduleNextRefresh()
//            ContentView.updatedComplications = false
//        }
//        #endif
    }
}

struct NowHeader: View {
    
    @Binding var list: [Timeline.Clan]?
    let imageHeight: CGFloat = 64;
    
    var body: some View {
        GeometryReader { geometry in
            HStack (spacing: 0) {
                ForEach(self.list!, id: \.self) { clan in
                    Group {
                        VStack {
                            Image(clan.rawValue)
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width / 2, height: self.imageHeight)
                                .padding(.top, isWatch ? 10 : 5)
                            Text(clan.rawValue)
                                .foregroundColor(clan.color)
                                .lineLimit(1)
                                .scaledToFit()
                                .environment(\.allowsTightening, true)
                                .frame(width: geometry.size.width / 2)
                                .padding(.bottom, isWatch ? 5 : 0)
                        }
                    }
                }
            }
        }.padding(.vertical, imageHeight / 2.0 + 16)
    }
}

struct SectionList: View {
    @Binding var list: [Timeline.Clan]?
    
    var body: some View {
        Group {
            if (list != nil) {
                ForEach(list!, id: \.self) { clan in
                    HStack {
                        Text(clan.rawValue).foregroundColor(clan.color)
                        Spacer()
                        Image(clan.rawValue).padding(5)
                    }
                }
            } else {
                HStack {
                    Spacer()
                    Text("Updating...")
                    Spacer()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.colorScheme, .dark)
    }
}

class VoiceState: ObservableObject {
    @Published var current: [Timeline.Clan]? = nil
    @Published var past:    [Timeline.Clan]? = nil
    @Published var next:  [Timeline.Clan]? = nil
    
    init () {
        update()
    }
    
    func update () {
        Timeline.updateProcessed()
        self.current = Timeline.current
        self.past = Timeline.past
        self.next = Timeline.next
    }
}

struct SettingsView: View {
        
    @EnvironmentObject var settings: Timeline.NotificationSettings
    
    var body: some View {
        Form {
            ForEach(settings.allClans.keys.sorted(), id: \.self) { key in
                Toggle(isOn: self.settings.binding(key)) {
                    HStack {
                        Text(key.rawValue).foregroundColor(key.color)
                        Spacer()
                        if !isWatch { Image(key.rawValue).padding(.horizontal) }
                    }
                }
            }
        }
        .onDisappear () {
            Timeline.settings = self.settings
        }
    }
}
