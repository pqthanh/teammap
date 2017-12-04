//
//  SecondViewController.swift
//  TeamCaring
//
//  Created by PqThanh on 11/17/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit
import MBCalendarKit

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
        self.adEventsToCalendar()
        
        self.calendar.tableView.tableFooterView = UIView()
        self.calendar.calendarView.setLocale(NSLocale(localeIdentifier: "vi") as Locale, animated: true)
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
        
    }
    
    // A row was selected in the events table. (Use this to push a details view or whatever.)
    func calendarView(_ calendarView: CalendarView, didSelect event: CalendarEvent) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

