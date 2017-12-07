//
//  ProfileViewController.swift
//  TeamCaring
//
//  Created by PqThanh on 11/17/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import SVProgressHUD
import AFImageHelper

class ProfileViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgAvata: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var viewMota: UIView!
    @IBOutlet weak var lbTxtholder: UILabel!
    
    @IBOutlet weak var tfFullname: UITextField!
    @IBOutlet weak var tfNickname: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfTenNhom: UITextField!
    @IBOutlet weak var txtMota: UITextView!
    @IBOutlet weak var tfSoluong: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SVProgressHUD.setDefaultMaskType(.clear)
        self.hideKeyboardWhenTappedAround()
        
        self.imgAvata.layer.cornerRadius = 50.0
        self.viewMota.layer.cornerRadius = 4.0
        self.viewMota.layer.borderWidth = 1.0
        self.viewMota.layer.borderColor = UIColor(hexString: "#dadada").cgColor
        
        if let userInfo = Caring.userInfo {
            self.imgAvata.image = UIImage.image(fromURL: (userInfo.avata)!, placeholder: UIImage(named: "ic_profile")!, shouldCacheImage: true) { (image) in
                self.imgAvata.image = nil
                self.imgAvata.image = image
            }
            self.tfFullname.text = userInfo.fullname
            self.tfNickname.text = userInfo.nickname
            
            self.txtMota.text = userInfo.mota
            if (userInfo.mota != nil) && userInfo.mota != "" {
                self.lbTxtholder.isHidden = true
            }
            self.tfTenNhom.text = userInfo.tenNhom
            self.tfSoluong.text = "\(userInfo.soluong ?? 1)"
        }
        else {
            FService.sharedInstance.getCurrentProfile(completion: { (profile) in
                if profile != nil {
                    let info: Leader = profile!
                    self.imgAvata.image = UIImage.image(fromURL: info.imageUrl!, placeholder: UIImage(named: "ic_profile")!, shouldCacheImage: true) { (image) in
                        self.imgAvata.image = nil
                        self.imgAvata.image = image
                    }
                    self.tfFullname.text = info.fullName
                    self.tfNickname.text = info.nickname
                    
                    self.txtMota.text = info.extraGroupDescription
                    if (info.extraGroupDescription != nil) && info.extraGroupDescription != "" {
                        self.lbTxtholder.isHidden = true
                    }
                    self.tfTenNhom.text = info.extraGroupName
                    self.tfSoluong.text = "\(info.numberAppointments ?? 1)"
                }
            })
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        self.lbTxtholder.text = newText.count > 0 ? "" : "VD: Dành cho những người có sở thích, đam mê công nghệ"
        return true
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
