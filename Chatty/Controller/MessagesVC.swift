//
//  ViewController.swift
//  Chatty
//
//  Created by onur hüseyin çantay on 22/09/2017.
//  Copyright © 2017 onur hüseyin çantay. All rights reserved.
//

import UIKit
import Firebase

class MessagesVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        isUserLoggedIn()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title:"Messages", style: .plain, target: self, action: #selector(handleNewMessage))
       
    }
   @objc func handleNewMessage()  {
        let messageController = newMessageVC()
        let navController = UINavigationController(rootViewController: messageController)
        present(navController ,animated: true , completion : nil)
    
    }
    func isUserLoggedIn() {
        if Firebase.Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }else{
            let uid = Firebase.Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observe(.value, with: { (snapshot) in
                if let dict = snapshot.value as? Dictionary <String,AnyObject>{
                    self.navigationItem.title = dict["Names"] as? String
                }
            }, withCancel: nil)
            
        }
    }
   @objc func handleLogout() {
    do {
        try Firebase.Auth.auth().signOut()
    } catch let error as NSError{
        print(error.debugDescription)
    }
     let loginController = LoginVC()
    present(loginController ,animated: true , completion : nil)
    }

  

}

