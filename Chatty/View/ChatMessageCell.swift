//
//  ChatMessageCell.swift
//  Chatty
//
//  Created by onur hüseyin çantay on 28.09.2017.
//  Copyright © 2017 onur hüseyin çantay. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    let textview : UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = "Örnek Mesaj"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = UIColor.white
        tv.backgroundColor = UIColor.clear
        return tv
    }()
    
    let profileImageView : UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 16
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    
    static let blueColor = UIColor(r : 0, g: 137, b: 249)
    
    let bubbleView : UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = blueColor
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()
    var bubbleWidthAnchor : NSLayoutConstraint?
    var bubbleViewRightAnchor : NSLayoutConstraint?
    var bubbleViewLeftAnchor : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        addSubview(textview)
        addSubview(profileImageView)
        
        textview.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant : 8).isActive = true
        textview.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textview.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textview.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor ,constant : -8)
            bubbleViewRightAnchor?.isActive = true
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        bubbleViewLeftAnchor?.isActive = false
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant : 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
