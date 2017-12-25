//
//  TaoCuocHenVC.swift
//  TeamCaring
//
//  Created by fwThanh on 12/3/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit
import SVProgressHUD

class TaoCuocHenVC: UIViewController, UIPopoverPresentationControllerDelegate, UITextViewDelegate {

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
    
    var selectedTeamIndex: IndexPath?
    var selectedTeam: Team?
    var selectedMember: Leader?
    var selectedMemberIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SVProgressHUD.setDefaultMaskType(.clear)
        self.viewMota.layer.cornerRadius = 4.0
        self.viewMota.layer.borderWidth = 1.0
        self.viewMota.layer.borderColor = UIColor(hexString: "#dadada").cgColor
        
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func keyboardWillShow(notification:NSNotification){
        let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        let keyboardHeight = keyboardSize.height - 48
        let keyboardFrame:CGRect = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: keyboardHeight)
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    func formatDate(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm dd/MM/yyyy"
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let output = dateFormatter.string(from: date!)
        return output
    }
    
    @IBAction func createAction() {
        self.view.endEditing(true)
        if tfNameEvent.text == "" || txtMota.text == "" || tfThoigianhen.text == "" || tfTypeEvent.text == "" || tfTeam.text == "" || tfMember.text == "" {
            let alert = UIAlertController(title: "Vui lòng điền tất cả thông tin!", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Tiếp tục", style: .default, handler: { action in }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        SVProgressHUD.show()
        var typeEvent = "no_repeat"
        if tfTypeEvent.text == "1 Tuần" {
            typeEvent = "one_week"
        }
        else if tfTypeEvent.text == "2 Tuần" {
            typeEvent = "two_week"
        }
        else if tfTypeEvent.text == "1 Tháng" {
            typeEvent = "one_month"
        }
        FService.sharedInstance.createAppointment(description: txtMota.text, name: tfNameEvent.text!, repeatType: typeEvent, teamId: (selectedTeam?.id)!, time: self.formatDate(dateString: tfThoigianhen.text!), userId: (selectedMember?.userId)!) { (code) in
            if code == 201 {
                let alert = UIAlertController(title: "Tạo cuộc hẹn thành công!", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Tiếp tục", style: .default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
            SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func backAction() {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCalAction() {
        self.dateTimeAction(self.btnCalendar)
    }
    
    @IBAction func dateTimeAction(_ sender: AnyObject) {
        self.view.endEditing(true)
        let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "DateTimePickerVCId") as! DateTimePickerVC
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
        popoverContent.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.right
        popoverContent.selectedBlock =  { (date) -> Void in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm dd/MM/yyyy"
            let strDate = dateFormatter.string(from: date)
            self.tfThoigianhen.text = strDate
        }
        let popover = popoverContent.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: 280, height: 200)
        popover?.delegate = self
        popover?.sourceView = sender as? UIView
        popover?.sourceRect = sender.bounds
        self.present(popoverContent, animated: true, completion: nil)
    }
    
    @IBAction func typeEventAction(_ sender: AnyObject) {
        self.view.endEditing(true)
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Chọn loại hẹn", message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Hủy", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let action1Button = UIAlertAction(title: "1 Tuần", style: .default) { _ in
            self.tfTypeEvent.text = "1 Tuần"
        }
        actionSheetControllerIOS8.addAction(action1Button)
        let action2Button = UIAlertAction(title: "2 Tuần", style: .default) { _ in
            self.tfTypeEvent.text = "2 Tuần"
        }
        actionSheetControllerIOS8.addAction(action2Button)
        let action3Button = UIAlertAction(title: "1 Tháng", style: .default) { _ in
            self.tfTypeEvent.text = "1 Tháng"
        }
        actionSheetControllerIOS8.addAction(action3Button)
        
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
    @IBAction func selectTeamAction(_ sender: AnyObject) {
        let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "SelectTeamMemVCId") as! SelectTeamMemVC
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        popoverContent.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.unknown
        if self.selectedTeamIndex != nil {
            popoverContent.indexSelected = self.selectedTeamIndex! as IndexPath
        }
        popoverContent.selectedBlock =  { (selectedTeam, selectedIndex) -> Void in
            self.tfTeam.text = selectedTeam.name
            self.selectedTeam = selectedTeam
            self.selectedTeamIndex = selectedIndex as IndexPath
        }
        let popover = popoverContent.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: self.view.frame.size.width, height: 200)
        popover?.delegate = self
        popover?.sourceView = sender as? UIView
        popover?.sourceRect = sender.bounds
        self.present(popoverContent, animated: false, completion: nil)
    }
    
    @IBAction func selectMemberAction(_ sender: AnyObject) {
        if self.selectedTeam != nil {
            let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "SelectTeamMemVCId") as! SelectTeamMemVC
            popoverContent.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            popoverContent.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.unknown
            popoverContent.isMember = true
            popoverContent.teamId = self.selectedTeam?.id ?? 0
            if self.selectedMemberIndex != nil {
                popoverContent.indexSelected = self.selectedMemberIndex! as IndexPath
            }
            popoverContent.selectedMemberBlock =  { (selectedMem, selectedIndex) -> Void in
                self.tfMember.text = selectedMem.nickname
                self.selectedMember = selectedMem
                self.selectedMemberIndex = selectedIndex as IndexPath
            }
            let popover = popoverContent.popoverPresentationController
            popoverContent.preferredContentSize = CGSize(width: self.view.frame.size.width, height: 200)
            popover?.delegate = self
            popover?.sourceView = sender as? UIView
            popover?.sourceRect = sender.bounds
            self.present(popoverContent, animated: false, completion: nil)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if textView == self.txtMota {
            self.lbTxtholder.text = newText.count > 0 ? "" : "VD: Giới thiệu về cuộc hẹn"
        }
        return true
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
