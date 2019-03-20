//
//  CommentViewController.swift
//  BarberGram
//
//  Created by admin on 16/03/2019.
//  Copyright © 2019 Tom&Sean. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CommentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var postId:String!
    var comments = [Comment]()
    var users = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
         tableView.dataSource = self 
        empty()
        handleTextFiled()
        self.tableView.rowHeight = 100
      
        loadComments()
    }
    
    func loadComments(){
//        let postId = "La61qXpVvv-vvm_Y__9"
        print("the post id is : " , self.postId)
        
        let postCommentRef = Database.database().reference().child("post-comments").child(self.postId)
        if commentTextField.text != nil{
        postCommentRef.observe(.childAdded, with: {
            snapshot in
            Database.database().reference().child("comments").child(snapshot.key).observeSingleEvent(of: .value, with: {
                snapshotComment in
                if let dict = snapshotComment.value as? [String:Any]{
                    let newComment = Comment.transformComment(dict: dict)
                    self.comments.append(newComment)
                    self.tableView.reloadData()
                }
            })
        })
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        
    }

    @IBAction func sendButton(_ sender: Any) {
        Model.instance.sendCommentDataToDatabase(comment: commentTextField.text!, postId: self.postId)
        self.empty()
    }
    
    func empty(){
        self.commentTextField.text = ""
        self.sendButton.isEnabled = false
         sendButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
    }
    
    func handleTextFiled (){
        commentTextField.addTarget(self, action: #selector(self.textFileDidChange), for: UIControl.Event.editingChanged)
    }
    
    
    @objc func textFileDidChange() {
        sendButton.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        sendButton.isEnabled = true
    }
    
    
}


extension CommentViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        let comment = comments[indexPath.row]
        cell.comment = comment
       
        cell.progileImage.layer.cornerRadius = 18
        cell.progileImage.clipsToBounds = true
        
        
        return cell
        
    }
}
