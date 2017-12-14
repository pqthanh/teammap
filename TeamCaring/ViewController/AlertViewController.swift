//
//  AlertViewController.swift
//  TeamCaring
//
//  Created by PqThanh on 11/20/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit
import SVProgressHUD
import UIScrollView_InfiniteScroll
import ESPullToRefresh

class AlertViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblAlert: UITableView!
    var items = [Notification]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SVProgressHUD.setDefaultMaskType(.clear)
        self.tblAlert.estimatedRowHeight = 44
        self.tblAlert.rowHeight = UITableViewAutomaticDimension
        self.tblAlert.tableFooterView = UIView()
        
        self.loadAlert()
        
        self.tblAlert.es.addPullToRefresh {
            [unowned self] in
            self.tblAlert.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: true)
            self.loadAlert()
        }
    }
    
    func loadAlert() {
        SVProgressHUD.show()
        FService.sharedInstance.getNotification(page: 0) { (result) in
            if result != nil {
                self.items.removeAll()
                self.items = result!
                self.tblAlert.reloadData()
            }
            SVProgressHUD.dismiss()
        }
    }
    
    func formatDate(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "HH:mm:ss dd/MM/yyyy"
        let output = dateFormatter.string(from: date!)
        return output
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let dataInfo: Notification = self.items[editActionsForRowAt.row]
        let accept = UITableViewRowAction(style: .normal, title: "") { action, index in
            SVProgressHUD.show()
            FService.sharedInstance.acceptJoinTeam(requestId: dataInfo.targetId!, response: "accept", completion: { (code) in
                if code == 200 {
                    self.items.remove(at: editActionsForRowAt.row)
                    tableView.deleteRows(at: [editActionsForRowAt], with: .automatic)
                }
                SVProgressHUD.dismiss()
            })
        }
        accept.backgroundColor = UIColor(patternImage: UIImage(named: "icon-yes")!)
        
        let delete = UITableViewRowAction(style: .normal, title: "") { action, index in
            SVProgressHUD.show()
            FService.sharedInstance.acceptJoinTeam(requestId: dataInfo.targetId!, response: "reject", completion: { (code) in
                if code == 200 {
                    self.items.remove(at: editActionsForRowAt.row)
                    tableView.deleteRows(at: [editActionsForRowAt], with: .automatic)
                }
                SVProgressHUD.dismiss()
            })
        }
        delete.backgroundColor = UIColor(patternImage: UIImage(named: "icon-no")!)
        
        if dataInfo.type == 1 {
            return [delete, accept]
        }
        else {
            return [delete]
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if !(cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        }
        
        let dataInfo: Notification = self.items[indexPath.row]
        cell!.textLabel?.text = dataInfo.title
        cell?.textLabel?.font = UIFont(name: "lato-bold", size: 16)
        
        cell?.detailTextLabel?.text = "\(dataInfo.message ?? "") \n\(self.formatDate(dateString: dataInfo.time ?? ""))"
        cell?.detailTextLabel?.font = UIFont(name: "lato-regular", size: 16)
        cell?.detailTextLabel?.textColor = UIColor.lightGray
        cell?.detailTextLabel?.numberOfLines = 0
        
        cell?.imageView?.image = UIImage(named: "Icon-mail")
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
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
