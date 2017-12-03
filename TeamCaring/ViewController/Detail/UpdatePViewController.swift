//
//  UpdatePViewController.swift
//  TeamCaring
//
//  Created by Phan Quoc Thanh on 11/23/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding
import FBSDKLoginKit
import SVProgressHUD

class UpdatePViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgAvata: UIImageView!
    @IBOutlet weak var lbTxtholder: UILabel!
    @IBOutlet weak var heightKeyboard: NSLayoutConstraint!
    
    @IBOutlet weak var tfFullname: UITextField!
    @IBOutlet weak var tfNickname: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfTenNhom: UITextField!
    @IBOutlet weak var txtMota: UITextView!
    @IBOutlet weak var tfSoluong: UITextField!
    
    var imagePicker = UIImagePickerController()
    var avataUrl = ""
    var fullname = ""
    var nickname = ""
    var email = ""
    var tenNhom = ""
    var mota = ""
    var soluong = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SVProgressHUD.setDefaultMaskType(.clear)
        
        self.txtMota.layer.cornerRadius = 4.0
        self.txtMota.layer.borderWidth = 1.0
        self.txtMota.layer.borderColor = UIColor(hexString: "#dadada").cgColor
        
        imgAvata.layer.cornerRadius = 50.0
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, email, name, picture.type(large)"]).start(completionHandler: { (connection, result, error) -> Void in
            if (error == nil){
                let fbDetails = result as! NSDictionary
                //print(fbDetails)
                self.email = fbDetails.object(forKey: "email") as! String
                self.fullname = fbDetails.object(forKey: "name") as! String
                
                self.tfEmail.text = self.email
                self.tfFullname.text = self.fullname
                
                let pictureData = fbDetails["picture"] as! NSDictionary
                if let data:NSDictionary = pictureData["data"] as? NSDictionary
                {
                    self.avataUrl = data.object(forKey: "url") as! String
                    self.imgAvata.image = UIImage.image(fromURL: self.avataUrl, placeholder: UIImage(named: "ic_profile")!, shouldCacheImage: true) { (image) in
                        self.imgAvata.image = nil
                        self.imgAvata.image = image
                    }
                }
            }
        })
        
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
    
    @IBAction func updateAction(_ sender: AnyObject) {
        self.view.endEditing(true)
        
        FService.sharedInstance.updateProfile(fullName: tfFullname.text!, nickName: tfNickname.text!, nameGroup: tfTenNhom.text!, description: txtMota.text!, totalMember: Int(tfSoluong.text!) ?? 0) { (success) in
            print(success ?? 0)
        }
        
//        let userInfo = User(userId: "", email: tfEmail.text!, token: "", nickname: tfNickname.text!, fullname: tfFullname.text!, tenNhom: tfTenNhom.text!, mota: txtMota.text!, soluong: Int(tfSoluong.text!), avata: self.avataUrl)
//        Caring.userInfo = userInfo
//
//        self.performSegue(withIdentifier: "PushKhoiDau", sender: nil)
    }
    
    @IBAction func btnAvataClicked() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
        let image = info[UIImagePickerControllerOriginalImage]as! UIImage
        self.imgAvata.image = image
        //let data = UIImagePNGRepresentation(image)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        self.lbTxtholder.text = newText.count > 0 ? "" : "VD: Dành cho những người có sở thích, đam mê công nghệ"
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
        if segue.identifier == "PushKhoiDau" {
            let _: SelectTeamVC = segue.destination as! SelectTeamVC
        }
    }

}
