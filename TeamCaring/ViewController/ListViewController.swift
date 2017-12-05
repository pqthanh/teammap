//
//  FirstViewController.swift
//  TeamCaring
//
//  Created by PqThanh on 11/17/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var lbSearchKq: UILabel!
    
    let cellReuseIdentifier = "CellListId"
    var isViewDetail = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()
        
        let btnBack = self.navigationItem.leftBarButtonItem
        if isViewDetail {
            self.navigationItem.leftBarButtonItem = nil
        }
        else {
            self.navigationItem.leftBarButtonItem = btnBack
        }
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
        }
        else {
            self.lbSearchKq.text = "  Danh sách nhóm chung đang tham gia"
        }
        print("searchText \(searchBar.text ?? "")")
        if isViewDetail != false {
            FService.sharedInstance.searchNewTeam(query: searchBar.text!, page: 0, completion: { (listResults) in
                print("-----> \(listResults)")
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ListTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ListTableViewCell!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isViewDetail == false {
            self.performSegue(withIdentifier: "PushSearchLead", sender: nil)
        }
        else {
            self.performSegue(withIdentifier: "PushDetailTeam", sender: nil)
        }
    }
    
    func rightButtonTouched() {
        self.performSegue(withIdentifier: "Push2Alert", sender:nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushSearchLead" {
            let _:SearchLeaderVC = segue.destination as! SearchLeaderVC
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

