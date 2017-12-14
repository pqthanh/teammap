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
        self.hideKeyboardWhenTappedAround()
        
        self.txtMota.layer.cornerRadius = 4.0
        self.txtMota.layer.borderWidth = 1.0
        self.txtMota.layer.borderColor = UIColor(hexString: "#dadada").cgColor
        imgAvata.layer.cornerRadius = 50.0
        
        let fbAccessToken = FBSDKAccessToken.current()?.tokenString
        if fbAccessToken != nil {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, email, name, picture.type(large)"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let fbDetails = result as! NSDictionary
                    //print(fbDetails)
                    self.email = (fbDetails.object(forKey: "email") ?? "") as! String
                    self.fullname = fbDetails.object(forKey: "name") as! String
                    if self.email == "" {
                        self.tfEmail.isEnabled = true
                    }
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
        }
        else {
            FService.sharedInstance.getCurrentProfile(completion: { (profile) in
                if profile != nil {
                    let info: Leader = profile!
                    self.avataUrl = info.imageUrl!
                    self.imgAvata.image = UIImage.image(fromURL: info.imageUrl!, placeholder: UIImage(named: "ic_profile")!, shouldCacheImage: true) { (image) in
                        self.imgAvata.image = nil
                        self.imgAvata.image = image
                    }
                    self.tfEmail.text = info.email
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
    
    @IBAction func updateAction(_ sender: AnyObject) {
        self.view.endEditing(true)
        SVProgressHUD.show()
        FService.sharedInstance.updateProfile(fullName: tfFullname.text!, nickName: tfNickname.text!, nameGroup: tfTenNhom.text!, description: txtMota.text!, totalMember: Int(tfSoluong.text!) ?? 0, email: tfEmail.text!) { (success) in
            if success == 200 {
                let userInfo = User(userId: "", email: self.tfEmail.text!, token: Caring.deviceToken!, nickname: self.tfNickname.text!, fullname: self.tfFullname.text!, tenNhom: self.tfTenNhom.text!, mota: self.txtMota.text!, soluong: Int(self.tfSoluong.text!), avata: self.avataUrl)
                Caring.userInfo = userInfo
                Caring.isActived = true
                self.performSegue(withIdentifier: "PushKhoiDau", sender: nil)
            }
            SVProgressHUD.dismiss()
        }
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
