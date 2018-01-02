//
//  SecondViewController.swift
//  TeamCaring
//
//  Created by PqThanh on 11/17/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit
import MBCalendarKit
import SVProgressHUD
import UIScrollView_InfiniteScroll
import ESPullToRefresh
import EventKit

class CalViewController: UIViewController, CalendarViewDataSource, CalendarViewDelegate {

    @IBOutlet weak var mainView: UIView!
    let calendar = CalendarViewController()
    var data : [Date:[CalendarEvent]] = [:]
    var currentMonth: Int = 0
    var listEvent = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.present(calendar, animated: true, completion: nil)
        self.mainView.addSubview(calendar.view)
        
        calendar.delegate = self
        calendar.dataSource = self
        //self.adEventsToCalendar()
        self.calendar.tableView.tableFooterView = UIView()
        self.calendar.calendarView.setLocale(NSLocale(localeIdentifier: "vi") as Locale, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let date = Date()
        let cal = Calendar.current
        let year = cal.component(.year, from: date)
        let month = cal.component(.month, from: date)
        let strMonth = month > 9 ? "\(month)" : "0\(month)"
        currentMonth = month
        FService.sharedInstance.getAppointment(fromDate: "\(year)-\(strMonth)-01 00:00:00", toDate: "\(year)-\(strMonth)-31 00:00:00") { (listEvents) in
            if listEvents != nil {
                self.listEvent.removeAll()
                self.data.removeAll()
                self.listEvent = listEvents!
                var listCategories = [String: [Event]]()
                listCategories = listEvents!.group { ($0.time?.components(separatedBy: " ")[0])! }
                
                for key in listCategories.keys {
                    let values = listCategories[key]
                    var events = [CalendarEvent]()
                    for item in values! {
                        let date = self.stringToDate(strDate: item.time ?? "")
                        let event : CalendarEvent = CalendarEvent(title: item.name, andDate: date, andInfo: nil, andImageUrl: item.imageUrl!)
                        events.append(event)
                        self.addEventToDefaultCal(title: item.name!, date: date, content: item.eDescription!, type: item.repeatType!)
                    }
                    let date = "\(key) 00:00:00"
                    self.data[self.stringToDate(strDate: date)] = events
                }
                self.calendar.calendarView.setLocale(NSLocale(localeIdentifier: "vi") as Locale, animated: true)
            }
        }
        self.calendar.tableView.reloadData()
    }
    
