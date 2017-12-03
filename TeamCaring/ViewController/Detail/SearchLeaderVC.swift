//
//  SearchLeaderVC.swift
//  TeamCaring
//
//  Created by Phan Quoc Thanh on 11/30/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit

class SearchLeaderVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let cellReuseIdentifier = "CellSearchLeaderId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()
    }

    @IBAction func backAction() {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        print("searchText \(searchBar.text ?? "")")
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
        self.view.endEditing(true)
        
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Gửi yêu cầu tham gia đến Nhóm Trưởng", message: nil, preferredStyle: .actionSheet)
    
        let cancelActionButton = UIAlertAction(title: "Hủy", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: "Gửi Yêu Cầu", style: .default) { _ in
            print("Save")
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
