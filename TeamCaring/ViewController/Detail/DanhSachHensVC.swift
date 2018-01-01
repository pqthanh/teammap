//
//  DanhSachHensVC.swift
//  TeamCaring
//
//  Created by Phan Quoc Thanh on 12/5/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit
import UIScrollView_InfiniteScroll
import SVProgressHUD

class DanhSachHensVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let cellReuseIdentifier = "CellSearchLeaderId"
    var listAppointments = [Appointment]()
    var currentIndex = 0
    var loadMore = false
    var teamId = 0
    var memberId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()
        
        self.loadAppointments()
        
        self.tableView.addInfiniteScroll { (tableView) -> Void in
            tableView.finishInfiniteScroll()
            if self.loadMore {
                SVProgressHUD.show()
                FService.sharedInstance.getMemberAppointments(teamId: self.teamId, memberId: self.memberId, page: self.currentIndex) { (result) in
                    if result != nil {
                        if result?.count == 10 {
                            self.loadMore = true
                            self.currentIndex += 1
                        }
                        else {
                            self.loadMore = false
                        }
                        var indexPaths = [Any]()
                        let currentCount: Int = self.listAppointments.count
                        for i in 0..<(result?.count)! {
                            indexPaths.append(IndexPath(row: currentCount + i, section: 0))
                        }
                        // do the insertion
                        self.listAppointments += result!
                        // tell the table view to update (at all of the inserted index paths)
                        self.tableView.beginUpdates()
                        self.tableView.insertRows(at: indexPaths as? [IndexPath] ?? [IndexPath](), with: .top)
                        self.tableView.endUpdates()
                    }
                    SVProgressHUD.dismiss()
                }
            }
        }
        tableView.beginInfiniteScroll(true)
    }

    func loadAppointments() {
        SVProgressHUD.show()
        FService.sharedInstance.getMemberAppointments(teamId: self.teamId, memberId: self.memberId, page: self.currentIndex) { (result) in
            if result != nil {
                if result?.count == 10 {
                    self.loadMore = true
                    self.currentIndex += 1
                }
                else {
                    self.loadMore = false
                }
                self.listAppointments.removeAll()
                self.listAppointments = result!
                self.tableView.reloadData()
            }
            SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func backAction() {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listAppointments.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ListTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ListTableViewCell!
        let appointment = self.listAppointments[indexPath.row]
        cell.imgAvata.image = UIImage.image(fromURL: appointment.user?.imageUrl ?? "", placeholder: UIImage(named: "ic_profile")!, shouldCacheImage: true) { (image) in
            cell.imgAvata.image = nil
            cell.imgAvata.image = image
        }
        cell.name.text = appointment.user?.nickname
        cell.level.text = "\(appointment.list?.count ?? 0) Lần"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        let appointment = self.listAppointments[indexPath.row]
        self.performSegue(withIdentifier: "DetailCuocHen", sender: appointment.list)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailCuocHen" {
            let events: [Event] = sender as! [Event]
            let detail: DetailCuocHenVC = segue.destination as! DetailCuocHenVC
            detail.listEvents = events
        }
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
