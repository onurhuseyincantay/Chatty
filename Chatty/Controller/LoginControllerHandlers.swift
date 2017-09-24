//
//  LoginControllerHandlers.swift
//  Chatty
//
//  Created by onur hüseyin çantay on 23/09/2017.
//  Copyright © 2017 onur hüseyin çantay. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension LoginVC:UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
   
 @objc  func handleRegisterAndLogin(){
        if segmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        }else{
            handleRegister()
            
        }
    }
    func handleLogin()  {
        guard let email = emailTextField.text ,let  password = passwordTextField.text else {
            print("form is not valid")
            return
        }
        Firebase.Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error.debugDescription)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
        @objc func handleRegister() {
        guard let email = emailTextField.text, let  password = passwordTextField.text , let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        Firebase.Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error.debugDescription)
                return
            }
            guard let uid = user?.uid else{
                return
            }
            let imageName = NSUUID().uuidString
            let storageRef = Firebase.Storage.storage().reference().child("profile_images").child("\(imageName).png")
            
            if let uploadData = UIImagePNGRepresentation(self.profileimageview.image!){
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error.debugDescription)
                        return
                    }
                    if let imageDownloadUrl = metadata?.downloadURL()?.absoluteString {
                        let values = ["Names": name , "Email": email , "Password": password,"ProfileImageURL":imageDownloadUrl]
                        self.registeringUserWithUID(uid: uid, values: values as [String : AnyObject])
                    }
                })
            }
            
            
            
        }
            self.dismiss(animated: true, completion: nil)
    }
    
    func registeringUserWithUID(uid: String ,values : [String:AnyObject])  {
        let ref = Database.database().reference(fromURL: _DATABASE_REF)
        let childRef = ref.child("users").child(uid)
        childRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err.debugDescription)
                return
            }
            print("Onur : Kullanıcı Kaydedildi")
        })
    }
    
    
    
    
    
    @objc  func handleProfileImageViewSelection(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker : UIImage?
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
         selectedImageFromPicker = editedImage
        }else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileimageview.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Onur: Canceled")
        dismiss(animated: true, completion: nil)
    }
}
