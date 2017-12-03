//
//  CreateNewTeamVC.swift
//  TeamCaring
//
//  Created by fwThanh on 11/29/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit

class CreateNewTeamVC: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var heightKeyboard: NSLayoutConstraint!
    @IBOutlet weak var lbTxtholder: UILabel!
    @IBOutlet weak var txtMota: UITextView!
    @IBOutlet weak var lbTxtholder1: UILabel!
    @IBOutlet weak var txtMota1: UITextView!
    @IBOutlet weak var imgVTeamIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.imgVTeamIcon.layer.cornerRadius = 50.0
        
        self.txtMota.layer.cornerRadius = 4.0
        self.txtMota.layer.borderWidth = 1.0
        self.txtMota.layer.borderColor = UIColor(hexString: "#dadada").cgColor
        
        self.txtMota1.layer.cornerRadius = 4.0
        self.txtMota1.layer.borderWidth = 1.0
        self.txtMota1.layer.borderColor = UIColor(hexString: "#dadada").cgColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) {
            self.heightKeyboard.constant = keyboardSize.height
        }
    }
    func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            self.heightKeyboard.constant = 0
        }
    }
    
    @IBAction func backAction() {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func chonIcnonAction() {
        self.performSegue(withIdentifier: "PushChonIcon", sender: nil)
    }
    
    @IBAction func createNewTeam() {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewControllerId")
        appDelegate.window?.rootViewController = mainViewController
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let scrollPoint : CGPoint = CGPoint.init(x:0, y:textView.frame.origin.y - 80)
        self.scrollView.setContentOffset(scrollPoint, animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let scrollPoint : CGPoint = CGPoint.init(x:0, y:textField.frame.origin.y - 80)
        self.scrollView.setContentOffset(scrollPoint, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushChonIcon" {
            let selectIcon: ChonIconViewController = segue.destination as! ChonIconViewController
            selectIcon.completionBlock =  { (index) -> Void in
                self.imgVTeamIcon.image = UIImage(named: "\(index)")
            }
        }
    }

}
