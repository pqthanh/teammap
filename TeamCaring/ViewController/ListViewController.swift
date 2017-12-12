//
//  FirstViewController.swift
//  TeamCaring
//
//  Created by PqThanh on 11/17/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit
import SVProgressHUD
import UIScrollView_InfiniteScroll
import ESPullToRefresh

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var lbSearchKq: UILabel!
    
    let cellReuseIdentifier = "CellListId"
    var isViewDetail = true
    var listMyTeams = [Team]()
    var currentIndex = 0
    var loadMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        SVProgressHUD.setDefaultMaskType(.clear)
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()
        
        self.getListMyTeams()
        
        self.tableView.es.addPullToRefresh {
            [unowned self] in
            self.tableView.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: true)
            self.getListMyTeams()
        }
        
        self.tableView.addInfiniteScroll { (tableView) -> Void in
            tableView.finishInfiniteScroll()
            
            if self.searchBar.text != "" {
                if self.loadMore {
                    SVProgressHUD.show()
                    FService.sharedInstance.searchMyTeam(query: self.searchBar.text!, page: self.currentIndex, completion: { (listResults) in
                        self.loadMore(listItems: listResults)
                        SVProgressHUD.dismiss()
                    })
                }
            }
            else {
                if self.loadMore {
                    SVProgressHUD.show()
                    FService.sharedInstance.getMyTeams(page: self.currentIndex) { (listTeams, totalPage) in
                        self.loadMore(listItems: listTeams)
                        SVProgressHUD.dismiss()
                    }
                }
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
    
    func getListMyTeams() {
        SVProgressHUD.show()
        FService.sharedInstance.searchMyTeam(query: "*", page: 0, completion: { (listResults) in
            if listResults != nil {
                self.listMyTeams.removeAll()
                self.listMyTeams = listResults!
                self.tableView.reloadData()
            }
            self.currentIndex = 0
            SVProgressHUD.dismiss()
        })
//        FService.sharedInstance.getMyTeams(page: 0) { (listTeams, totalPage) in
//            if listTeams != nil {
//                if totalPage == 10 {
//                    self.loadMore = true
//                    self.currentIndex += 1
//                }
//                else {
//                    self.loadMore = false
//                }
//                self.listMyTeams.removeAll()
//                self.listMyTeams = listTeams!
//                self.tableView.reloadData()
//            }
//            SVProgressHUD.dismiss()
//        }
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
            FService.sharedInstance.searchMyTeam(query: searchBar.text!, page: 0, completion: { (listResults) in
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
                else {
                    self.listMyTeams.removeAll()
                    self.tableView.reloadData()
                }
                SVProgressHUD.dismiss()
            })
        }
        else {
            self.lbSearchKq.text = "  Danh sách nhóm chung đang tham gia"
            self.getListMyTeams()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listMyTeams.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ListTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ListTableViewCell!
        let teamInfo: Team = self.listMyTeams[indexPath.row] as Team
        cell.imgAvata.image = UIImage(named: "\(teamInfo.iconId ?? 1)")
        cell.name.text = teamInfo.name
        cell.level.text = "\(teamInfo.level ?? 1) Cấp"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let teamInfo: Team = self.listMyTeams[indexPath.row] as Team
        self.performSegue(withIdentifier: "PushDetailTeam", sender: teamInfo.id)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func rightButtonTouched() {
        self.performSegue(withIdentifier: "Push2Alert", sender:nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushSearchLead" {
            let _:SearchLeaderVC = segue.destination as! SearchLeaderVC
        }
        else if segue.identifier == "PushDetailTeam" {
            let detail: DetailTeamVC = segue.destination as! DetailTeamVC
            detail.teamId = sender as! Int
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

