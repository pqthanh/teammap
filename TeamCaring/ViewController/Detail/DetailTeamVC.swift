//
//  DetailTeamVC.swift
//  TeamCaring
//
//  Created by Phan Quoc Thanh on 11/30/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit
import SVProgressHUD

class DetailTeamVC: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var iconTeam: UIButton!
    @IBOutlet weak var avataLeader: UIButton!
    @IBOutlet weak var viewMota: UIView!
    
    @IBOutlet weak var lbLevel0: UILabel!
    @IBOutlet weak var lbLevel1: UILabel!
    @IBOutlet weak var lbLevel2: UILabel!
    @IBOutlet weak var lbLevel3: UILabel!
    
    @IBOutlet weak var lbTxtholder: UILabel!
    @IBOutlet weak var tfTenNhom: UITextField!
    @IBOutlet weak var txtMota: UITextView!
    @IBOutlet weak var tfSoluong: UITextField!
    
    var teamId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SVProgressHUD.setDefaultMaskType(.clear)
        
        self.iconTeam.layer.cornerRadius = 20
        self.avataLeader.layer.cornerRadius = 30
        
        self.viewMota.layer.cornerRadius = 4.0
        self.viewMota.layer.borderWidth = 1.0
        self.viewMota.layer.borderColor = UIColor(hexString: "#dadada").cgColor
        
        self.lbLevel0.layer.cornerRadius = 10.0
        self.lbLevel0.layer.masksToBounds = true
        self.lbLevel1.layer.cornerRadius = 10.0
        self.lbLevel1.layer.masksToBounds = true
        self.lbLevel2.layer.cornerRadius = 10.0
        self.lbLevel2.layer.masksToBounds = true
        self.lbLevel3.layer.cornerRadius = 10.0
        self.lbLevel3.layer.masksToBounds = true
        
        SVProgressHUD.show()
        FService.sharedInstance.getDetailTeam(idTeam: teamId) { (result) in
            if result != nil {
                let info: Member = result!
                self.tfTenNhom.text = info.extraGroupName
                self.tfSoluong.text = "\(info.extraGroupTotalMember ?? 0)"
                if (info.extraGroupDescription != nil) && info.extraGroupDescription != "" {
                    self.lbTxtholder.isHidden = true
                }
                self.txtMota.text = info.extraGroupDescription
            }
            SVProgressHUD.dismiss()
        }
    }

    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func infoAction(_ sender: AnyObject) {
        let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "InfoViewControllerId") as! InfoViewController
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = popoverContent.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: 240, height: 200)
        popover?.delegate = self
        popover?.sourceView = sender as? UIView
        popover?.sourceRect = sender.bounds
        self.present(popoverContent, animated: true, completion: nil)
    }
    
    @IBAction func detailMemberAction(_ sender: AnyObject) {
        let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "ListMemberTreeVCId") as! ListMemberTreeVC
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
        popoverContent.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        let popover = popoverContent.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: self.view.frame.size.width, height: 95)
        popover?.delegate = self
        popover?.sourceView = sender as? UIView
        popover?.sourceRect = sender.bounds
        self.present(popoverContent, animated: true, completion: nil)
    }
    
    @IBAction func detailAction() {
        self.performSegue(withIdentifier: "PushDetailMember", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushDetailMember" {
            let _:TTThanhVienVC = segue.destination as! TTThanhVienVC
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
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
