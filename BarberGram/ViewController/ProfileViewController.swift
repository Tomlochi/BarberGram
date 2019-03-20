//
//  ProfileViewController.swift
//  BarberGram
//
//  Created by admin on 23/02/2019.
//  Copyright © 2019 Tom&Sean. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage
import ProgressHUD

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
     var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        let currentUserId = Auth.auth().currentUser?.uid
        self.loadUserInfo(id: currentUserId!)
        loadPost()
        self.tableView.rowHeight = 300
        self.tableView.estimatedRowHeight = 521
    }
    
    func loadPost(){
        let currentUserId = Auth.auth().currentUser?.uid
        Database.database().reference().child("posts").observe(.childAdded){(snapshot:DataSnapshot) in
            if let dict = snapshot.value as? [String:Any]{
                let caption = dict["caption"] as! String
                let photoUrl = dict["photoUrl"] as! String
                let uid = dict["uid"] as! String
                
                let post = Post(uid: uid, caption: caption, photoUrl: photoUrl)
                
                if(currentUserId == post.uid){
                    self.posts.append(post)
                }
                self.tableView.reloadData()
            }
        }
       
    }
    
    
    func loadUserInfo(id : String){ Database.database().reference().child("users").child(id).observeSingleEvent(of: DataEventType.value, with: {
                snapshot in
                if let dict = snapshot.value as? [String:Any]{
                    let user = User.transformUser(dict: dict)
                    self.usernameLabel.text = user.username
                    if let photoUrlString = user.imgUrl{
                        let photoUrl = URL(string: photoUrlString)
                        self.profileImage.sd_setImage(with: photoUrl)
                        self.profileImage.layer.cornerRadius = 20
                        self.profileImage.clipsToBounds = true
                    }
                    
                }
            })
    }
}




extension ProfileViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profilePostCell", for: indexPath) as! ProfileTableViewCell
        let post = posts[indexPath.row]
        cell.post = post
        cell.caption.text = post.caption
        
        
        return cell
        
    }
}
