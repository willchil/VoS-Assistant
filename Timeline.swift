//
//  Timeline.swift
//  VoS Assistant
//
//  Created by William Chilcote on 8/27/19.
//  Copyright © 2019 William Chilcote. All rights reserved.
//

import SwiftUI
import Combine
import UIKit

#if os(iOS)
import SwifteriOS
#elseif os(watchOS)
import SwifterWatchOS
#endif


public final class Timeline {
    
    static private let defaults: UserDefaults = UserDefaults(suiteName: "group.software.AwesomeStuff.VoS-Assistant")!

    public private(set) static var lastPoll: Date {
        get { return defaults.object(forKey: "lastPoll") as? Date ?? Date(timeIntervalSince1970: 0) }
        set { defaults.set(newValue, forKey: "lastPoll") }
    }
    
    public private(set) static var current1: Clan {
        get { return Clan(rawValue: defaults.object(forKey: "current1") as? String ?? "") ?? .Amlodd }
        set { defaults.set(newValue.rawValue, forKey: "current1") }
    }
    
    public private(set) static var current2: Clan {
        get { return Clan(rawValue: defaults.object(forKey: "current2") as? String ?? "") ?? .Amlodd }
        set { defaults.set(newValue.rawValue, forKey: "current2") }
    }
    
    public private(set) static var past1: Clan {
        get { return Clan(rawValue: defaults.object(forKey: "past1") as? String ?? "") ?? .Amlodd }
        set { defaults.set(newValue.rawValue, forKey: "past1") }
    }
    
    public private(set) static var past2: Clan {
        get { return Clan(rawValue: defaults.object(forKey: "past2") as? String ?? "") ?? .Amlodd }
        set { defaults.set(newValue.rawValue, forKey: "past2") }
    }
    
    public static var others: [Clan] {
        get {
            var others: [Clan] = []
            for clan in Timeline.Clan.allCases {
                if !(self.current1 == clan ) &&
                   !(self.current2 == clan ) &&
                   !(self.past1 == clan    ) &&
                   !(self.past2 == clan    )
                {
                    others.append(clan)
                }
            }
            return others
        }
    }
    
