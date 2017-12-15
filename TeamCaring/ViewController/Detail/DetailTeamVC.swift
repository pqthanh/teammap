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
    
    @IBOutlet weak var imgStart1: UIImageView!
    @IBOutlet weak var imgStart2: UIImageView!
    @IBOutlet weak var imgStart3: UIImageView!
    
    @IBOutlet weak var imgNodeArrow0: UIImageView!
    @IBOutlet weak var imgNodeArrow1: UIImageView!
    @IBOutlet weak var imgNodeArrow2: UIImageView!
    
    @IBOutlet weak var lbTxtholder: UILabel!
    @IBOutlet weak var tfTenNhom: UITextField!
    @IBOutlet weak var txtMota: UITextView!
    @IBOutlet weak var tfSoluong: UITextField!
    
    @IBOutlet weak var topTeamNd: NSLayoutConstraint!
    
    var teamId = 0
    var memberList = [Member]()
    var currentList = [Member]()
    var currentListNode4_5  = [Member]()
    var currentListNode6_7  = [Member]()
    var currentListNode8_9  = [Member]()
    var currentListNodeMax   = [Member]()
    var currentLeader: Member?
    
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
        FService.sharedInstance.getDetailTeam(idTeam: teamId) { (team, members) in
            if team != nil && members != nil {
                self.memberList = members!
                self.currentList = members!
                let teamInfo: Team = team!
                self.setInfoTeam(teamInfo: teamInfo)
                self.iconTeam.setBackgroundImage(UIImage(named: "\(teamInfo.iconId ?? 1)"), for: .normal)
                self.currentLeader = nil
                self.setLeaderTree(avata: (Caring.userInfo?.avata ?? "")!, id: Int(Caring.userInfo?.currentUserId ?? "0")!, teamLevel: teamInfo.memberLevel ?? 0)
                self.showTreeMapWithData(members: members!)
            }
            SVProgressHUD.dismiss()
        }
    }

    func setInfoTeam(teamInfo: Team) {
        self.tfTenNhom.text = teamInfo.extraGroupName
        self.tfSoluong.text = "\(teamInfo.extraGroupTotalMember ?? 0)"
        if (teamInfo.extraGroupDescription != nil) && teamInfo.extraGroupDescription != "" {
            self.lbTxtholder.isHidden = true
            self.viewMota.backgroundColor = UIColor.clear
        }
        self.txtMota.text = teamInfo.extraGroupDescription
    }
    
    func setLeaderTree(avata: String, id: Int, teamLevel: Int) {
        self.avataLeader.setBackgroundImage(UIImage.image(fromURL: avata, placeholder: UIImage(named: "ic_profile")!, shouldCacheImage: true) { (image) in
            self.avataLeader.setBackgroundImage(nil, for: .normal)
            self.avataLeader.setBackgroundImage(image, for: .normal)
        }, for: .normal)
        self.lbLevel0.text = "\(teamLevel)"
    }
    
    func showTreeMapWithData(members: [Member]) {
        if (members.count) > 0 {
            self.topTeamNd.constant = 40
            if (members.count) == 1 {
                self.hideItemWhen1Node()
                self.showItemWhen1Node()
                let node0 = members[0]
                self.setData1Node(data: node0)
            }
            else if (members.count) == 2 {
                self.hideItemWhen2Node()
                self.showItemWhen2Node()
                let node0 = members[0]
                let node1 = members[1]
                self.setData2Node(data1: node0, data2: node1)
            }
            else if (members.count) == 3 {
                self.showItemWhen1Node()
                self.showItemWhen2Node()
                let node0 = members[0]
                let node1 = members[1]
                let node2 = members[2]
                self.setData3Node(data1: node0, data2: node1, data3: node2)
            }
            else if (members.count) == 4 {
                self.showItemWhen1Node()
                self.showItemWhen2Node()
                let node0 = members[0]
                let node1 = members[1]
                let node2 = members[2]
                let node3 = members[3]
                self.setData4_5Node(data1: node0, data2: node1, data3: [node2, node3])
            }
            else if (members.count) == 5 {
                self.showItemWhen1Node()
                self.showItemWhen2Node()
                let node0 = members[0]
                let node1 = members[1]
                let node2 = members[2]
                let node3 = members[3]
                let node4 = members[4]
                self.setData4_5Node(data1: node0, data2: node1, data3: [node2, node3, node4])
            }
            else if (members.count) == 6 {
                self.showItemWhen1Node()
                self.showItemWhen2Node()
                let node0 = members[0]
                let node1 = members[1]
                let node2 = members[2]
                let node3 = members[3]
                let node4 = members[4]
                let node5 = members[5]
                self.setData6_7Node(data1: node0, data2: [node1, node2], data3: [node3, node4, node5])
            }
            else if (members.count) == 7 {
                self.showItemWhen1Node()
                self.showItemWhen2Node()
                let node0 = members[0]
                let node1 = members[1]
                let node2 = members[2]
                let node3 = members[3]
                let node4 = members[4]
                let node5 = members[5]
                let node6 = members[6]
                self.setData6_7Node(data1: node0, data2: [node1, node2, node3], data3: [node4, node5, node6])
            }
            else if (members.count) == 8 {
                self.showItemWhen1Node()
                self.showItemWhen2Node()
                let node0 = members[0]
                let node1 = members[1]
                let node2 = members[2]
                let node3 = members[3]
                let node4 = members[4]
                let node5 = members[5]
                let node6 = members[6]
                let node7 = members[7]
                self.setData8_9Node(data1: [node0, node1], data2: [node2, node3, node4], data3: [node5, node6, node7])
            }
            else if (members.count) == 9 {
                self.showItemWhen1Node()
                self.showItemWhen2Node()
                let node0 = members[0]
                let node1 = members[1]
                let node2 = members[2]
                let node3 = members[3]
                let node4 = members[4]
                let node5 = members[5]
                let node6 = members[6]
                let node7 = members[7]
                let node8 = members[8]
                self.setData8_9Node(data1: [node0, node1, node2], data2: [node3, node4, node5], data3: [node6, node7, node8])
            }
            else if (members.count) >= 10 {
                self.setDataMax(data: members)
            }
        }
        else {
            self.topTeamNd.constant = -80
            self.hideItemWhen1Node()
            self.hideItemWhen2Node()
        }
        self.currentList.removeAll()
        self.currentList = members
    }
    
    func setGroupData3() {
        self.imgLevel3.setBackgroundImage(nil, for: .normal)
        self.imgLevel3.setTitle("2", for: .normal)
    }
    
    func setData1Node(data: Member) {
        self.imgLevel1.setBackgroundImage(UIImage.image(fromURL: data.imageUrl!, placeholder: UIImage(named: "ic_profile")!, shouldCacheImage: true) { (image) in
            self.imgLevel1.setBackgroundImage(nil, for: .normal)
            self.imgLevel1.setBackgroundImage(image, for: .normal)
        }, for: .normal)
        self.imgLevel1.setTitle("", for: .normal)
        self.imgLevel1.tag = 0
    }
    
    func setData2Node(data1: Member, data2: Member) {
        self.imgLevel2.setBackgroundImage(UIImage.image(fromURL: data1.imageUrl!, placeholder: UIImage(named: "ic_profile")!, shouldCacheImage: true) { (image) in
            self.imgLevel2.setBackgroundImage(nil, for: .normal)
            self.imgLevel2.setBackgroundImage(image, for: .normal)
        }, for: .normal)
        self.imgLevel2.setTitle("", for: .normal)
        self.imgLevel2.tag = 0
        
        self.imgLevel3.setBackgroundImage(UIImage.image(fromURL: data2.imageUrl!, placeholder: UIImage(named: "ic_profile")!, shouldCacheImage: true) { (image) in
            self.imgLevel3.setBackgroundImage(nil, for: .normal)
            self.imgLevel3.setBackgroundImage(image, for: .normal)
        }, for: .normal)
        self.imgLevel3.setTitle("", for: .normal)
        self.imgLevel3.tag = 1
    }
    
    func setData3Node(data1: Member, data2: Member, data3: Member) {
        self.imgLevel1.setBackgroundImage(UIImage.image(fromURL: data1.imageUrl!, placeholder: UIImage(named: "ic_profile")!, shouldCacheImage: true) { (image) in
            self.imgLevel1.setBackgroundImage(nil, for: .normal)
            self.imgLevel1.setBackgroundImage(image, for: .normal)
        }, for: .normal)
        self.imgLevel1.setTitle("", for: .normal)
        self.imgLevel1.tag = 0
        
        self.imgLevel2.setBackgroundImage(UIImage.image(fromURL: data2.imageUrl!, placeholder: UIImage(named: "ic_profile")!, shouldCacheImage: true) { (image) in
            self.imgLevel2.setBackgroundImage(nil, for: .normal)
            self.imgLevel2.setBackgroundImage(image, for: .normal)
        }, for: .normal)
        self.imgLevel2.setTitle("", for: .normal)
        self.imgLevel2.tag = 1
        
        self.imgLevel3.setBackgroundImage(UIImage.image(fromURL: data3.imageUrl!, placeholder: UIImage(named: "ic_profile")!, shouldCacheImage: true) { (image) in
            self.imgLevel3.setBackgroundImage(nil, for: .normal)
            self.imgLevel3.setBackgroundImage(image, for: .normal)
        }, for: .normal)
        self.imgLevel3.setTitle("", for: .normal)
        self.imgLevel3.tag = 2
    }
    
    func setData4_5Node(data1: Member, data2: Member, data3: [Member]) {
        self.imgLevel1.setBackgroundImage(UIImage.image(fromURL: data1.imageUrl!, placeholder: UIImage(named: "ic_profile")!, shouldCacheImage: true) { (image) in
            self.imgLevel1.setBackgroundImage(nil, for: .normal)
            self.imgLevel1.setBackgroundImage(image, for: .normal)
        }, for: .normal)
        self.imgLevel1.setTitle("", for: .normal)
        self.imgLevel1.tag = 0
        
        self.imgLevel2.setBackgroundImage(UIImage.image(fromURL: data2.imageUrl!, placeholder: UIImage(named: "ic_profile")!, shouldCacheImage: true) { (image) in
            self.imgLevel2.setBackgroundImage(nil, for: .normal)
            self.imgLevel2.setBackgroundImage(image, for: .normal)
        }, for: .normal)
        self.imgLevel2.setTitle("", for: .normal)
        self.imgLevel2.tag = 1
        
        self.imgLevel3.setBackgroundImage(nil, for: .normal)
        self.imgLevel3.setTitle("\(data3.count)", for: .normal)
        
        self.imgStart3.isHidden = true
        self.lbLevel3.isHidden = true
        
        self.imgLevel3.tag = data3.count + 1
        self.currentListNode4_5.removeAll()
        self.currentListNode4_5 = data3
    }
    
    func setData6_7Node(data1: Member, data2: [Member], data3: [Member]) {
        self.imgLevel1.setBackgroundImage(nil, for: .normal)
        self.imgLevel1.setTitle("\(data2.count)", for: .normal)
        self.imgStart1.isHidden = true
        self.lbLevel1.isHidden = true
        self.imgLevel1.tag = data2.count + 1
        
        self.imgLevel2.setBackgroundImage(UIImage.image(fromURL: data1.imageUrl!, placeholder: UIImage(named: "ic_profile")!, shouldCacheImage: true) { (image) in
            self.imgLevel2.setBackgroundImage(nil, for: .normal)
            self.imgLevel2.setBackgroundImage(image, for: .normal)
        }, for: .normal)
        self.imgLevel2.setTitle("", for: .normal)
        self.imgLevel2.tag = 0
        
        self.imgLevel3.setBackgroundImage(nil, for: .normal)
        self.imgLevel3.setTitle("\(data3.count)", for: .normal)
        self.imgStart3.isHidden = true
        self.lbLevel3.isHidden = true
        self.imgLevel3.tag = data2.count + 1 + data3.count + 1
        
        self.currentListNode4_5.removeAll()
        self.currentListNode4_5 = data2
        
        self.currentListNode6_7.removeAll()
        self.currentListNode6_7 = data3
    }
    
    func setData8_9Node(data1: [Member], data2: [Member], data3: [Member]) {
        self.imgLevel2.setBackgroundImage(nil, for: .normal)
        self.imgLevel2.setTitle("\(data1.count)", for: .normal)
        self.imgStart2.isHidden = true
        self.lbLevel2.isHidden = true
        self.imgLevel2.tag = data1.count + 1
        
        self.imgLevel1.setBackgroundImage(nil, for: .normal)
        self.imgLevel1.setTitle("\(data2.count)", for: .normal)
        self.imgStart1.isHidden = true
        self.lbLevel1.isHidden = true
        self.imgLevel1.tag = data1.count + 1 + data2.count + 1
        
        self.imgLevel3.setBackgroundImage(nil, for: .normal)
        self.imgLevel3.setTitle("\(data3.count)", for: .normal)
        self.imgStart3.isHidden = true
        self.lbLevel3.isHidden = true
        self.imgLevel3.tag = data1.count + 1 + data2.count + 1 + data3.count + 1
        
        self.currentListNode4_5.removeAll()
        self.currentListNode4_5 = data1
        
        self.currentListNode6_7.removeAll()
        self.currentListNode6_7 = data2
        
        self.currentListNode8_9.removeAll()
        self.currentListNode8_9 = data3
    }
    
    func setDataMax(data: [Member]) {
        self.hideItemWhen1Node()
        self.imgLevel1.setBackgroundImage(nil, for: .normal)
        self.imgLevel1.setTitle("\(data.count)", for: .normal)
        self.imgStart1.isHidden = true
        self.lbLevel1.isHidden = true
        self.imgLevel1.tag = data.count + 3
        
        self.currentListNodeMax.removeAll()
        self.currentListNodeMax = data
    }
    
    func hideItemWhen1Node() {
        self.imgNodeArrow2.isHidden = true
        self.imgLevel2.isHidden = true
        self.imgLevel3.isHidden = true
        self.lbLevel2.isHidden = true
        self.lbLevel3.isHidden = true
        self.imgStart2.isHidden = true
        self.imgStart3.isHidden = true
    }
    
    func hideItemWhen2Node() {
        self.imgNodeArrow1.isHidden = true
        self.imgLevel1.isHidden = true
        self.lbLevel1.isHidden = true
        self.imgStart1.isHidden = true
    }
    
    func showItemWhen1Node() {
        self.imgNodeArrow1.isHidden = false
        self.imgLevel1.isHidden = false
        self.lbLevel1.isHidden = false
        self.imgStart1.isHidden = false
    }
    
    func showItemWhen2Node() {
        self.imgNodeArrow2.isHidden = false
        self.imgLevel2.isHidden = false
        self.lbLevel2.isHidden = false
        self.imgStart2.isHidden = false
        self.imgStart3.isHidden = false
        self.imgLevel3.isHidden = false
        self.lbLevel3.isHidden = false
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
    
    @IBAction func backMemberAction(_ sender: AnyObject) {
        if self.currentLeader != nil {
            for element in self.memberList {
                if element == self.currentLeader {
                    self.currentLeader = nil
                    self.setLeaderTree(avata: (Caring.userInfo?.avata ?? "")!, id: Int(Caring.userInfo?.currentUserId ?? "0")!, teamLevel: element.level?.level ?? 0)
                    self.showTreeMapWithData(members: self.memberList)
                    break
                }
                else {
                    let lead = self.search(element)
                    if lead != nil {
                        break
                    }
                }
            }
        }
    }
    
    func search(_ value: Member) -> Member? {
        for element in value.members! {
            if element == self.currentLeader {
                self.currentLeader = value
                self.setLeaderTree(avata: value.imageUrl!, id: value.userId!, teamLevel: value.level?.level ?? 0)
                self.showTreeMapWithData(members: value.members!)
                return value
            }
            else {
                return self.search(element)
            }
        }
        return nil
    }
    
    @IBAction func detailMemberAction(_ sender: AnyObject) {
        if sender.tag > 2 {
            let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "ListMemberTreeVCId") as! ListMemberTreeVC
            if sender.tag < 4 {
                popoverContent.listMems = self.currentListNode4_5
            }
            else if sender.tag < 8 {
                popoverContent.listMems = self.currentListNode6_7
            }
            else if sender.tag < 13 {
                popoverContent.listMems = self.currentListNode8_9
            }
            else {
                popoverContent.listMems = self.currentListNodeMax
            }
            popoverContent.selectedBlock =  { (memberInfo) -> Void in
                popoverContent.dismiss(animated: true, completion: nil)
                if memberInfo.members!.count > 0 {
                    self.currentLeader = memberInfo
                    self.setLeaderTree(avata: (memberInfo.imageUrl ?? "")!, id: memberInfo.userId!, teamLevel: memberInfo.level?.level ?? 0)
                    self.showTreeMapWithData(members: memberInfo.members!)
                }
                else {
                    self.performSegue(withIdentifier: "PushDetailMember", sender: memberInfo)
                }
            }
            popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverContent.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
            let popover = popoverContent.popoverPresentationController
            popoverContent.preferredContentSize = CGSize(width: (popoverContent.listMems.count >= 10 ? self.view.frame.size.width - 20 : CGFloat(95 * popoverContent.listMems.count)), height: 95)
            popover?.delegate = self
            popover?.sourceView = sender as? UIView
            popover?.sourceRect = sender.bounds
            self.present(popoverContent, animated: true, completion: nil)
        }
        else {
            let selectedInfo: Member = self.currentList[sender.tag]
            if selectedInfo.members!.count > 0 {
                self.currentLeader = selectedInfo
                self.setLeaderTree(avata: (selectedInfo.imageUrl ?? "")!, id: selectedInfo.userId!, teamLevel: selectedInfo.level?.level ?? 0)
                self.showTreeMapWithData(members: selectedInfo.members!)
            }
            else {
                self.performSegue(withIdentifier: "PushDetailMember", sender: selectedInfo)
            }
        }
    }
    
    @IBAction func detailAction() {
        self.performSegue(withIdentifier: "PushDetailMember", sender: nil)
    }
    
    @IBAction func currentLeadAction() {
        if self.currentLeader != nil {
            self.performSegue(withIdentifier: "PushDetailMember", sender: self.currentLeader)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushDetailMember" {
            let userInfo: Member = sender as! Member
            let detail: TTThanhVienVC = segue.destination as! TTThanhVienVC
            detail.detailInfo = userInfo
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
