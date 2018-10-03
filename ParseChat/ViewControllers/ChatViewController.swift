//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Francisco Hernanedez on 10/2/18.
//  Copyright © 2018 Francisco Hernanedz. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var messages = [String]()
    var usernames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        // Auto size row height based on cell autolayout constraints
        tableView.rowHeight = UITableViewAutomaticDimension
        // Provide an estimated row height. Used for calculating scroll indicator
        tableView.estimatedRowHeight = 50
        tableView.separatorStyle = .none
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ChatViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.fetchMessages(_:)), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    
    @objc func fetchMessages(_ sender:Any?){
        
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        
        let query = PFQuery(className: "Message")
        query.includeKey("user")
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground { (messages, error) in
            if(messages != nil){
                self.messages = []
                self.usernames = []
                
                for message in messages!{
                    //                    print(message)
                    self.messages.append(message["text"] as! String)
                    if(message["user"] != nil){
                        self.usernames.append((message["user"] as! PFUser).username!)
                    }
                    else{
                        self.usernames.append("🤖")
                    }
                }
                self.tableView.reloadData()
            }
            else{
                print("Info:! (error?.localizedDescription)")
            }
        }
        self.refreshControl.endRefreshing()
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl){
        fetchMessages(Any?.self)
    }
    
    @IBAction func SendTapped(_ sender: Any) {
        let chatMessage = PFObject(className: "Message")
        chatMessage["text"] = messageField.text ?? ""
        //        chatMessage["user"] = PFUser.current()?.username!
        //        print(PFUser.current()?.username as! String)
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
        messageField.text = ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        cell.bubbleView.layer.cornerRadius = 16
        cell.bubbleView.clipsToBounds = true
        let message = messages[indexPath.row]
        let username = usernames[indexPath.row]
        print(message)
        print(username)
        cell.messageLabel.text = message
        cell.userLabel.text = username
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
