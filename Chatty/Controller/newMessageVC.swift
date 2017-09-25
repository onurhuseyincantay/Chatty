//
//  newMessageVC.swift
//  Chatty
//
//  Created by onur hüseyin çantay on 23/09/2017.
//  Copyright © 2017 onur hüseyin çantay. All rights reserved.
//

import UIKit
import Firebase
class newMessageVC: UITableViewController{
    let cellId = "cellId"
    var users = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        fetchUser()
    }
    func fetchUser()  {
        Firebase.Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dict = snapshot.value as? [String:AnyObject]{
                let user = User()
                user.name = dict["Names"] as? String
                user.email = dict["Email"] as? String
                user.userId = snapshot.key
                user.profileImageUrl = dict["ProfileImageURL"] as? String
                self.users.append(user)
                print(user.name!)
            }
            self.tableView.reloadData()
        }, withCancel: nil)
    }
 @objc  func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        if let profileImgUrl = user.profileImageUrl{
            cell.profileImageView.loadImagesWithCache(urlString: profileImgUrl)
            }
        
        return cell
    }
    var messagesController : MessagesVC?
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            let user = self.users[indexPath.row]
            self.messagesController?.showChatControllerForUser(user: user)
            print("MessageController geldi")
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
}
