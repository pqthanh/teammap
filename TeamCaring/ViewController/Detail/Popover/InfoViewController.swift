//
//  InfoViewController.swift
//  TeamCaring
//
//  Created by fwThanh on 12/2/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbContent: UITextView!
    var teamInfo: Team?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lbTitle.text = self.teamInfo?.name
        lbContent.text = self.teamInfo?.tdescription
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
