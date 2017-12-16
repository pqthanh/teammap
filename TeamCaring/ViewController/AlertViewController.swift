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
    var currentIndex = 0
    var loadMore = false
    
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
        
        self.tblAlert.addInfiniteScroll { (tableView) -> Void in
            tableView.finishInfiniteScroll()
            if self.loadMore {
                SVProgressHUD.show()
                FService.sharedInstance.getNotification(page: self.currentIndex) { (result) in
                    if result != nil {
                        if result?.count == 10 {
                            self.loadMore = true
                            self.currentIndex += 1
                        }
                        else {
                            self.loadMore = false
                        }
                        var indexPaths = [Any]()
                        let currentCount: Int = self.items.count
                        for i in 0..<(result?.count)! {
                            indexPaths.append(IndexPath(row: currentCount + i, section: 0))
                        }
                        // do the insertion
                        self.items += result!
                        // tell the table view to update (at all of the inserted index paths)
                        self.tblAlert.beginUpdates()
                        self.tblAlert.insertRows(at: indexPaths as? [IndexPath] ?? [IndexPath](), with: .top)
                        self.tblAlert.endUpdates()
                    }
                    SVProgressHUD.dismiss()
                }
            }
        }
        tblAlert.beginInfiniteScroll(true)
        
        self.navigationController?.tabBarItem.badgeValue = nil
    }
    
    func loadAlert() {
        SVProgressHUD.show()
        FService.sharedInstance.getNotification(page: 0) { (result) in
            if result != nil {
                if result?.count == 10 {
                    self.loadMore = true
                    self.currentIndex += 1
                }
                else {
                    self.loadMore = false
                }
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
        dateFormatter.dateFormat = "HH:mm dd/MM/yyyy"
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
        
        let currentCell = tableView.cellForRow(at: editActionsForRowAt)
        UIGraphicsBeginImageContext(CGSize(width: (currentCell?.frame.size.height)! - 10, height: (currentCell?.frame.size.height)!))
        UIImage(named: "icon-no")?.draw(in: CGRect(x: 0, y: 0, width: (currentCell?.frame.size.height)! - 10, height: (currentCell?.frame.size.height)!))
        let imageDelete = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        delete.backgroundColor = UIColor(patternImage: imageDelete!)
        
        if dataInfo.type == 1 {
            return [delete, accept]
        }
        else {
            return []
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:AlertTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AlertTableViewCellId") as! AlertTableViewCell!
        
        let dataInfo: Notification = self.items[indexPath.row]
        cell.title.text = dataInfo.title
        cell.time.text = self.formatDate(dateString: dataInfo.time ?? "")
        cell.message.text = dataInfo.message ?? ""
        return cell
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
