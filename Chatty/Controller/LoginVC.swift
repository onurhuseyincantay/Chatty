//
//  LoginVC.swift
//  Chatty
//
//  Created by onur hüseyin çantay on 22/09/2017.
//  Copyright © 2017 onur hüseyin çantay. All rights reserved.
//

import UIKit
import Firebase
class LoginVC: UIViewController,UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        
        return true
    }
   lazy var segmentedControl : UISegmentedControl = {
        let items = ["Login","Register"]
        let smc = UISegmentedControl(items: items)
        smc.translatesAutoresizingMaskIntoConstraints = false
        smc.tintColor = UIColor.white
        smc.backgroundColor = UIColor(r: 80 , g: 101 , b: 161)
        smc.layer.cornerRadius = 5
        smc.selectedSegmentIndex = 1
        smc.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        smc.clipsToBounds = true
        return smc
    }()
    let inputContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        return view
    }()
    lazy var  profileimageview : UIImageView = {
       let imgView = UIImageView ()
        imgView.image = UIImage(named : "profile-pictures")
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.layer.cornerRadius = 25
        imgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(handleProfileImageViewSelection)))
        imgView.isUserInteractionEnabled = true
        
        return imgView
    }()
    let nameTextField : UITextField = {
      let textfield = UITextField()
        textfield.placeholder = "Name"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.returnKeyType = .done
        textfield.resignFirstResponder()
        return textfield
    }()
    let nameSeperatorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220,g:220,b:220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let emailTextField : UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Email"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.returnKeyType = .done
        return textfield
    }()
    let emailSeperatorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220,g:220,b:220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let passwordTextField : UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Password"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.isSecureTextEntry = true
        textfield.returnKeyType = .done
        textfield.resignFirstResponder()
        
        return textfield
    }()
   
   
    
  let loginRegisterBtn : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80 , g: 101 , b: 161)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.layer.borderWidth = 1.0;
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(handleRegisterAndLogin), for: .touchUpInside)
        return button
    }()
    @objc func segmentChanged (sender : UISegmentedControl) {
        let title = sender.titleForSegment(at: sender.selectedSegmentIndex)
        switch sender.selectedSegmentIndex {
        case 0 :
            loginRegisterBtn.setTitle(title, for: .normal)
            //change Height of COntainer View
            inputContainerViewHeightAnchor?.constant = 100
            nameTextFieldAnchor?.isActive = false
            nameTextFieldAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0)
            nameTextFieldAnchor?.isActive = true
           emailtextFieldAnchor?.isActive = false
            emailtextFieldAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/2)
            emailtextFieldAnchor?.isActive = true
            passwordHeightAnchor?.isActive = false
            passwordHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/2)
            emailtextFieldAnchor?.isActive = true
        case 1:
            loginRegisterBtn.setTitle(title, for: .normal)
            inputContainerViewHeightAnchor?.constant = 150
            nameTextFieldAnchor?.isActive = false
            nameTextFieldAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
            nameTextFieldAnchor?.isActive = true
            nameTextFieldAnchor?.isActive = true
            emailtextFieldAnchor?.isActive = false
            emailtextFieldAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
            emailtextFieldAnchor?.isActive = true
            passwordHeightAnchor?.isActive = false
            passwordHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
            emailtextFieldAnchor?.isActive = true
        default:break
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        view.addSubview(inputContainerView)
        view.addSubview(loginRegisterBtn)
        // need x , y  ,width , height
       setupContainerView()
       setupLoginRegistenButton()
        setupProfileImageView()

    }
    func setupProfileImageView(){
        profileimageview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileimageview.bottomAnchor.constraint(equalTo: segmentedControl.topAnchor, constant:-12).isActive = true
        profileimageview.heightAnchor.constraint(equalToConstant: 150).isActive = true
        profileimageview.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupLoginRegistenButton (){
        loginRegisterBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterBtn.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterBtn.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterBtn.heightAnchor.constraint(equalToConstant: 35).isActive = true
     
    }
    var inputContainerViewHeightAnchor : NSLayoutConstraint?
    var nameTextFieldAnchor : NSLayoutConstraint?
    var emailtextFieldAnchor : NSLayoutConstraint?
    var passwordHeightAnchor : NSLayoutConstraint?
    func setupContainerView (){
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
       inputContainerViewHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputContainerViewHeightAnchor?.isActive = true
        view.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor , constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo : inputContainerView.widthAnchor).isActive = true
        nameTextFieldAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldAnchor?.isActive = true
        
        view.addSubview(nameSeperatorView)
        nameSeperatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        nameSeperatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeperatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.addSubview(emailTextField)
        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor , constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo : inputContainerView.widthAnchor).isActive = true
        emailtextFieldAnchor =
        emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        emailtextFieldAnchor?.isActive = true
        view.addSubview(emailSeperatorView)
        emailSeperatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailSeperatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeperatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.addSubview(passwordTextField)
        passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor , constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo : inputContainerView.widthAnchor).isActive = true
       passwordHeightAnchor =
        passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        passwordHeightAnchor?.isActive = true
        view.addSubview(profileimageview)
        view.addSubview(segmentedControl)
        segmentedControl.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: profileimageview.bottomAnchor, constant : 12).isActive = true
        segmentedControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
        segmentedControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor ).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
extension UIColor {
    convenience init (r : CGFloat , g : CGFloat , b : CGFloat){
        self.init(red : r/255 ,green : g/255 , blue: b/255, alpha: 1)
    }
}
