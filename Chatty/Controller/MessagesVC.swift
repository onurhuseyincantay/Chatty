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

    let celId = "CellId"
    override func viewDidLoad() {
        super.viewDidLoad()
       navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        isUserLoggedIn()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title:"Messages", style: .plain, target: self, action: #selector(handleNewMessage))
        tableView.register(UserCell.self, forCellReuseIdentifier: celId)
        isUserLoggedIn()
    }

    var messages = [Message]()
    var MessagesDict = [String:Message]()
    
    func observeUserMessages()  {
        guard let uid = Firebase.Auth.auth().currentUser?.uid else{
        return
        }
        let ref = Firebase.Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messagesReference = Firebase.Database.database().reference().child("messages").child(messageId)
            messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
                 let mesage = Message()
                if let dict = snapshot.value as? Dictionary<String,AnyObject> {
                    mesage.fromId = dict["fromId"] as? String
                    mesage.text = dict["text"] as? String
                    mesage.timestamp = dict["timestamp"] as? NSNumber
                    mesage.toId = dict["toId"] as? String
                    self.messages.append(mesage)
                    if let chatPartnerId = mesage.getChatPartnerId(){
                        self.MessagesDict[chatPartnerId] = mesage
                        self.messages = Array(self.MessagesDict.values)
                        self.messages.sort(by: { (message1, message2) -> Bool in
                            
                            return message1.timestamp!.intValue > message2.timestamp!.intValue
                        })
                    }
                   
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.HandleReloadDataDelay), userInfo: nil, repeats: false)
                }
                
                
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    var timer : Timer?
  @objc func HandleReloadDataDelay()  {
        print("TableReloaded")
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: celId, for: indexPath) as! UserCell
        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        guard let chatPartnerId = message.getChatPartnerId() else {
            return
        }
        let ref = Firebase.Database.database().reference().child("users").child(chatPartnerId)
    ref.observeSingleEvent(of: .value, with: { (snapshot) in
        print(snapshot)
        if let dict = snapshot.value as? Dictionary<String,AnyObject> {
            let user = User()
            user.name = dict["Names"] as? String
            user.email = dict["Email"] as? String
            user.profileImageUrl = dict["ProfileImageURL"] as? String
            user.userId = chatPartnerId
            self.showChatControllerForUser(user: user)
        }
    }, withCancel: nil)
            
        }
    
   @objc func handleNewMessage()  {
        let messageController = newMessageVC()
        messageController.messagesController = self
        let navController = UINavigationController(rootViewController: messageController)
        present(navController ,animated: true , completion : nil)
    
    }
    func isUserLoggedIn() {
        if Firebase.Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }else{
           
            fetchUserandSetupNavBarTitle()
        }
    }
    func fetchUserandSetupNavBarTitle()  {
        guard let uid =  Firebase.Auth.auth().currentUser?.uid else {
            print("Uid is nill")
            return
        }
        Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? Dictionary <String,AnyObject>{
                let user = User()
                user.name = dict["Names"] as? String
                user.email = dict["Email"] as? String
                user.profileImageUrl = dict["ProfileImageURL"] as? String
                self.setupNavBarWithUser(user: user)
            }
        }, withCancel: nil)
    }
   @objc func handleLogout() {
    do {
        try Firebase.Auth.auth().signOut()
    } catch let error as NSError{
        print(error.debugDescription)
    }
     let loginController = LoginVC()
        loginController.messagesController = self
    present(loginController ,animated: true , completion : nil)
    }
    func setupNavBarWithUser (user: User){
        messages.removeAll()
        MessagesDict.removeAll()
        tableView.reloadData()
        observeUserMessages()
        let titleView = UIView()
        titleView.isUserInteractionEnabled = true
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        titleView.backgroundColor = UIColor.brown
         let containerView = UIView()
        containerView.isUserInteractionEnabled = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        profileImageView.isUserInteractionEnabled = true
        if let profileImageURl = user.profileImageUrl {
            profileImageView.loadImagesWithCache(urlString: profileImageURl)
        }
        containerView.addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        let nameLabel = UILabel()
        containerView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = user.name
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant : 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
    }
    func showChatControllerForUser(user : User){
    print("basıldı.")
    let chatController = ChatVC(collectionViewLayout: UICollectionViewFlowLayout())
        chatController.user = user
    navigationController?.pushViewController(chatController, animated: true)
        
    }
  

}

