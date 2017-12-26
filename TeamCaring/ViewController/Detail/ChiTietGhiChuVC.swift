//
//  ChiTietGhiChuVC.swift
//  TeamCaring
//
//  Created by fwThanh on 12/26/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit

class ChiTietGhiChuVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtGeneral: UITextView!
    @IBOutlet weak var txtReminder: UITextView!
    @IBOutlet weak var txtSeparate: UITextView!
    
    var eventId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        //self.navigationController?.popViewController(animated: true)
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
