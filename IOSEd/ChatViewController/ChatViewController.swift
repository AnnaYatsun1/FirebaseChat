//
//  ChatViewController.swift
//  IOSEd
//
//  Created by Anna Yatsun on 12.01.2021.
//

import UIKit
import AuthenticationServices
import Firebase
import FirebaseAuth

class ChatViewController: UIViewController {

    @IBOutlet weak var chatTableView: UITableView?
    @IBOutlet weak var messageTextView: UITextView?
    var chatApp: ChatApp?
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chatTableView?.dataSource = self
        self.chatTableView?.delegate = self
        self.chatTableView?.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewCell")
        let play = UIBarButtonItem(title: "Play", style: .plain, target: self, action: #selector(playTapped))
        navigationItem.rightBarButtonItems = [play]
        let dataBase = DatabaseManager()
        dataBase.loadMessge() { [weak self] messages in
            guard let self = self else { return }
            self.messages = messages
            self.chatTableView?.reloadData()
        }
    }
    
    

    @objc
    func playTapped() {
        print("action")
        try? Auth.auth().signOut()
        self.dismiss(animated: false)
    }


    @IBAction func snadButtonAction(_ sender: Any) {
        
        let dataBase = DatabaseManager()
        let data = UserDefaults.standard.data(forKey: "myUser")
        data.map {
            guard let user = try? JSONDecoder().decode(User.self, from: $0) else { return }
            let message = Message(id: nil, fromUserId: user.userId ?? "", messega: self.messageTextView?.text ?? "", isRead: false)
            self.messages.append(message)
            self.chatTableView?.reloadData()
            let indexpath = IndexPath.init(row: self.messages.count - 1, section: 0)
            self.chatTableView?.scrollToRow(at: indexpath, at: .bottom, animated: true)
           
            let chatApp = ChatApp(id: UUID(), user: user, messages: self.messages)
            self.chatApp = chatApp
           dataBase.write(with: chatApp)
        }

    }
    
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count \(self.messages.count)" )
        return self.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as? ChatTableViewCell
        cell?.fill(message: self.messages[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    
}
