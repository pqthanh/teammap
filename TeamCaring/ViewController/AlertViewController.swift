//
//  AlertViewController.swift
//  TeamCaring
//
//  Created by PqThanh on 11/20/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblAlert: UITableView!
    var items = ["Yêu cầu gia nhập 1", "Yêu cầu gia nhập 2", "Yêu cầu gia nhập 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tblAlert.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let accept = UITableViewRowAction(style: .normal, title: "") { action, index in
            print("Đồng ý")
        }
        accept.backgroundColor = UIColor(patternImage: UIImage(named: "icon-yes")!)
        
        let delete = UITableViewRowAction(style: .normal, title: "") { action, index in
            print("Huỷ bỏ")
            self.items.remove(at: editActionsForRowAt.row)
            tableView.deleteRows(at: [editActionsForRowAt], with: .automatic)
        }
        delete.backgroundColor = UIColor(patternImage: UIImage(named: "icon-no")!)
        
        return [delete, accept]
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
        cell!.textLabel?.text = self.items[indexPath.row]
        cell?.textLabel?.font = UIFont(name: "lato-bold", size: 16)
        
        cell?.detailTextLabel?.text = "Aaron Hotchner muốn tham gia nhóm"
        cell?.detailTextLabel?.font = UIFont(name: "lato-regular", size: 16)
        cell?.detailTextLabel?.textColor = UIColor.lightGray
        
        cell?.imageView?.image = UIImage(named: "Icon-mail")
        
        return cell!
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
