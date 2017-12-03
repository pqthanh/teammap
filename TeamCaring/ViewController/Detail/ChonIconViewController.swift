//
//  ChonIconViewController.swift
//  TeamCaring
//
//  Created by fwThanh on 11/29/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit

class ChonIconViewController: UIViewController {

    var completionBlock: ((Int) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectIcon(_ sender: UIButton?) {
        if let completionBlock = self.completionBlock {
            completionBlock(sender?.tag ?? 0);
        }
        self.navigationController?.popViewController(animated: true)
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
