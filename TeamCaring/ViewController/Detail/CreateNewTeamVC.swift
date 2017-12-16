//
//  CreateNewTeamVC.swift
//  TeamCaring
//
//  Created by fwThanh on 11/29/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit
import SVProgressHUD

class CreateNewTeamVC: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lbTxtholder: UILabel!
    @IBOutlet weak var txtMota: UITextView!
    @IBOutlet weak var lbTxtholder1: UILabel!
    @IBOutlet weak var txtMota1: UITextView!
    @IBOutlet weak var imgVTeamIcon: UIImageView!
    
    @IBOutlet weak var tfname: UITextField!
    @IBOutlet weak var tflevel: UITextField!
    @IBOutlet weak var tfextraGroupName: UITextField!
    @IBOutlet weak var tfextraGroupTotalMember: UITextField!
    
    var currentIdAvata = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.imgVTeamIcon.layer.cornerRadius = 50.0
        SVProgressHUD.setDefaultMaskType(.clear)
        
        self.txtMota.layer.cornerRadius = 4.0
        self.txtMota.layer.borderWidth = 1.0
        self.txtMota.layer.borderColor = UIColor(hexString: "#dadada").cgColor
        
        self.txtMota1.layer.cornerRadius = 4.0
        self.txtMota1.layer.borderWidth = 1.0
        self.txtMota1.layer.borderColor = UIColor(hexString: "#dadada").cgColor
        
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
    
    @IBAction func chonIcnonAction() {
        self.performSegue(withIdentifier: "PushChonIcon", sender: nil)
    }
    
    @IBAction func createNewTeam() {
        
        var message = ""
        if currentIdAvata == 0 {
            message = "Vui lòng chọn ảnh đại diện cho nhóm!"
        }
        else if tfname.text! == "" {
            message = "Vui lòng nhập tên nhóm!"
        }
        else if txtMota.text! == "" {
            message = "Vui lòng nhập mô tả nhóm!"
        }
        else if tflevel.text! == "" {
            message = "Vui lòng nhập số cấp độ cho nhóm!"
        }
        
        if message != "" {
            let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Tiếp tục", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        SVProgressHUD.show()
        let strNumMemsAnys = self.tfextraGroupTotalMember.text!
        let numMemsAnys = Int(strNumMemsAnys == "" ? "0" : strNumMemsAnys)!
        FService.sharedInstance.createTeam(description: self.txtMota.text!,
                                           extraGroupDescription: self.txtMota1.text!,
                                           extraGroupName: self.tfextraGroupName.text!,
                                           extraGroupTotalMember: numMemsAnys,
                                           iconId: self.currentIdAvata,
                                           name: self.tfname.text!,
                                           totalMember: Int(self.tflevel.text!)!)
        { (code) in

            if code == 201 {
                let appDelegate = UIApplication.shared.delegate! as! AppDelegate
                let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewControllerId")
                appDelegate.window?.rootViewController = mainViewController
            }
            SVProgressHUD.dismiss()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool  {
        if textField == self.tflevel {
            let currentCharacterCount = textField.text?.count ?? 0
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 10
        }
        else {
            let currentCharacterCount = textField.text?.count ?? 0
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 30
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if textView == self.txtMota {
            self.lbTxtholder.text = newText.count > 0 ? "" : "VD: Dành cho những người có sở thích, đam mê công nghệ"
        }
        else if textView == self.txtMota1 {
            self.lbTxtholder1.text = newText.count > 0 ? "" : "VD: Dành cho những người có sở thích, đam mê công nghệ"
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushChonIcon" {
            let selectIcon: ChonIconViewController = segue.destination as! ChonIconViewController
            selectIcon.completionBlock =  { (index) -> Void in
                self.currentIdAvata = index
                self.imgVTeamIcon.image = UIImage(named: "\(index)")
            }
        }
    }

}
