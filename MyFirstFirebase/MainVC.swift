//
//  MainVC.swift
//  MyFirstFirebase
//
//  Created by Ahmed on 8/14/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MainVC: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var photoURLTF: UITextField!
    @IBOutlet weak var verfiyEmail_lbl: UILabel!
    @IBOutlet weak var verifyButtonPressed: UIButton!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downLoadUserData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logOut))
    }
    func logOut() {
        do {
            try Auth.auth().signOut()
            //print("Logged Out")
        } catch {
            print(error)
        }
        
    }
    @IBAction func updatePressed(_ sender: UIButton) {
        
        guard let user = Auth.auth().currentUser else { return }
        
        let name = nameTF.text!
        let photoURL = photoURLTF.text!
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        changeRequest.photoURL = NSURL(string: photoURL)! as URL
    
        changeRequest.commitChanges {(error: Error?) in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            } else {
                self.showAlert(title: "Succeed", message: "user updated")
                self.downLoadUserData()
            }
        }
    }
    private func downLoadUserData() {
        if let user = Auth.auth().currentUser {
            user.reload(completion: { (error: Error?) in
                if let error = error {
                    print(error)
                } else {
                    
                    if user.isEmailVerified {
                        self.verfiyEmail_lbl.text = "Email Verified"
                        self.verfiyEmail_lbl.textColor = UIColor.black
                        self.verifyButtonPressed.isHidden = true
                    } else {
                        self.verfiyEmail_lbl.text = "Email Not Verified"
                        self.verfiyEmail_lbl.textColor = UIColor.red
                        self.verifyButtonPressed.isHidden = false
                    }
                    if let email = user.email {
                        self.navigationItem.title = email
                    }
                    if let name = user.displayName {
                        self.nameTF.text = name
                    }
                    if let photoURL = user.photoURL, !photoURL.absoluteString.isEmpty {
                        self.photoURLTF.text = photoURL.absoluteString
                        
                        //Download Photo
                        URLSession.shared.dataTask(with: photoURL, completionHandler: { (data: Data?, response: URLResponse?, error:Error?) in
                            if let error = error {
                                print(error)
                                DispatchQueue.main.async {
                                    self.showAlert(title: "Error", message: error.localizedDescription)
                                }
                            } else {
                                if let data = data, let image = UIImage(data: data) {
                                    DispatchQueue.main.async {
                                        self.userImage.image = image
                                    }
                                }
                            }
                        }).resume()
                    }
                }
            })
        }
    }
    
    @IBAction func updateEmail() {
        guard let user = Auth.auth().currentUser else { return }
        
        let alert = UIAlertController(title: "Enter", message: "New Email", preferredStyle: .alert)
        alert.addTextField { (tf: UITextField) in
            tf.placeholder = "New Email"
            tf.keyboardType = .emailAddress
        }
        alert.addTextField { (tf: UITextField) in
            tf.placeholder = "Current Email"
            tf.keyboardType = .emailAddress
        }
        alert.addTextField { (tf: UITextField) in
            tf.placeholder = "Current Password"
            tf.isSecureTextEntry = true
        }
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (action: UIAlertAction) in
            if let textFields = alert.textFields {
                let newEmail = textFields.first!.text!
                let currentEmail = textFields[1].text!
                let currentPassword = textFields[2].text!
      
                let credential = EmailAuthProvider.credential(withEmail: currentEmail, password: currentPassword)
                user.reauthenticate(with: credential, completion: { (error: Error?) in
                    if let error = error {
                        print(error)
                        self.showAlert(title: "Error", message: error.localizedDescription)
                    } else {
                        user.updateEmail(to: newEmail, completion: { (error: Error?) in
                            if let error = error {
                                print(error)
                                self.showAlert(title: "Error", message: error.localizedDescription)
                            } else {
                                self.showAlert(title: "Succeed", message: "Email Updated")
                            }
                        })
                    }
                })
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func changePasswordPressed(_ sender: UIButton) {
       
        guard let user = Auth.auth().currentUser else { return }
        
        let alert = UIAlertController(title: "Enter", message: "New Password", preferredStyle: .alert)
        alert.addTextField { (tf: UITextField) in
            tf.placeholder = "New Password"
            tf.isSecureTextEntry = true
        }
        alert.addTextField { (tf: UITextField) in
            tf.placeholder = "Current Email"
            tf.keyboardType = .emailAddress
        }
        alert.addTextField { (tf: UITextField) in
            tf.placeholder = "Current Password"
            tf.isSecureTextEntry = true
        }
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (action: UIAlertAction) in
            if let textFields = alert.textFields {
                let newPassword = textFields.first!.text!
                let currentEmail = textFields[1].text!
                let currentPassword = textFields[2].text!
                
                let credential = EmailAuthProvider.credential(withEmail: currentEmail, password: currentPassword)
                user.reauthenticate(with: credential, completion: { (error: Error?) in
                    if let error = error {
                        print(error)
                        self.showAlert(title: "Error", message: error.localizedDescription)
                    } else {
                        user.updatePassword(to: newPassword, completion: { (error: Error?) in
                            if let error = error {
                                print(error)
                                self.showAlert(title: "Error", message: error.localizedDescription)
                            } else {
                                self.showAlert(title: "Succeed", message: "Password Updated")
                            }
                        })
                    }
                })
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    
  }

    @IBAction func verifyEmailButtonPressed(_ sender: UIButton) {
        guard let user = Auth.auth().currentUser else { return }
        
        user.sendEmailVerification { (error :Error?) in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            } else {
                self.showAlert(title: "Succed", message: "Check your inbox for verification link")
            }
        }
    }

    @IBAction func deleteAcountPressed(_ sender: UIButton) {
        
        guard let user = Auth.auth().currentUser else { return }
        
        let alert = UIAlertController(title: "Delete", message: "Acount", preferredStyle: .alert)
      
        alert.addTextField { (tf: UITextField) in
            tf.placeholder = "Current Email"
            tf.keyboardType = .emailAddress
        }
        alert.addTextField { (tf: UITextField) in
            tf.placeholder = "Current Password"
            tf.isSecureTextEntry = true
        }
        alert.addAction(UIAlertAction(title: "Delete Acount", style: .default, handler: { (action: UIAlertAction) in
            if let textFields = alert.textFields {
                let currentEmail = textFields[0].text!
                let currentPassword = textFields[1].text!
                
                let credential = EmailAuthProvider.credential(withEmail: currentEmail, password: currentPassword)
                user.reauthenticate(with: credential, completion: { (error: Error?) in
                    if let error = error {
                        print(error)
                        self.showAlert(title: "Error", message: error.localizedDescription)
                    } else {
                        user.delete(completion: { (error: Error?) in
                            if let error = error {
                                print(error)
                                self.showAlert(title: "Error", message: error.localizedDescription)
                            } else {
                                self.showAlert(title: "Succeed", message: "Acount")
                            }
                        })
                    }
                })
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
