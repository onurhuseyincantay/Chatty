//
//  UserCell.swift
//  Chatty
//
//  Created by onur hüseyin çantay on 25/09/2017.
//  Copyright © 2017 onur hüseyin çantay. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
    
    var message : Message? {
        didSet{
           
            self.setupNameAndProfileImg()
            
            if let seconds = self.message?.timestamp?.doubleValue {
                let date = Date(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                let dateString = dateFormatter.string(from: date)
                self.timeLabel.text = dateString
        }
        }}
    func setupNameAndProfileImg()  {
        if let Id = message?.getChatPartnerId(){
            let ref = Firebase.Database.database().reference().child("users").child(Id)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? Dictionary<String,AnyObject> {
                    
                    self.textLabel?.text = dict["Names"] as? String
                    if let profileImageUrl = dict["ProfileImageURL"] as? String{
                        self.profileImageView.loadImagesWithCache(urlString: profileImageUrl)
                    }
                }
                
            }, withCancel: nil)
            
        }
    self.detailTextLabel?.text = self.message?.text
    }

    
   
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y-2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y+2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        return imageView
    }()
    let timeLabel : UILabel = {
        let timelabel = UILabel()
        
        timelabel.font = timelabel.font.withSize(12)
        timelabel.textColor = UIColor.lightGray
        timelabel.translatesAutoresizingMaskIntoConstraints = false
        return timelabel
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(timeLabel)
        //added constraints to an custom UIimageView
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor , constant : 15).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


