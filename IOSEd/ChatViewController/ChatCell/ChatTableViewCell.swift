//
//  ChatTableViewCell.swift
//  IOSEd
//
//  Created by Anna Yatsun on 14.01.2021.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var messagelabel: UILabel?
    
    
    func fill(message: Message) {
        self.nameLabel?.text = message.fromUserId
        self.messagelabel?.text = message.messega
    }
    
}
