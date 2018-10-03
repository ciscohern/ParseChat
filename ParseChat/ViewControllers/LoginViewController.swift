//
//  LoginViewController.swift
//  ParseChat
//
//  Created by Francisco Hernanedez on 10/2/18.
//  Copyright © 2018 Francisco Hernanedz. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func alert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // create a cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // handle cancel response here. Doing nothing will dismiss the view.
        }
        // add the cancel action to the alertController
        alertController.addAction(cancelAction)
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here.
        }
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        
        present(alertController, animated: true) {
            // optional code for what happens after the alert controller has finished presenting
            print("error alert")
        }
    }
    
    @IBAction func signupTapped(_ sender: Any) {
        let newUser = PFUser()
        
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        
        if(newUser.password == "" && newUser.username == ""){
            alert(title: "Sign Up Error", message: "No Username & Password")
        }
        else if(newUser.password == ""){
            alert(title: "Sign Up Error", message: "No Password")
        }
        else if(newUser.username == ""){
            alert(title: "Sign Up Error", message: "No Username")
        }
        
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                print("User Registered successfully")
                // manually segue to logged in view
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        if(password == "" && username == ""){
            alert(title: "Login Error", message: "No Username & Password")
        }
        else if(password == ""){
            alert(title: "Login Error", message: "No Password")
        }
        else if(username == ""){
            alert(title: "Login Error", message: "No Username")
        }
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
            } else {
                print("User logged in successfully")
                // display view controller that needs to shown after successful login
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