    public static var settings: NotificationSettings {
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                defaults.set(encoded, forKey: "settings")
            }
        }
        get {
            var value = NotificationSettings()
            if let settingsData = defaults.data(forKey: "settings"),
                let newSettings = try? JSONDecoder().decode(NotificationSettings.self, from: settingsData) {
                value = newSettings
            }
            return value
        }
    }

        
    public static var current: [Timeline.Clan]? = nil
    public static var past:    [Timeline.Clan]? = nil
    public static var next:    [Timeline.Clan]? = nil

    public static func updateProcessed () {
        if !Timeline.shouldUpdateAll {
            Timeline.past = []
            if Timeline.shouldUpdateCurrent {
                Timeline.current = nil
                Timeline.past!.append(Timeline.current1)
                Timeline.past!.append(Timeline.current2)
            } else {
                Timeline.current = []
                Timeline.current!.append(Timeline.current1)
                Timeline.current!.append(Timeline.current2)
                Timeline.past!.append(Timeline.past1)
                Timeline.past!.append(Timeline.past2)
            }
            Timeline.next = Timeline.others
        } else {
            Timeline.current = nil
            Timeline.past = nil
            Timeline.next = nil
        }
    }
    
    
    public enum Clan: String, CaseIterable, Codable, Comparable {
        
        case Amlodd
        case Cadarn
        case Crwys
        case Hefin
        case Iorwerth
        case Ithell
        case Meilyr
        case Trahaearn
        
        private var rgb: (Double, Double, Double) {
            get {
                var color: (Double, Double, Double) = (255, 255, 255)
                switch (self) {
                case .Amlodd:
                    color = (153, 191, 230)
                case .Cadarn:
                    color = (153, 230, 172)
                case .Crwys:
                    color = (230, 230, 153)
                case .Hefin:
                    color = (230, 153, 158)
                case .Iorwerth:
                    color = (230, 163, 153)
                case .Ithell:
                    color = (128, 128, 128)
                case .Meilyr:
                    color = (153, 230, 227)
                case .Trahaearn:
                    color = (230, 153, 209)
                }
                color.0 /= 255
                color.1 /= 255
                color.2 /= 255
                return color
            }
        }
        
        public var index: Int {
            get {
                switch (self) {
                case .Meilyr: return 0
                case .Crwys: return 1
                case .Cadarn: return 2
                case .Trahaearn: return 3
                case .Iorwerth: return 4
                case .Ithell: return 5
                case .Amlodd: return 6
                case .Hefin: return 7
                }
            }
        }
        
        public static func < (lhs: Timeline.Clan, rhs: Timeline.Clan) -> Bool {
            return lhs.index < rhs.index
        }
        
        public var color: Color {
            get {
                let rgb = self.rgb
                return Color(red: rgb.0, green: rgb.1, blue: rgb.2)
            }
        }
        
        public var uiColor: UIColor {
            get {
                let color = self.rgb
                return UIColor(red: CGFloat(color.0), green: CGFloat(color.1), blue: CGFloat(color.2), alpha: 1.0)
            }
        }
    }
    
    public static func refresh (onUpdate: @escaping () -> Void) {
        if (self.shouldUpdateCurrent) {
            self.setJSON(onUpdate)
        } else {
            onUpdate()
        }
    }
    
    // Time when the system should next download updated Twitter data
    public static var nextUpdate: Date {
        get { return Date(timeInterval: waitTime, since: nextHour) }
    }
    
    // The start of the hour immediately after lastPoll
    public static var nextHour: Date {
        let hourAfter = Calendar.current.date(byAdding: .hour, value: 1, to: Timeline.lastPoll) ?? Date()
        let allComponents: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let dateComponents = Calendar.current.dateComponents(allComponents, from: hourAfter)
        let nextHour = Calendar.current.date(bySettingHour: dateComponents.hour ?? 0, minute: 0, second: 0, of: hourAfter) ?? hourAfter
        return nextHour
    }
    
    // Number of seconds after the hour that the program should wait until downloading updated info
    public static let waitTime: TimeInterval = 35
    
    // True when clans were last updated anytime before the previous clock hour
    public static var shouldUpdateAll: Bool {
        get { return Date() > Date(timeInterval: 60 * 60, since: Timeline.nextHour) }
    }
    
    // True when clans were last updated anytime in the previous clock hour
    public static var shouldUpdateCurrent: Bool {
        get { return Date() > Timeline.nextHour }
    }
    
    // Download JSON from twitter and pass to cache update function
    static func setJSON (_ onUpdate: @escaping () -> Void) {
        let swifter = Swifter (
            
            // These are the example API key and secret given with the Swifter documentation
            consumerKey: "nLl1mNYc25avPPF4oIzMyQzft",
            consumerSecret: "Qm3e5JTXDhbbLl44cq6WdK00tSUwa17tWlO8Bf70douE4dcJe2"
        )
        let jagexClock = UserTag.screenName("JagexClock")
        let failureHandler: (Error) -> Void = { error in
            print("Error downloading Twitter data from JagexClock")
        }
        swifter.getTimeline(for: jagexClock, count: 6, success: { json in
            let tweets = json.array ?? []
            self.updateFromTwitter(tweets)
            onUpdate()
        }, failure: failureHandler)
    }
    
    // Update cache values from fresh tweet data
    static func updateFromTwitter (_ tweets: [JSON]) {

        var set: Int = 0

        // Iterate through and isolate VoS tweets
        tweets.forEach { item in
            if let text = item["text"].string {
                if (text.contains("Voice of Seren")) {
                    
                    // Generate list of clans in this tweet
                    var clans: [Timeline.Clan] = []
                    for clan in Timeline.Clan.allCases {
                        if (text.contains(clan.rawValue)) {
                            clans.append(clan)
                        }
                    }
                    
                    // Assign current clans
                    if (set == 0) {
                        self.current1 = clans[0]
                        self.current2 = clans[1]
                        set += 1

                        // Update the timestamp for current clans
                        if let dateStr = item["created_at"].string {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "E MMM dd HH:mm:ss Z yyyy"
                            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                            Timeline.lastPoll = dateFormatter.date(from:dateStr)!
                        }

                    // Assign previous clans
                    } else if (set == 1) {
                        self.past1 = clans[0]
                        self.past2 = clans[1]
                        set += 1
                    }
                }
            }
        }
    }
    
    public class NotificationSettings: ObservableObject, Codable {
        
        @Published var allClans: [Clan : Bool]
        
        func binding(_ key: Clan) -> Binding<Bool> {
            return Binding(get: {
                return self.allClans[key] ?? false
            }, set: {
                self.allClans[key] = $0
            })
        }
        
        init () {
            allClans = [:]
            Timeline.Clan.allCases.forEach { item in
                allClans.updateValue(false, forKey: item)
            }
        }
        
        required public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            allClans = try values.decode([Clan:Bool].self, forKey: .clans)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(allClans, forKey: .clans)
        }
        
        enum CodingKeys: String, CodingKey {
            case clans
        }
    }
}
