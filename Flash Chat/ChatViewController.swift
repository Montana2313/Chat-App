//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import SVProgressHUD
import ChameleonFramework


class ChatViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource ,UITextFieldDelegate {
    // We've pre-linked the IBOutlets
    var messageArray : [Message] = [Message]()
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTextfield.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        self.messageTableView.addGestureRecognizer(tapGesture)
        configureTableView()
        retrievMessage()
        self.messageTableView.separatorStyle = .none // aradaki ayraçları siliyor.
        self.messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell") // oluşturduğumuz tasarımı burada tanımlıyoruz

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.messageTableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        cell.messageBody.text = self.messageArray[indexPath.row].messageBody
        cell.senderUsername.text = self.messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        if cell.senderUsername.text == Auth.auth().currentUser!.email
        {
            cell.messageBackground.backgroundColor = UIColor.flatCoffee()
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
        }
        else
        {
            cell.messageBackground.backgroundColor = UIColor.flatSand()
            cell.avatarImageView.backgroundColor = UIColor.flatLime()
        }
        
        return cell
    }
    

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    
    
    
    //TODO: Declare numberOfRowsInSection here:
    
    @objc func tableViewTapped()
    {
        messageTextfield.endEditing(true)
    }
    
    
    func configureTableView()
    {
        self.messageTableView.rowHeight = UITableView.automaticDimension
        self.messageTableView.estimatedRowHeight = 120.0
    }
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
           self.heightConstraint.constant = 350
           self.view.layoutIfNeeded()
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }

    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        self.messageTextfield.isEnabled = false
        self.sendButton.isEnabled = false
        
        let messageDB = Database.database().reference().child("Messages")
        
        let messageDictionary = ["Sender" : Auth.auth().currentUser!.email!,
                                 "MessageBody" : self.messageTextfield.text!]
        
        messageDB.childByAutoId().setValue(messageDictionary){
            (error,referance) in
            if error != nil
            {
                print("Error has been occured")
            }
            else
            {
                print("Message has been sent succesfully")
                self.messageTextfield.text = ""
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
            }
        }
        
        
    }
    // mark ve todo kolay geçişleri sağlıyor
    func retrievMessage()
    {
        let messageDB = Database.database().reference().child("Messages")
        // eğer bir şey eklenirse otomatik çalışıcak
        messageDB.observe(DataEventType.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            // child added olduğu için bir daha çağırmaya gerke yok sanırım çünkü eğer bir şey eklenirse otomatik burası triggerlanıyor
            // childları diğer böyle içine girebiliyor zaten idileri farkı olduğu için 
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            let Messages = Message()
            Messages.sender = sender
            Messages.messageBody = text
            self.messageArray.append(Messages)
            self.configureTableView()
            self.messageTableView.reloadData()
        }
    }
    @IBAction func logOutPressed(_ sender: AnyObject) {
        SVProgressHUD.show()
        do
        {
            SVProgressHUD.dismiss()
            
            try Auth.auth().signOut()
        }
        catch{print("SignOut throws a error")}
        
        guard ((navigationController?.popToRootViewController(animated: true)) != nil) else {
            print("No pop up controller")
            return
        }
        
    }
    


}
