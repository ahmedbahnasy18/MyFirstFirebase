//
//  ViewController.swift
//  MyFirstFirebase
//
//  Created by Ahmed on 8/13/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginBtnPressed(sender: UIButton) {
        guard let email = emailTF.text?.trimmingCharacters(in: .whitespaces), !email.isEmpty else {
            print("email is empty")
            return
        }
        guard let password = passwordTF.text, !password.isEmpty else {
            print("password is empty")
            return
        }
        
        self.view.endEditing(true)
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                print(error.localizedDescription)
                //if error.code
                    let alert = UIAlertController(title: "Sorry", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                        self.emailTF.becomeFirstResponder()
                    }))
                    self.present(alert, animated: true, completion: nil)
            } 
        }
    }

    @IBAction func forgotPasswordPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Enter", message: "Email", preferredStyle: .alert)
        
        alert.addTextField { (tf: UITextField) in
            tf.placeholder = "Current Email"
            tf.keyboardType = .emailAddress
        }
        
        alert.addAction(UIAlertAction(title: "Reset Password", style: .default, handler: { (action: UIAlertAction) in
            if let email = alert.textFields?.first?.text, !email.isEmpty {
                Auth.auth().sendPasswordReset(withEmail: email, completion: { (error: Error?) in
                    if let error = error {
                        self.showAlert(title: "Error", message: error.localizedDescription)
                    } else {
                        self.showAlert(title: "OK", message: "check your inbox")
                    }
                })
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

