//
//  ProfileTableViewCell.swift
//  BarberGram
//
//  Created by admin on 20/03/2019.
//  Copyright © 2019 Tom&Sean. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var caption: UILabel!
    
    var post : Post?{
        didSet{
            updateView()
        }
    }
    
    func updateView()
    {
        caption.text = post?.caption
        if let photoUrlString = post?.photoUrl{
            let photoUrl = URL(string: photoUrlString)
            postImage.sd_setImage(with: photoUrl)
        }
         //setUpUserInfo()
    }
    

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
