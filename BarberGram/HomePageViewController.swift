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
class HomePageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var posts = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        loadPost()
        //var Post = Posts(captionText: "text", photoUrlString: "url")
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        cell.textLabel?.text = posts[indexPath.row].caption
        return cell
        
    }
}



