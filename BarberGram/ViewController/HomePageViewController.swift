//
//  HomePageViewController.swift
//  BarberGram
//
//  Created by admin on 25/02/2019.
//  Copyright © 2019 Tom&Sean. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class HomePageViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var posts = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        loadPost()
        
        self.tableView.rowHeight = 600
        self.tableView.estimatedRowHeight = 521
        
    }
    
    func loadPost(){
        Database.database().reference().child("posts").observe(.childAdded){(snapshot:DataSnapshot) in
            if let dict = snapshot.value as? [String:Any]{
                let newPost = Post.transformPost(dict: dict)
                self.posts.append(newPost)
                self.tableView.reloadData()
            }
        }
    }
    
    
    @IBAction func logoutButton(_ sender: Any) {
        
        do {
            try  Auth.auth().signOut()
        }catch let logoutError{
            print (logoutError)
        }
        
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let signInVc = storyBoard.instantiateInitialViewController()
        self.present(signInVc!, animated: true, completion: nil)
    }
    
}

extension HomePageViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomePageTableViewCell
        let post = posts[indexPath.row]
        cell.post = post
        
        
        cell.profileImage.layer.cornerRadius = 18
        cell.profileImage.clipsToBounds = true
        
        
        return cell
        
    }
}



