//
//  SelectTeamVC.swift
//  TeamCaring
//
//  Created by fwThanh on 11/28/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit

class SelectTeamVC: UIViewController {

    var isFirstLoad: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if isFirstLoad == true {
            self.title = "Khởi Đầu"
        }
        else {
            self.title = "Tham Gia Nhóm"
        }
    }

    @IBAction func backAction() {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func taoNhomAction() {
        self.performSegue(withIdentifier: "PushTaoNhom", sender: nil)
    }
    
    @IBAction func searchNhomAction() {
        self.performSegue(withIdentifier: "PushListTeam", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushTaoNhom" {
            let _: CreateNewTeamVC = segue.destination as! CreateNewTeamVC
        }
        else if segue.identifier == "PushListTeam" {
            let listTeam: NewTeamListVC = segue.destination as! NewTeamListVC
            listTeam.isViewDetail = false
        }
    }

}
