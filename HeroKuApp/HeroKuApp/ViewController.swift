//
//  ViewController.swift
//  HeroKuApp
//
//  Created by Azhar on 25/01/19.
//  Copyright © 2019 Orbysol Systems Pvt Ltd. All rights reserved.
//

import UIKit


extension Notification.Name {
    static let DidReceiveRegistrationResponce = Notification.Name("DidReceiveRegistrationResponce")
    static let DidReceiveLoginResponce = Notification.Name("DidReceiveLoginResponce")
    static let DidReceiveSeatsResponce = Notification.Name("DidReceiveSeatsResponce")
    static let DidReceiveDesksResponce = Notification.Name("DidReceiveDesksResponce")

}
class ViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func registerButtonTapped(_ sender: Any) {
        
        let email = self.emailTextField.text ?? ""
        let password = self.passwordTextField.text
        let confirmPass = self.confirmPasswordTextfield.text
        
        if !Utils().validateEmail(testStr: email)  {
            self.showAlertView(title: "Invalid Email", message: "Please enter valid email")
            return
        }
        if  password?.count == 0 || password == nil {
            self.showAlertView(title: "Invalid password", message: "Please enter password")
            return
        }
        if  confirmPass?.count == 0 || password == nil || confirmPass != password {
            self.showAlertView(title: "Confirm password error", message: "Confirm password didn't matches with password")
            return
        }
        
        let service = Services()
        DispatchQueue.main.async {
            service.registerService(email: email, password: password!, confirmPassword: confirmPass!)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveRegistrationResponce(_:)), name: .DidReceiveRegistrationResponce, object: nil)

    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
            let loginVc = LoginViewController.init(nibName: "LoginViewController", bundle: nil)
            self.present(loginVc, animated: true, completion: nil)
    }
    
    @objc func didReceiveRegistrationResponce(_ notification: Notification) {
        DispatchQueue.main.sync {
            let staffVc = StaffViewController.init(nibName: "StaffViewController", bundle: nil)
            self.present(staffVc, animated: true, completion: nil)
        }
    }
    
}

extension UIViewController {
    func showAlertView(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

