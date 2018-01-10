//
//  ChiTietGhiChuVC.swift
//  TeamCaring
//
//  Created by fwThanh on 12/26/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit
import SVProgressHUD

class ChiTietGhiChuVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtGeneral: UITextView!
    @IBOutlet weak var txtReminder: UITextView!
    @IBOutlet weak var txtSeparate: UITextView!
    @IBOutlet weak var viewBtnCreate: UIView!
    @IBOutlet weak var btnCreate: UIButton!
    
    var eventId: Int = 0
    var currentNote: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SVProgressHUD.setDefaultMaskType(.clear)
        self.txtGeneral.layer.cornerRadius = 4.0
        self.txtGeneral.layer.borderWidth = 1.0
        self.txtGeneral.layer.borderColor = UIColor(hexString: "#dadada").cgColor
        
        self.txtReminder.layer.cornerRadius = 4.0
        self.txtReminder.layer.borderWidth = 1.0
        self.txtReminder.layer.borderColor = UIColor(hexString: "#dadada").cgColor
        
        self.txtSeparate.layer.cornerRadius = 4.0
        self.txtSeparate.layer.borderWidth = 1.0
        self.txtSeparate.layer.borderColor = UIColor(hexString: "#dadada").cgColor
        
        self.hideKeyboardWhenTappedAround()
        
        if self.currentNote != nil {
            self.txtGeneral.text = self.currentNote?.general
            self.txtReminder.text = self.currentNote?.reminder
            self.txtSeparate.text = self.currentNote?.separate
            self.btnCreate.isHidden = true
            self.viewBtnCreate.backgroundColor = UIColor.clear
        }
        
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
    
    @IBAction func createAction() {
        self.view.endEditing(true)
        SVProgressHUD.show()
        if self.currentNote != nil {
            FService.sharedInstance.updateNote(id: (self.currentNote?.id)!, appointmentId: (self.currentNote?.appointmentId)!, general: txtGeneral.text, reminder: txtReminder.text, separate: txtSeparate.text) { (code) in
                if code == 201 {
                    let alert = UIAlertController(title: "Cập nhật ghi chú thành công", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Tiếp tục", style: .default, handler: { action in
                        self.navigationController?.popToRootViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    let alert = UIAlertController(title: "Cập nhật ghi chú thất bại, vui lòng thử lại!", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Tiếp tục", style: .default, handler: { action in }))
                    self.present(alert, animated: true, completion: nil)
                }
                SVProgressHUD.dismiss()
            }
        }
        else {
            FService.sharedInstance.createNote(appointmentId: self.eventId, general: txtGeneral.text, reminder: txtReminder.text, separate: txtSeparate.text) { (code) in
                if code == 201 {
                    let alert = UIAlertController(title: "Tạo ghi chú thành công", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Tiếp tục", style: .default, handler: { action in
                        self.navigationController?.popToRootViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    let alert = UIAlertController(title: "Tạo ghi chú thất bại, vui lòng thử lại!", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Tiếp tục", style: .default, handler: { action in }))
                    self.present(alert, animated: true, completion: nil)
                }
                SVProgressHUD.dismiss()
            }
        }
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
