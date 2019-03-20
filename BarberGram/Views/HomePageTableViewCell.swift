//
//  HomePageTableViewCell.swift
//  BarberGram
//
//  Created by admin on 06/03/2019.
//  Copyright © 2019 Tom&Sean. All rights reserved.
//

import UIKit
import Firebase
class HomePageTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    
    var homeVC : HomePageViewController?
    var post : Post?{
        didSet{
             updateView()
        }
    }
    
    func updateView()
    {
        captionLabel.text = post?.caption
        if let photoUrlString = post?.photoUrl{
            let photoUrl = URL(string: photoUrlString)
            postImageView.sd_setImage(with: photoUrl)
        }
        setUpUserInfo()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func commentButton(_ sender: Any) {
        if let id = post?.id{
             homeVC?.performSegue(withIdentifier: "CommentSeque", sender: id)
        }
        
    }
    
    
    
    func setUpUserInfo(){
        if let uid = post?.uid{
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: DataEventType.value, with: {
                snapshot in
                if let dict = snapshot.value as? [String:Any]{
                    let user = User.transformUser(dict: dict)
                   self.nameLabel.text = user.username
                    if let photoUrlString = user.imgUrl{
                        let photoUrl = URL(string: photoUrlString)
                        self.profileImage.sd_setImage(with: photoUrl)

                    }

                }
            })
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    
    }

}
