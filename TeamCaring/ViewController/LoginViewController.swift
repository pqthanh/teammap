//
//  LoginViewController.swift
//  TeamCaring
//
//  Created by PqThanh on 11/17/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import IHKeyboardAvoiding
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var btnLogin:    UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SVProgressHUD.setDefaultMaskType(.clear)
    }

    @IBAction func loginAction(_ sender: AnyObject) {
        self.view.endEditing(true)
    
        let loginManager = LoginManager()
        //loginManager.loginBehavior = .web
        loginManager.logIn(readPermissions: [.email], viewController: self, completion: { loginResult in
            switch loginResult {
            case .failed( _), .cancelled:
                print("fail or cancel")
            case .success(grantedPermissions: _, declinedPermissions: _, token: let token):
                SVProgressHUD.show()
                FService.sharedInstance.loginFaceboook(token: token.authenticationToken, completion: { (fbInfo) in
                    if fbInfo != nil {
                        Caring.userToken = fbInfo?.token
                        Caring.isActived = fbInfo?.isActived
                        if (fbInfo?.isActived)! {
                            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
                            let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewControllerId")
                            appDelegate.window?.rootViewController = mainViewController
                        }
                        else {
                            let updateProfile = self.storyboard!.instantiateViewController(withIdentifier: "UpdatePViewControllerId")
                            self.present(updateProfile, animated: true, completion: nil)
                        }
                    }
                    else {
                        print("fail")
                    }
                    SVProgressHUD.dismiss()
                })
            }
        })
        /*
        if self.isValidEmail(email: self.tfEmail.text!) {
            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
            let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "MainViewControllerId")
            appDelegate.window?.rootViewController = initialViewController
            appDelegate.window?.makeKeyAndVisible()
        }
        else {
            let alert = UIAlertController(title: "Email không đúng định dạng, vui lòng thử lại.", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Đồng ý", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        */
    }
    
    func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
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
