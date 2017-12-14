//
//  TTThanhVienVC.swift
//  TeamCaring
//
//  Created by Phan Quoc Thanh on 12/4/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit
import SVProgressHUD

class TTThanhVienVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgAvata: UIImageView!
    @IBOutlet weak var tfCapDo: UITextField!
    @IBOutlet weak var tfCuocHen: UITextField!
    @IBOutlet weak var tfHoTen: UITextField!
    @IBOutlet weak var tfNickname: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    
    var detailInfo: Member?
    
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
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cuochenAction() {
        self.performSegue(withIdentifier: "PushNhungCuocHen", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushNhungCuocHen" {
            let _:DanhSachHensVC = segue.destination as! DanhSachHensVC
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
