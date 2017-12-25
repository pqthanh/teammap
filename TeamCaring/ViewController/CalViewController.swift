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

class CalViewController: UIViewController, CalendarViewDataSource, CalendarViewDelegate {

    @IBOutlet weak var mainView: UIView!
    let calendar = CalendarViewController()
    var data : [Date:[CalendarEvent]] = [:]
    
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
        
        let date = Date()
        let cal = Calendar.current
        let year = cal.component(.year, from: date)
        let month = cal.component(.month, from: date)
        print(month)
        FService.sharedInstance.getAppointment(fromDate: "\(year)-\(month)-01 00:00:00", toDate: "\(year)-\(month)-31 00:00:00") { (listEvents) in
            if listEvents != nil {
                
                var listCategories = [String: [Event]]()
                listCategories = listEvents!.group { ($0.time?.components(separatedBy: " ")[0])! }
                
                for key in listCategories.keys {
                    let values = listCategories[key]
                    var events = [CalendarEvent]()
                    for item in values! {
                        let date = self.stringToDate(strDate: item.time ?? "")
                        let event : CalendarEvent = CalendarEvent(title: item.name, andDate: date, andInfo: nil, andImageUrl: item.imageUrl!)
                        events.append(event)
                    }
                    let date = "\(key) 00:00:00"
                    self.data[self.stringToDate(strDate: date)] = events
                }
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
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let finalDate = calendar.date(from:components)
        return finalDate!
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
    
    func adEventsToCalendar() {
        let title = "Lịch hẹn 1"
        if let date : Date = NSDate(day: 21, month: 11, year: 2017) as Date?
        {
            let event : CalendarEvent = CalendarEvent(title: title, andDate: self.setTo830AM(date: date, hour: 8, min: 30), andInfo: nil, andImage: self.dataResizeImg(sourceImage: UIImage(named: "1")!))
            self.data[date] = [event]
        } 
        
        let title2 = "Lịch hẹn 1"
        if let date2 : Date = NSDate(day: 29, month: 11, year: 2017) as Date?
        {
            let event2 : CalendarEvent = CalendarEvent(title: title2, andDate: self.setTo830AM(date: date2, hour: 8, min: 30), andInfo: nil, andImage: self.dataResizeImg(sourceImage: UIImage(named: "2")!))
            let event3 : CalendarEvent = CalendarEvent(title: "Lịch hẹn 2", andDate: self.setTo830AM(date: date2, hour: 9, min: 45), andInfo: nil, andImage: self.dataResizeImg(sourceImage: UIImage(named: "12")!))
            self.data[date2] = [event2, event3]
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
        print(date)
    }
    
    // A row was selected in the events table. (Use this to push a details view or whatever.)
    func calendarView(_ calendarView: CalendarView, didSelect event: CalendarEvent) {
        
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

