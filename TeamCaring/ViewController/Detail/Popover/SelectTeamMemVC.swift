//
//  SelectTeamMemVC.swift
//  TeamCaring
//
//  Created by Phan Quoc Thanh on 12/5/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit

class SelectTeamMemVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var mainView: UIView!
    
    let cellReuseIdentifier = "SelectTeamMemCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissView))
        tap.cancelsTouchesInView = false
        self.mainView.addGestureRecognizer(tap)
    }

    func dismissView() {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func cancelAction() {
        self.dismiss(animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SelectTeamMemCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! SelectTeamMemCell!
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
