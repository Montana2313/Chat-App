//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD


class RegisterViewController: UIViewController {

    
    //Pre-linked IBOutlets

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
    @IBAction func registerPressed(_ sender: AnyObject) {
        
        SVProgressHUD.show()
        
        Auth.auth().createUser(withEmail: self.emailTextfield.text!, password: self.passwordTextfield.text!) { (user, error) in
              if error != nil
              {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "Tamam", style: .cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert,animated: true,completion: nil)
              }
              else
              {
                 SVProgressHUD.dismiss()
                
                 self.performSegue(withIdentifier: "goToChat", sender: nil)
              }
        }

    }
}
