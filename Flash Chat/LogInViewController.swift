//
//  LogInViewController.swift
//  Flash Chat
//
//  This is the view controller where users login


import UIKit
import Firebase
import SVProgressHUD

class LogInViewController: UIViewController {

    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

   
    @IBAction func logInPressed(_ sender: AnyObject) {
        SVProgressHUD.show()
        Auth.auth().signIn(withEmail: self.emailTextfield.text!, password: self.passwordTextfield.text!) { (User, error) in
             if error != nil
             {
               print(error!.localizedDescription)
             }
            else
             {
                SVProgressHUD.dismiss()
                
               self.performSegue(withIdentifier: "goToChat", sender: nil)
             }
        }
        
    }
    


    
}  
