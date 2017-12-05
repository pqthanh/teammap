//
//  TaoCuocHenVC.swift
//  TeamCaring
//
//  Created by fwThanh on 12/3/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit

class TaoCuocHenVC: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var viewMota: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tfThoigianhen: UITextField!
    @IBOutlet weak var tfTypeEvent: UITextField!
    @IBOutlet weak var btnCalendar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        let popover = popoverContent.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: self.view.frame.size.width, height: 200)
        popover?.delegate = self
        popover?.sourceView = sender as? UIView
        popover?.sourceRect = sender.bounds
        self.present(popoverContent, animated: false, completion: nil)
    }
    
    @IBAction func selectMemberAction(_ sender: AnyObject) {
        let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "SelectTeamMemVCId") as! SelectTeamMemVC
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        popoverContent.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.unknown
        let popover = popoverContent.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: self.view.frame.size.width, height: 200)
        popover?.delegate = self
        popover?.sourceView = sender as? UIView
        popover?.sourceRect = sender.bounds
        self.present(popoverContent, animated: false, completion: nil)
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
