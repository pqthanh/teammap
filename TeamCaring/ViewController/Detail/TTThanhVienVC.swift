//
//  TTThanhVienVC.swift
//  TeamCaring
//
//  Created by Phan Quoc Thanh on 12/4/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit
import SVProgressHUD

class TTThanhVienVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgAvata: UIImageView!
    @IBOutlet weak var tfCapDo: UITextField!
    @IBOutlet weak var tfCuocHen: UITextField!
    @IBOutlet weak var tfHoTen: UITextField!
    @IBOutlet weak var tfNickname: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var heightButton: NSLayoutConstraint!
    @IBOutlet weak var btnUpdate: UIButton!
    
    var detailInfo: Member?
    var isEditLevel: Bool?
    var teamId = 0
    var selectedBlock: ((Int) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SVProgressHUD.setDefaultMaskType(.clear)
        self.hideKeyboardWhenTappedAround()
        
        self.imgAvata.layer.cornerRadius = 50.0
        self.imgAvata.image = UIImage.image(fromURL: (detailInfo?.imageUrl ?? "")!, placeholder: UIImage(named: "ic_profile")!, shouldCacheImage: true) { (image) in
            self.imgAvata.image = nil
            self.imgAvata.image = image
        }
        self.tfCapDo.text = "\(detailInfo?.level?.level ?? 0)"
        self.tfCuocHen.text = "0"
        self.tfHoTen.text = detailInfo?.fullName
        self.tfNickname.text = detailInfo?.nickname
        self.tfEmail.text = detailInfo?.email
        
        if self.isEditLevel == true {
            self.tfCapDo.isEnabled = true
            heightButton.constant = 70
        }
        else {
            self.tfCapDo.isEnabled = false
            heightButton.constant = 0
        }
        btnUpdate.isEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
            let result = txtAfterUpdate == "" ? "0" : txtAfterUpdate
            
            if Int(result)! <= (detailInfo?.level?.level ?? 0)! {
                btnUpdate.isEnabled = false
            }
            else if Int(result)! >= (Caring.userInfo?.soluong ?? SData.shared.levelMember)! {
                btnUpdate.isEnabled = false
            }
            else {
                btnUpdate.isEnabled = true
            }
        }
        return true
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
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cuochenAction() {
        self.performSegue(withIdentifier: "PushNhungCuocHen", sender: self.detailInfo)
    }
    
    @IBAction func updateAction() {
        
        if tfCapDo.text != "" && Int(tfCapDo.text!)! < (detailInfo?.level?.level)! {
            
        }
        
        SVProgressHUD.show()
        FService.sharedInstance.updateLevelMem(id: (detailInfo?.level?.id)!, level: Int(tfCapDo.text!)!) { (code) in
            if code == 200 {
                if let selectedBlock = self.selectedBlock {
                    selectedBlock(Int(self.tfCapDo.text!)!)
                }
                let alert = UIAlertController(title: "Cập nhật thông tin thành công!", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Tiếp tục", style: .default, handler: { action in }))
                self.present(alert, animated: true, completion: nil)
            }
            SVProgressHUD.dismiss()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushNhungCuocHen" {
            let detail: DanhSachHensVC = segue.destination as! DanhSachHensVC
            detail.teamId = self.teamId
            detail.memberId = (self.detailInfo?.userId)!
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*PushNhungCuocHen
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
