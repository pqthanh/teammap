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
    
    @IBOutlet weak var imgLevel1: UIButton!
    @IBOutlet weak var imgLevel2: UIButton!
    @IBOutlet weak var imgLevel3: UIButton!
    
    @IBOutlet weak var lbLevel0: UILabel!
    @IBOutlet weak var lbLevel1: UILabel!
    @IBOutlet weak var lbLevel2: UILabel!
    @IBOutlet weak var lbLevel3: UILabel!
    
    @IBOutlet weak var imgNodeArrow0: UIImageView!
    @IBOutlet weak var imgNodeArrow1: UIImageView!
    @IBOutlet weak var imgNodeArrow2: UIImageView!
    
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
        self.avataLeader.layer.masksToBounds = true
        self.imgLevel1.layer.cornerRadius = 30
        self.imgLevel1.layer.masksToBounds = true
        self.imgLevel2.layer.cornerRadius = 30
        self.imgLevel2.layer.masksToBounds = true
        self.imgLevel3.layer.cornerRadius = 30
        self.imgLevel3.layer.masksToBounds = true
        
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
                    self.viewMota.backgroundColor = UIColor.clear
                }
                self.txtMota.text = info.extraGroupDescription
                
                self.lbLevel0.text = "\(info.level ?? 0)"
                self.iconTeam.setBackgroundImage(UIImage(named: "\(info.iconId ?? 1)"), for: .normal)
                self.avataLeader.setBackgroundImage(UIImage.image(fromURL: (Caring.userInfo?.avata!)!, placeholder: UIImage(named: "ic_profile")!, shouldCacheImage: true) { (image) in
                    self.avataLeader.setBackgroundImage(nil, for: .normal)
                    self.avataLeader.setBackgroundImage(image, for: .normal)
                }, for: .normal)
                
                if (info.members?.count)! > 0 {
                    if (info.members?.count)! == 1 {
                        self.imgNodeArrow2.isHidden = true
                        self.imgLevel2.isHidden = true
                        self.imgLevel3.isHidden = true
                        
                        let node0 = info.members![0]
                        self.imgLevel1.setBackgroundImage(UIImage.image(fromURL: node0.imageUrl!, placeholder: UIImage(named: "ic_profile")!, shouldCacheImage: true) { (image) in
                            self.imgLevel1.setBackgroundImage(nil, for: .normal)
                            self.imgLevel1.setBackgroundImage(image, for: .normal)
                        }, for: .normal)
                    }
                    else if (info.members?.count)! == 2 {
                        self.imgNodeArrow1.isHidden = true
                        self.imgLevel1.isHidden = true
                        
                        let node0 = info.members![0]
                        self.imgLevel2.setBackgroundImage(UIImage.image(fromURL: node0.imageUrl!, placeholder: UIImage(named: "ic_profile")!, shouldCacheImage: true) { (image) in
                            self.imgLevel2.setBackgroundImage(nil, for: .normal)
                            self.imgLevel2.setBackgroundImage(image, for: .normal)
                        }, for: .normal)
                        
                        let node1 = info.members![1]
                        self.imgLevel3.setBackgroundImage(UIImage.image(fromURL: node1.imageUrl!, placeholder: UIImage(named: "ic_profile")!, shouldCacheImage: true) { (image) in
                            self.imgLevel3.setBackgroundImage(nil, for: .normal)
                            self.imgLevel3.setBackgroundImage(image, for: .normal)
                        }, for: .normal)
                    }
                }
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
