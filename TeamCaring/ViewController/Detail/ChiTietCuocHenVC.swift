//
//  ChiTietCuocHenVC.swift
//  TeamCaring
//
//  Created by Phan Quoc Thanh on 12/26/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit

class ChiTietCuocHenVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewMota: UIView!
    @IBOutlet weak var lbTxtholder: UILabel!
    @IBOutlet weak var txtMota: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tfNameEvent: UITextField!
    @IBOutlet weak var tfThoigianhen: UITextField!
    @IBOutlet weak var tfTypeEvent: UITextField!
    @IBOutlet weak var btnCalendar: UIButton!
    @IBOutlet weak var tfTeam: UITextField!
    @IBOutlet weak var tfMember: UITextField!
    @IBOutlet weak var heightTable: NSLayoutConstraint!
    
    let cellReuseIdentifier = "CellId"
    var currentEvent: Event?
    var listNotes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()
        
        self.viewMota.layer.cornerRadius = 4.0
        self.viewMota.layer.borderWidth = 1.0
        self.viewMota.layer.borderColor = UIColor(hexString: "#dadada").cgColor
        self.lbTxtholder.text = ""
        
        self.tfNameEvent.text = self.currentEvent?.name
        self.txtMota.text = self.currentEvent?.eDescription
        
        if self.listNotes.count == 0 {
            self.heightTable.constant = CGFloat(50 * (self.listNotes.count + 1))
        }
    }

    @IBAction func backAction() {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listNotes.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ChiTietCuocHenVCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ChiTietCuocHenVCell!
        if indexPath.row == self.listNotes.count {
            cell.wImgAvata.constant = 20
            cell.imgAvata.image = UIImage(named: "Plus")
            cell.lbTitle.text = "Thêm Ghi Chú"
        }
        else {
            cell.wImgAvata.constant = 30
            cell.imgAvata.image = UIImage(named: "smallAvt")
            cell.lbTitle.text = "Tên Cuộc Hẹn"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
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
