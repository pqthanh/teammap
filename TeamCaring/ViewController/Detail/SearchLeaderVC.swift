//
//  SearchLeaderVC.swift
//  TeamCaring
//
//  Created by Phan Quoc Thanh on 11/30/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit
import SVProgressHUD

class SearchLeaderVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let cellReuseIdentifier = "CellSearchLeaderId"
    var teamId = 0
    var listLeader = [Leader]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SVProgressHUD.setDefaultMaskType(.clear)
        
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()
    }

    @IBAction func backAction() {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)

        FService.sharedInstance.searchLeader(teamId: teamId, query: searchBar.text!, page: 0) { (listData) in
            if listData != nil {
                self.listLeader.removeAll()
                self.listLeader = listData!
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listLeader.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ListTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ListTableViewCell!
        
        let itemValue: Leader = self.listLeader[indexPath.row] as Leader
        cell.imgAvata.image = UIImage.image(fromURL: itemValue.imageUrl ?? "", placeholder: UIImage(named: "ic_profile")!, shouldCacheImage: true) { (image) in
            cell.imgAvata.image = nil
            cell.imgAvata.image = image
        }
        cell.level.text = "Cấp \(itemValue.numberAppointments ?? 0)"
        cell.name.text = itemValue.nickname ?? ""
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Gửi yêu cầu tham gia đến Nhóm Trưởng", message: nil, preferredStyle: .actionSheet)
    
        let cancelActionButton = UIAlertAction(title: "Hủy", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: "Gửi Yêu Cầu", style: .default) { _ in
            SVProgressHUD.show()
            let itemValue: Leader = self.listLeader[indexPath.row] as Leader
            FService.sharedInstance.joinTeam(teamId: self.teamId, leaderId: itemValue.userId!, completion: { (code) in
                var message = ""
                if code == 200 {
                    message = "Đã gửi yêu cầu tham gia đến nhóm trưởng thành công!"
                }
                else {
                    message = "Error code\(code ?? 0)"
                }
                SVProgressHUD.dismiss()
                
                let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Tiếp tục", style: .default, handler: { action in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            })
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
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
