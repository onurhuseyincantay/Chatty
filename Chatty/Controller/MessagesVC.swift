//
//  ViewController.swift
//  Chatty
//
//  Created by onur hüseyin çantay on 22/09/2017.
//  Copyright © 2017 onur hüseyin çantay. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        if Firebase.Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
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

