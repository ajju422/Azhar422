//
//  LoginViewController.swift
//  HeroKuApp
//
//  Created by Azhar on 25/01/19.
//  Copyright © 2019 Orbysol Systems Pvt Ltd. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        
        let email = self.emailTextField.text ?? ""
        let password = self.passwordTextField.text
        if !Utils().validateEmail(testStr: email)  {
            self.showAlertView(title: "Invalid Email", message: "Please enter valid email")
            return
        }
        if  password?.count == 0 || password == nil {
            self.showAlertView(title: "Invalid password", message: "Please enter password")
            return
        }
        let service = Services()
        DispatchQueue.main.async {
            service.loginUser(email: email, password: password!)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveLoginResponce(_:)), name: .DidReceiveLoginResponce, object: nil)
    }
    
    @objc func didReceiveLoginResponce(_ notification: Notification) {
        DispatchQueue.main.async {
            let staffVc = StaffViewController.init(nibName: "StaffViewController", bundle: nil)
            self.present(staffVc, animated: true, completion: nil)
        }
    }
    
}
