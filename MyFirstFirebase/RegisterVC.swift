//
//  RegisterVC.swift
//  MyFirstFirebase
//
//  Created by Ahmed on 8/14/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterVC: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func registerBtnPrssed(_ sender: UIButton) {
        
        guard let email = emailTF.text?.trimmingCharacters(in: .whitespaces), !email.isEmpty else {
            print("email is empty")
            return
        }
        guard let password = passwordTF.text, !password.isEmpty else {
            print("password is empty")
            return
        }
        guard let confirmPassword = confirmPasswordTF.text, !confirmPassword.isEmpty else {
            print("confirmPassword is empty")
            return
        }
        guard password == confirmPassword else {
            print("passwords not match")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error)
            }
//            } else {
//                if let user = user {
//                    print(user)
//                    let sb = UIStoryboard(name: "Main", bundle: nil)
//                    let vc = sb.instantiateViewController(withIdentifier: "MainVC")
//                    let navC = UINavigationController(rootViewController: vc)
//                    self.present(navC, animated: true, completion: nil)
//                }
//            }
        }
    }

}