    func addEventToDefaultCal(title: String, date: Date, content: String, type: String) {
        
//        //NSArray *allCalendars = [self.eventStore calendarsForEntityType:EKEntityTypeEvent];
//        let eventStore : EKEventStore = EKEventStore()
//        let allCalendars = eventStore.calendars(for: EKEntityType.event)
//
//        //NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:[NSDate dateWithTimeIntervalSinceNow:-yearSeconds] endDate:[NSDate dateWithTimeIntervalSinceNow:yearSeconds] calendars:calendarsArray];
//        //NSArray *eventsArray = [self.eventStore eventsMatchingPredicate:predicate];
//
//        let predicate: NSPredicate = eventStore.predicateForEvents(withStart: date, end: date, calendars: allCalendars)
//        let eventsArray = eventStore.events(matching: predicate)
//        if eventsArray.count ==  {
//            <#code#>
//        }
        
        let eventStore : EKEventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { (granted, error) in
            if (granted) && (error == nil) {
                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = date
                event.endDate = date
                event.notes = content
                event.calendar = eventStore.defaultCalendarForNewEvents
                event.addAlarm(EKAlarm(absoluteDate: event.startDate.addingTimeInterval(-3600)))
                
                //let recurrenceEnd: EKRecurrenceEnd = EKRecurrenceEnd(end: event.startDate)
                let rule: EKRecurrenceRule = EKRecurrenceRule(recurrenceWith: (type == "one_month" ? EKRecurrenceFrequency.monthly : EKRecurrenceFrequency.weekly), interval: (type == "one_month" ? 1 : (type == "one_week" ? 1 : 2)), end: nil)
                event.recurrenceRules = [rule]
                
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                }
            }
            else{
                print("failed to save event with error : \(error ?? "" as! Error) or access not granted")
            }
        }
    }
    
    func getImage(url: String) -> UIImage? {
        var result: UIImage?
        let group = DispatchGroup()
        group.enter()
        _ = UIImage.image(fromURL: url, placeholder: UIImage(), shouldCacheImage: true) { (image) in
            result = image
            group.leave()
        }
        group.wait()
        return result
    }
    
    func stringToDate(strDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from:strDate)!
        return date
    }
    
    func setTo830AM(date: Date, hour: Int, min: Int) -> Date {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        var components = calendar.components(([.day, .month, .year]), from: date)
        components.hour = hour
        components.minute = min
        return calendar.date(from: components)!
    }
    
    func dataResizeImg(sourceImage: UIImage) -> Data {
        let oldWidth = CGFloat(sourceImage.size.width)
        let scaleFactor: CGFloat = 50 / oldWidth
        let newHeight = CGFloat(sourceImage.size.height * scaleFactor)
        let newWidth: CGFloat = oldWidth * scaleFactor
        UIGraphicsBeginImageContext(CGSize(width: CGFloat(newWidth), height: CGFloat(newHeight)))
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: CGFloat(newWidth), height: CGFloat(newHeight)))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImagePNGRepresentation(newImage ?? UIImage())!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChiTietCuocHen" {
            let infoEv: CalendarEvent = sender as! CalendarEvent
            
            var selectedValue: Event?
            for match in self.listEvent {
                if match.name == infoEv.title && self.stringToDate(strDate: match.time!) == infoEv.date {
                    selectedValue = match
                    break
                }
            }
            
            let detail: ChiTietCuocHenVC = segue.destination as! ChiTietCuocHenVC
            detail.currentEvent = selectedValue
        }
    }
    
    //  MARK: - CalendarDataSource
    
    /**
     Allows the data source to supply events to display on the calendar.
     
     @param calendarView The calendar view instance that will display the data.
     @param date The date for which the calendar view wants events.
     @return An array of events objects.
     */
    func calendarView(_ calendarView: CalendarView, eventsFor date: Date) -> [CalendarEvent] {
        let eventsForDate = self.data[date] ?? []
        return eventsForDate
    }
    
    
    // MARK: - CKCalendarDelegate
    
    // Called before the selected date changes.
    func calendarView(_ calendarView: CalendarView, didSelect date: Date) {
        //self.calendarView(calendarView, didSelect: date) // Call super to ensure it
    }
    
    // Called after the selected date changes.
    func calendarView(_ calendarView: CalendarView, willSelect date: Date) {
   
        let cal = Calendar.current
        let year = cal.component(.year, from: date)
        let month = cal.component(.month, from: date)
        if currentMonth != month {
            currentMonth = month
            FService.sharedInstance.getAppointment(fromDate: "\(year)-\(month)-01 00:00:00", toDate: "\(year)-\(month)-31 00:00:00") { (listEvents) in
                if listEvents != nil {
                    self.listEvent += listEvents!
                    var listCategories = [String: [Event]]()
                    listCategories = listEvents!.group { ($0.time?.components(separatedBy: " ")[0])! }
                    
                    for key in listCategories.keys {
                        let values = listCategories[key]
                        var events = [CalendarEvent]()
                        for item in values! {
                            let date = self.stringToDate(strDate: item.time ?? "")
                            let event : CalendarEvent = CalendarEvent(title: item.name, andDate: date, andInfo: nil, andImageUrl: item.imageUrl!)
                            events.append(event)
                            self.addEventToDefaultCal(title: item.name!, date: date, content: item.eDescription!, type: item.repeatType!)
                        }
                        let date = "\(key) 00:00:00"
                        self.data[self.stringToDate(strDate: date)] = events
                    }
                    self.calendar.calendarView.setLocale(NSLocale(localeIdentifier: "vi") as Locale, animated: true)
                }
            }
        }
        
    }
    
    // A row was selected in the events table. (Use this to push a details view or whatever.)
    func calendarView(_ calendarView: CalendarView, didSelect event: CalendarEvent) {
        self.performSegue(withIdentifier: "ChiTietCuocHen", sender: event)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

public extension Sequence {
    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        var categories: [U: [Iterator.Element]] = [:]
        for element in self {
            let key = key(element)
            if case nil = categories[key]?.append(element) {
                categories[key] = [element]
            }
        }
        return categories
    }
}

