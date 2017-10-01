//
//  ChatVC.swift
//  Chatty
//
//  Created by onur hüseyin çantay on 24/09/2017.
//  Copyright © 2017 onur hüseyin çantay. All rights reserved.
//

import Firebase
import UIKit

class ChatVC: UICollectionViewController,UITextFieldDelegate,UICollectionViewDelegateFlowLayout {
    
    var user : User? {
        didSet{
            navigationItem.title = user?.name
            observeMessages()
        }
    }
    var messages = [Message]()
    lazy var inputTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Messages ... "
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextField.delegate = self
        collectionView?.keyboardDismissMode = .interactive
        collectionView?.alwaysBounceVertical = true
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0   )
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0   )
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.delegate = self
//        setupInputComponent()
//        setupKeyboardObservers()
    }
    
    lazy var inputContainerView : UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = UIColor.white
        let textfield = UITextField()
        textfield.backgroundColor = UIColor.brown
        containerView.addSubview(textfield)
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
        
        return containerView
        
    }()
    override var canBecomeFirstResponder: Bool{return true}
    override var inputAccessoryView: UIView?{
        get{
            return inputContainerView
        }
    }
    //This is the second Way of dissmising keyboard but with animation i thin is better so I let it here :)
//    func setupKeyboardObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidEnd), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//    }
//    @objc func handleKeyboardDidEnd(notification : NSNotification){
//        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
//        containerViewConstraint?.constant = 0
//        UIView.animate(withDuration: keyboardDuration) {
//            self.view.layoutIfNeeded()
//        }
//    }
//    @objc func handleKeyboardWillShow (notification : NSNotification){
//        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
//        UIView.animate(withDuration: keyboardDuration) {
//            self.view.layoutIfNeeded()
//        }
//        //move the input  area :)
//        containerViewConstraint?.constant = -keyboardFrame.height
//
//    }
//    override func viewDidDisappear(_ animated: Bool) {
//        //it Stacks if you dont use this and after a time your program will slowdown
//        NotificationCenter.default.removeObserver(self)
//    }
    
    func observeMessages(){
        guard let uid = Firebase.Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Firebase.Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let messagesRef = Firebase.Database.database().reference().child("messages").child(snapshot.key)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dict = snapshot.value as? Dictionary<String,AnyObject> else{
                    return
                }
                let message = Message()
                message.fromId = dict["fromId"] as? String
                message.text = dict["text"] as? String
                message.timestamp = dict["timestamp"] as? NSNumber
                message.toId = dict["toId"] as? String
                if message.getChatPartnerId() == self.user?.userId {
                    self.messages.append(message)
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
                
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.item]
        setupCell(cell: cell, message: message)
        cell.textview.text = message.text
        cell.bubbleWidthAnchor?.constant = estimatedFrameForText(text: message.text!).width + 32
        return cell
    }
    
    
    private func setupCell (cell : ChatMessageCell , message : Message){
        
        if let ProfileImageURL = self.user?.profileImageUrl {
            cell.profileImageView.loadImagesWithCache(urlString: ProfileImageURL)
        }
        
        
        if message.fromId == Firebase.Auth.auth().currentUser?.uid{
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textview.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        }else{
            cell.bubbleView.backgroundColor = UIColor(r: 242  , g: 242, b: 242)

            cell.textview.textColor = UIColor.black
            cell.profileImageView.isHidden = false
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height : CGFloat!
        
        if let text = messages[indexPath.item].text{
            height = estimatedFrameForText(text: text).height + 15
        } 
        return CGSize(width: view.frame.width, height: height)
    }
    
    
    func estimatedFrameForText(text : String) -> CGRect {
        //var olan yazının boy hesaplamasını aşağıdaki gibi yapılır
       let size = CGSize(width: 200, height: 1000)
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        
        return NSString(string: text).boundingRect(with: size, options: option, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16)], context: nil)
    }
    var containerViewConstraint : NSLayoutConstraint?
    func setupInputComponent()  {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerViewConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewConstraint?.isActive = true
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
    if inputTextField.text == nil || inputTextField.text == ""{
        return
    }
        let ref = Firebase.Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user!.userId!
    let fromId = Firebase.Auth.auth().currentUser!.uid
    let timestamp  = Date().timeIntervalSince1970
    let values : [String:AnyObject] = ["text": inputTextField.text! as AnyObject,"toId": toId as AnyObject,"fromId":fromId as AnyObject,"timestamp": timestamp as AnyObject]
        //childRef.updateChildValues(values)
    childRef.updateChildValues(values) { (error, ref) in
        if error != nil {
            print(error.debugDescription)
            return
        }
        
        self.inputTextField.text = nil
        let userMessageRef = Firebase.Database.database().reference().child("user-messages").child(fromId)
        let messageId = childRef.key
        userMessageRef.updateChildValues([messageId : 1])
        let userGetMessageRef = Firebase.Database.database().reference().child("user-messages").child(toId)
        userGetMessageRef.updateChildValues([messageId : 1])
    }
    
}
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        textField.resignFirstResponder()
        return true
    }
}
