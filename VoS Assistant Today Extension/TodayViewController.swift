//
//  TodayViewController.swift
//  Vos Assistant Today Extension
//
//  Created by William Chilcote on 9/23/19.
//  Copyright © 2019 William Chilcote. All rights reserved.
//

import UIKit
import SerenFramework
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var current1: UIImageView!
    @IBOutlet weak var current2: UIImageView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateWidget()
        Timeline.refresh () {
            self.updateWidget()
        }
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func updateWidget () {
        Timeline.updateProcessed()
        if let current = Timeline.current {
            current1.image = UIImage(named: current[0].rawValue)
            current2.image = UIImage(named: current[1].rawValue)
            label1.text = current[0].rawValue
            label2.text = current[1].rawValue
        } else {
            current1.image = nil
            current2.image = nil
            label1.text = "Updating..."
            label2.text = "Updating..."
        }
        
    }
    
}
