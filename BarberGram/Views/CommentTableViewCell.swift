//
//  CommentTableViewCell.swift
//  BarberGram
//
//  Created by admin on 16/03/2019.
//  Copyright © 2019 Tom&Sean. All rights reserved.
//

import UIKit
import Firebase
class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var progileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var comment : Comment? {
        didSet{
            updateView()
        }
    }
    
    
    func updateView()
    {
        commentLabel.text = comment?.commentText
        setUpUserInfo()
    }
    
    
        func setUpUserInfo(){
            if let uid = comment?.uid{
                Database.database().reference().child("users").child(uid).observeSingleEvent(of: DataEventType.value, with: {
                    snapshot in
                    if let dict = snapshot.value as? [String:Any]{
                        let user = User.transformUser(dict: dict)
                        self.nameLabel.text = user.username
                        if let photoUrlString = user.imgUrl{
                            let photoUrl = URL(string: photoUrlString)
                            self.progileImage.sd_setImage(with: photoUrl)
                        }
    
                    }
                })
            }
        }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
