//
//  SelectTeamVC.swift
//  TeamCaring
//
//  Created by fwThanh on 11/28/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit

class SelectTeamVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            let listTeam: ListViewController = segue.destination as! ListViewController
            listTeam.isViewDetail = false
        }
    }

}
