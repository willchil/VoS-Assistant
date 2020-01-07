//
//  ComplicationController.swift
//  VoS Assistant WatchKit Extension
//
//  Created by William Chilcote on 9/22/19.
//  Copyright © 2019 William Chilcote. All rights reserved.
//

import ClockKit
import WatchKit
import SerenFrameworkWatch


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    
    /* <- Comment this line to enable dynamic complication code
     
    static func scheduleNextRefresh() {
        let fireDate = max(Date(), Timeline.nextUpdate)
        WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: fireDate, userInfo: nil) { _ in }
    }
    
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        getTimelineEntries(for: complication, after: Date(), limit: 1) { (entries) -> Void in
            handler(entries?.first)
        }
        ComplicationController.scheduleNextRefresh()
    }

    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
                
        let c1 = Timeline.current1.rawValue.uppercased()
        let c2 = Timeline.current2.rawValue.uppercased()
        let dateFirst = Timeline.lastPoll
        
        let c1Provider = CLKSimpleTextProvider(text: String(c1.prefix(3)))
        let c2Provider = CLKSimpleTextProvider(text: String(c2.prefix(3)))
        let joinedProvider = CLKSimpleTextProvider(text: c1 + " + " + c2, shortText: String(c1.prefix(3) + " " + c2.prefix(3)))
        let updateProvider = CLKSimpleTextProvider(text: "Updating VoS...", shortText: "...")
        
        var entryList = [CLKComplicationTimelineEntry]()
        switch(complication.family) {
        case .modularSmall:
            let template = CLKComplicationTemplateModularSmallStackText()
            template.line1TextProvider = c1Provider
            template.line2TextProvider = c2Provider
            let entry = CLKComplicationTimelineEntry(date: dateFirst, complicationTemplate: template)
            entryList.append(entry)
            let updating = CLKComplicationTemplateModularSmallSimpleText()
            updating.textProvider = updateProvider
            let entry1 = CLKComplicationTimelineEntry(date: Timeline.nextHour, complicationTemplate: updating)
            entryList.append(entry1)
            break
        case .utilitarianLarge:
            let template = CLKComplicationTemplateUtilitarianLargeFlat()
            template.textProvider = /*CLKSimpleTextProvider(text: Date().description)*/ joinedProvider
            let entry = CLKComplicationTimelineEntry(date: dateFirst, complicationTemplate: template)
            entryList.append(entry)
            let updating = CLKComplicationTemplateUtilitarianLargeFlat()
            updating.textProvider = updateProvider
            let entry1 = CLKComplicationTimelineEntry(date: Timeline.nextHour, complicationTemplate: updating)
            entryList.append(entry1)
            break
        case .utilitarianSmallFlat:
            let template = CLKComplicationTemplateUtilitarianSmallFlat()
            template.textProvider = joinedProvider
            let entry = CLKComplicationTimelineEntry(date: dateFirst, complicationTemplate: template)
            entryList.append(entry)
            let updating = CLKComplicationTemplateUtilitarianSmallFlat()
            updating.textProvider = updateProvider
            let entry1 = CLKComplicationTimelineEntry(date: Timeline.nextHour, complicationTemplate: updating)
            entryList.append(entry1)
            break
        case .circularSmall:
            let template = CLKComplicationTemplateCircularSmallStackText()
            template.line1TextProvider = c1Provider
            template.line2TextProvider = c2Provider
            let entry = CLKComplicationTimelineEntry(date: dateFirst, complicationTemplate: template)
            entryList.append(entry)
            let updating = CLKComplicationTemplateCircularSmallSimpleText()
            updating.textProvider = updateProvider
            let entry1 = CLKComplicationTimelineEntry(date: Timeline.nextHour, complicationTemplate: updating)
            entryList.append(entry1)
            break
        case .extraLarge:
            let template = CLKComplicationTemplateExtraLargeStackText()
            template.line1TextProvider = c1Provider
            template.line2TextProvider = c2Provider
            let entry = CLKComplicationTimelineEntry(date: dateFirst, complicationTemplate: template)
            entryList.append(entry)
            let updating = CLKComplicationTemplateExtraLargeSimpleText()
            updating.textProvider = updateProvider
            let entry1 = CLKComplicationTimelineEntry(date: Timeline.nextHour, complicationTemplate: updating)
            entryList.append(entry1)
            break
        default:
            handler(nil)
            break
        }
        
        if (date > Timeline.nextHour) {
            entryList.removeFirst()
        }
                
        handler(entryList)
    }
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward])
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(Timeline.nextHour)
    }
    // */
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    
    
    
    // MARK: Placeholder Methods
    
    
    // Placeholder Template
    // This method will be called once per supported complication, and the results will be cached
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {        
        
        let template = getPlaceholder(for: complication)
        handler(template)
    }
    
    func getPlaceholder (for complication: CLKComplication) -> CLKComplicationTemplate? {
        let vosImage = UIImage(named: "Template")
        let imageProvider = CLKImageProvider(onePieceImage: vosImage!)
        let textProvider = CLKSimpleTextProvider(text: "Voice of Seren", shortText: "VoS")
        var template: CLKComplicationTemplate? = nil
        switch(complication.family) {
        case .modularSmall:
            let t = CLKComplicationTemplateModularSmallSimpleImage()
            t.imageProvider = imageProvider
            template = t;
            break
        case .utilitarianSmall:
            let t = CLKComplicationTemplateUtilitarianSmallSquare()
            t.imageProvider = imageProvider
            template = t;
            break
        case .utilitarianLarge:
            let t = CLKComplicationTemplateUtilitarianLargeFlat()
            t.imageProvider = imageProvider
            t.textProvider = textProvider
            template = t
            break
        case .utilitarianSmallFlat:
            let t = CLKComplicationTemplateUtilitarianSmallFlat()
            t.imageProvider = imageProvider
            t.textProvider = textProvider
            template = t
            break
        case .circularSmall:
            let t = CLKComplicationTemplateCircularSmallSimpleImage()
            t.imageProvider = imageProvider
            template = t
            break
        case .extraLarge:
            let t = CLKComplicationTemplateExtraLargeSimpleImage()
            t.imageProvider = imageProvider
            template = t
            break
        case .graphicCorner:
            let t = CLKComplicationTemplateGraphicCornerCircularImage()
            guard let image = UIImage(named: "Complication/Graphic Corner") else { break }
            t.imageProvider = CLKFullColorImageProvider(fullColorImage: image)
            template = t;
            break
        case .graphicCircular:
            let t = CLKComplicationTemplateGraphicCircularImage()
            guard let image = UIImage(named: "Complication/Graphic Circular") else { break }
            t.imageProvider = CLKFullColorImageProvider(fullColorImage: image)
            template = t;
            break
        case .graphicRectangular:
            let t = CLKComplicationTemplateGraphicRectangularLargeImage()
            t.textProvider = textProvider
            guard let image = UIImage(named: "Complication/Graphic Large Rectangular") else { break }
            t.imageProvider = CLKFullColorImageProvider(fullColorImage: image)
            template = t;
            break
        default:
            break
        }
        return template
    }
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward])
    }
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        let template = getPlaceholder(for: complication)
        let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template!)
        handler(entry)
    }
    
}
