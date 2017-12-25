//
//  DateTimePickerVC.swift
//  TeamCaring
//
//  Created by Phan Quoc Thanh on 12/5/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit

class DateTimePickerVC: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    var selectedBlock: ((Date) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //let currentDate: NSDate = NSDate()
        //self.datePicker.minimumDate = currentDate as Date
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let currentDate: NSDate = NSDate()
        let components: NSDateComponents = NSDateComponents()
        components.hour = +1
        let minDate: NSDate = gregorian.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        self.datePicker.minimumDate = minDate as Date
    }

    @IBAction func datePickerAction(sender: AnyObject) {
        if let selectedBlock = self.selectedBlock {
            selectedBlock(datePicker.date)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
