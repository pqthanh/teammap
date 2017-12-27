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
    var listNotes = [Note]()
    
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
        
        if self.currentEvent != nil {
            self.tfNameEvent.text = self.currentEvent?.name
            self.txtMota.text = self.currentEvent?.eDescription
            self.tfThoigianhen.text = self.formatDate(dateString: (self.currentEvent?.time)!)
            if self.currentEvent?.repeatType == "one_week" {
                self.tfTypeEvent.text = "1 Tuần"
            }
            else if self.currentEvent?.repeatType == "two_week" {
                self.tfTypeEvent.text = "2 Tuần"
            }
            else if self.currentEvent?.repeatType == "one_month" {
                self.tfTypeEvent.text = "1 Tháng"
            }
            self.tfTeam.text = self.currentEvent?.team
            self.tfMember.text = self.currentEvent?.member
            
            self.listNotes = (self.currentEvent?.notes)!
        }
        
        if self.listNotes.count == 0 {
            self.heightTable.constant = CGFloat(50 * (self.listNotes.count + 1))
        }
    }
    
    func formatDate(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "HH:mm dd/MM/yyyy"
        let output = dateFormatter.string(from: date!)
        return output
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
        if indexPath.row == self.listNotes.count {
            self.performSegue(withIdentifier: "ChiTietGhiChu", sender: self.currentEvent?.id)
        }
        else {
            let info = self.listNotes[indexPath.row]
            self.performSegue(withIdentifier: "ChiTietGhiChu", sender: info)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChiTietGhiChu" {
            let detail: ChiTietGhiChuVC = segue.destination as! ChiTietGhiChuVC
            if let object = sender as? Int {
                detail.eventId = object
            }
            else {
                detail.currentNote = sender as? Note
            }
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
