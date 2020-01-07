//
//  HostingController.swift
//  VoS Assistant WatchKit Extension
//
//  Created by William Chilcote on 9/22/19.
//  Copyright © 2019 William Chilcote. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI

class HostingController: WKHostingController<WatchView> {
    
    let watchView = WatchView()
    
    override var body: WatchView {
        return watchView
    }
    
    override func willActivate() {
        watchView.contentView.onEnter()
    }
    
    override func didDeactivate() {
        watchView.contentView.onExit()
    }
}
