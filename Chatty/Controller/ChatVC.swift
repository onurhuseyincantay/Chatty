//
//  ChatVC.swift
//  Chatty
//
//  Created by onur hüseyin çantay on 24/09/2017.
//  Copyright © 2017 onur hüseyin çantay. All rights reserved.
//

import Firebase
import UIKit

class ChatVC: UICollectionViewController,UITextFieldDelegate {
    
    var user : User? {
        didSet{
            navigationItem.title = user?.name
        }
    }
    lazy var inputTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Messages ... "
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.returnKeyType = .done
        return textField
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextField.delegate = self
        collectionView?.backgroundColor = UIColor.white
        setupInputComponent()
    }
    func setupInputComponent()  {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        let sendButton = UIButton(type: .system)
        containerView.addSubview(sendButton)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        containerView.addSubview(inputTextField)
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor ,constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.rightAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        let seperatorView = UIView ()
        seperatorView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(seperatorView)
        seperatorView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        seperatorView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        seperatorView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true

    }
   @objc func handleSend()  {
        let ref = Firebase.Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user!.userId!
    let fromId = Firebase.Auth.auth().currentUser!.uid
    let timestamp  = Date().timeIntervalSince1970
    let values : [String:AnyObject] = ["text": inputTextField.text! as AnyObject,"toId": toId as AnyObject,"fromId":fromId as AnyObject,"timestamp": timestamp as AnyObject]
        childRef.updateChildValues(values)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}
