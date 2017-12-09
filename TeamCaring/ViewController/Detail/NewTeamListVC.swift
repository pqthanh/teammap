//
//  NewTeamListVC.swift
//  TeamCaring
//
//  Created by Phan Quoc Thanh on 12/6/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit
import SVProgressHUD
import UIScrollView_InfiniteScroll

class NewTeamListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var lbSearchKq: UILabel!
    
    var isViewDetail = true
    var listNewTeams = [Team]()
    var currentIndex = 0
    var loadMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        SVProgressHUD.setDefaultMaskType(.clear)
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()
        
        self.tableView.addInfiniteScroll { (tableView) -> Void in
            tableView.finishInfiniteScroll()
            if self.loadMore {
                SVProgressHUD.show()
                FService.sharedInstance.searchNewTeam(query: self.searchBar.text!, page: self.currentIndex, completion: { (listTeams) in
                    if listTeams != nil {
                        if listTeams?.count == 10 {
                            self.loadMore = true
                            self.currentIndex += 1
                        }
                        else {
                            self.loadMore = false
                        }
                        var indexPaths = [Any]()
                        let currentCount: Int = self.listNewTeams.count
                        for i in 0..<(listTeams?.count)! {
                            indexPaths.append(IndexPath(row: currentCount + i, section: 0))
                        }
                        // do the insertion
                        self.listNewTeams += listTeams!
                        // tell the table view to update (at all of the inserted index paths)
                        self.tableView.beginUpdates()
                        self.tableView.insertRows(at: indexPaths as? [IndexPath] ?? [IndexPath](), with: .top)
                        self.tableView.endUpdates()
                    }
                    SVProgressHUD.dismiss()
                })
            }
        }
        tableView.beginInfiniteScroll(true)
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text != "" {
            self.lbSearchKq.text = "  Kết quả tìm kiếm"
        }
        else {
            self.lbSearchKq.text = "  Danh sách nhóm chung đang tham gia"
        }
        //searchAutocompleteEntriesWithSubstring(substring: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        
        if searchBar.text != "" {
            self.lbSearchKq.text = "  Kết quả tìm kiếm"
            SVProgressHUD.show()
            FService.sharedInstance.searchNewTeam(query: searchBar.text!, page: 0, completion: { (listResults) in
                if listResults != nil {
                    if listResults?.count == 10 {
                        self.loadMore = true
                        self.currentIndex += 1
                    }
                    else {
                        self.loadMore = false
                    }
                    self.listNewTeams.removeAll()
                    self.listNewTeams = listResults!
                    self.tableView.reloadData()
                }
                SVProgressHUD.dismiss()
            })
        }
        else {
            self.lbSearchKq.text = "  Danh sách nhóm chung đang tham gia"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listNewTeams.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CellNewTeamId") as! ListTableViewCell!
        let teamInfo: Team = self.listNewTeams[indexPath.row] as Team
        cell.imgAvata.image = UIImage(named: "\(teamInfo.iconId ?? 1)")
        cell.name.text = teamInfo.name
        cell.level.text = "\(teamInfo.level ?? 1) Cấp"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let teamInfo: Team = self.listNewTeams[indexPath.row] as Team
        self.performSegue(withIdentifier: "PushSearchLead", sender: teamInfo.id)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func rightButtonTouched() {
        self.performSegue(withIdentifier: "Push2Alert", sender:nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushSearchLead" {
            let teamId = sender as! Int
            let searchLeader: SearchLeaderVC = segue.destination as! SearchLeaderVC
            searchLeader.teamId = teamId
        }
        else if segue.identifier == "PushDetailTeam" {
            let _:DetailTeamVC = segue.destination as! DetailTeamVC
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
