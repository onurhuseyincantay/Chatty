//
//  LoginVC.swift
//  Chatty
//
//  Created by onur hüseyin çantay on 22/09/2017.
//  Copyright © 2017 onur hüseyin çantay. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    let inputContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        return view
    }()
    let profileimageview : UIImageView = {
       let imgView = UIImageView ()
        imgView.image = UIImage(named : "profile-pictures")
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    let nameTextField : UITextField = {
      let textfield = UITextField()
        textfield.placeholder = "Name"
        textfield.translatesAutoresizingMaskIntoConstraints = false
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
        return textfield
    }()
   
    let loginRegisterBtn : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80 , g: 101 , b: 161)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        profileimageview.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant:-12).isActive = true
        profileimageview.heightAnchor.constraint(equalToConstant: 150).isActive = true
        profileimageview.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupLoginRegistenButton (){
        loginRegisterBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterBtn.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterBtn.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterBtn.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    func setupContainerView (){
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        view.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor , constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo : inputContainerView.widthAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        view.addSubview(nameSeperatorView)
        nameSeperatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        nameSeperatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeperatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.addSubview(emailTextField)
        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor , constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo : inputContainerView.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        view.addSubview(emailSeperatorView)
        emailSeperatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailSeperatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeperatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.addSubview(passwordTextField)
        passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor , constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo : inputContainerView.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        view.addSubview(profileimageview)
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
