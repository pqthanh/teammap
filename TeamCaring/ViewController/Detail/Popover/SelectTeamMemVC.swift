//
//  SelectTeamMemVC.swift
//  TeamCaring
//
//  Created by Phan Quoc Thanh on 12/5/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit
import SVProgressHUD
import UIScrollView_InfiniteScroll
import ESPullToRefresh

class SelectTeamMemVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    
    let cellReuseIdentifier = "SelectTeamMemCellId"
    var listMyTeams = [Team]()
    var listMembers = [Leader]()
    var currentIndex = 0
    var loadMore = false
    var indexSelected = IndexPath()
    var isMember = false
    var teamId: Int = 0
    var selectedBlock: ((Team, IndexPath) -> Void)? = nil
    var selectedMemberBlock: ((Leader, IndexPath) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissView))
        tap.cancelsTouchesInView = false
        self.mainView.addGestureRecognizer(tap)
        
        if isMember {
            lbTitle.text = "Chọn thành viên"
            FService.sharedInstance.searchMember(teamId: self.teamId, query: "*", page: 0) { (listResults) in
                if listResults != nil {
                    if listResults?.count == 10 {
                        self.loadMore = true
                        self.currentIndex += 1
                    }
                    else {
                        self.loadMore = false
                    }
                    self.listMembers.removeAll()
                    self.listMembers = listResults!
                    self.tableView.reloadData()
                }
            }
        }
        else {
            lbTitle.text = "Chọn nhóm"
            FService.sharedInstance.searchMyTeam(query: "*", page: 0, completion: { (listResults) in
                if listResults != nil {
                    if listResults?.count == 10 {
                        self.loadMore = true
                        self.currentIndex += 1
                    }
                    else {
                        self.loadMore = false
                    }
                    self.listMyTeams.removeAll()
                    self.listMyTeams = listResults!
                    self.tableView.reloadData()
                }
            })
        }
        
        self.tableView.addInfiniteScroll { (tableView) -> Void in
            tableView.finishInfiniteScroll()
            if self.loadMore {
                FService.sharedInstance.searchMyTeam(query: "*", page: self.currentIndex, completion: { (listResults) in
                    self.loadMore(listItems: listResults)
                })
            }
        }
        tableView.beginInfiniteScroll(true)
    }

    func loadMore(listItems: [Team]?) {
        if listItems != nil {
            if listItems?.count == 10 {
                self.loadMore = true
                self.currentIndex += 1
            }
            else {
                self.loadMore = false
            }
            var indexPaths = [Any]()
            let currentCount: Int = self.listMyTeams.count
            for i in 0..<(listItems?.count)! {
                indexPaths.append(IndexPath(row: currentCount + i, section: 0))
            }
            // do the insertion
            self.listMyTeams += listItems!
            // tell the table view to update (at all of the inserted index paths)
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: indexPaths as? [IndexPath] ?? [IndexPath](), with: .top)
            self.tableView.endUpdates()
        }
    }
    
    func dismissView() {
        self.selectedActionTeam()
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func cancelAction() {
        self.dismiss(animated: false, completion: nil)
    }
    
    func selectedActionTeam() {
        if isMember && self.listMembers.count > 0 {
            if let selectedMemberBlock = self.selectedMemberBlock {
                let memInfo: Leader = self.listMembers[self.indexSelected.row] as Leader
                selectedMemberBlock(memInfo, self.indexSelected)
            }
        }
        else if self.listMyTeams.count > 0 {
            if let selectedBlock = self.selectedBlock {
                let teamInfo: Team = self.listMyTeams[self.indexSelected.row] as Team
                selectedBlock(teamInfo, self.indexSelected)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isMember ? self.listMembers.count : self.listMyTeams.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SelectTeamMemCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! SelectTeamMemCell!
        if isMember {
            let teamInfo: Leader = self.listMembers[indexPath.row] as Leader
            cell.avata.image = UIImage.image(fromURL: teamInfo.imageUrl ?? "", placeholder: UIImage(named: "ic_profile")!, shouldCacheImage: true) { (image) in
                cell.avata.image = nil
                cell.avata.image = image
            }
            cell.name.text = teamInfo.nickname
            if self.indexSelected == indexPath {
                cell.select.image = UIImage(named: "icon-checked")
            }
            else {
                cell.select.image = UIImage(named: "Icon-unchecked")
            }
        }
        else {
            let teamInfo: Team = self.listMyTeams[indexPath.row] as Team
            cell.avata.image = UIImage(named: "\(teamInfo.iconId ?? 1)")
            cell.name.text = teamInfo.name
            if self.indexSelected == indexPath {
                cell.select.image = UIImage(named: "icon-checked")
            }
            else {
                cell.select.image = UIImage(named: "Icon-unchecked")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.indexSelected = indexPath
        tableView.reloadData()
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
