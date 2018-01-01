//
//  ListNhungCuocHenVC.swift
//  TeamCaring
//
//  Created by fwThanh on 12/27/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit

class DetailCuocHenVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let cellReuseIdentifier = "CuocHenCell"
    var listEvents = [Event]()
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listEvents.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CuocHenTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! CuocHenTableViewCell!
        let event = self.listEvents[indexPath.row]
        cell.imgAvata.image = UIImage.image(fromURL: event.imageUrl ?? "", placeholder: UIImage(named: "ic_profile")!, shouldCacheImage: true) { (image) in
            cell.imgAvata.image = nil
            cell.imgAvata.image = image
        }
        cell.lbDetail.text = event.name
        cell.lbDetail.text = self.formatDate(dateString: event.time ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        let event = self.listEvents[indexPath.row]
        self.performSegue(withIdentifier: "ChiTietHen", sender: event)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChiTietHen" {
            let event: Event = sender as! Event
            let detail: ChiTietCuocHenVC = segue.destination as! ChiTietCuocHenVC
            detail.currentEvent = event
        }
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
