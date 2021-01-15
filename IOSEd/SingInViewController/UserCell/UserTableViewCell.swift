//
//  UserTableViewCell.swift
//  IOSEd
//
//  Created by Anna Yatsun on 15.01.2021.
//

import UIKit

class UserTableViewCell: UITableViewCell {


    @IBOutlet weak var userImage: UIImageView?
    @IBOutlet weak var userName: UILabel?
    @IBOutlet weak var familiName: UILabel?
    func fill(user: User) {
        self.userName?.text = user.givenName
        self.familiName?.text = user.familyName
    }
}
