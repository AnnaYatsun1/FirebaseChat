//
//  UserListViewController.swift
//  IOSEd
//
//  Created by Anna Yatsun on 15.01.2021.
//

import UIKit

class UserListViewController: UIViewController {

    @IBOutlet weak var userTableView: UITableView?
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userTableView?.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
        let dataManeger = DataMenegerSecond()
        dataManeger.loadUser {[weak self] users in
            self?.users = users
            self?.userTableView?.reloadData()
            
        }
    }
}

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as? UserTableViewCell
        cell?.fill(user: self.users[indexPath.row])
        return cell ?? UITableViewCell()
        
    }
  
}
