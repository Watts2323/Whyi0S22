//
//  ReasonTableViewController.swift
//  WhyiOS22
//
//  Created by Xavier on 10/17/18.
//  Copyright © 2018 Xavier ios dev. All rights reserved.
//

import UIKit

class ReasonTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPost()
    }
    
    
    func fetchPost() {
        PostController.sharedInstance.fetchPost { (success) in
            
            if success{
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self.title = "There was a error with your request"
                }
            }
        }
    }
    
    
    
    
    @IBAction func plusButtonPressed(_ sender: UIBarButtonItem) {
        presentAlertController()
    }
    
    
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        PostController.sharedInstance.fetchPost { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return PostController.sharedInstance.posts.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reasonCell", for: indexPath)
        
        let post = PostController.sharedInstance.posts[indexPath.row]
        
        cell.textLabel?.text = post.reason
        
        // Configure the cell...
        
        return cell
    }
}

extension ReasonTableViewController {
    
    func presentAlertController(){
        
        var nameTextFieldForReason: UITextField?
        var reasonTextFieldForReason: UITextField?
        // var cohortTextFieldForReason: UITextField?
        
        let alertController = UIAlertController(title: "Add your reason", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (nameTextField) in
            nameTextField.placeholder = "Enter Your Name"
            nameTextFieldForReason = nameTextField
            
        }
        
        alertController.addTextField { (reasonTextField) in
            reasonTextField.placeholder = "Why iOS22"
            reasonTextFieldForReason = reasonTextField
        }
        
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Add Reason", style: .default) { (_) in
            guard let name = nameTextFieldForReason?.text,
                let reason = reasonTextFieldForReason?.text else {return }
            PostController.sharedInstance.postReason(with: name, name: reason, completion: { (success) in
                if success {
                    DispatchQueue.main.async {
                        //self.title = "there was an error with your request"
                        self.tableView.reloadData()
                    }
                }
            })
        }
        alertController.addAction(dismissAction)
        alertController.addAction(saveAction)
        
        present(alertController, animated: true)
    }
    
}
