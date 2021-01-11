//
//  DataBaseManager.swift
//  IOSEd
//
//  Created by Anna Yatsun on 11.01.2021.
//

import Foundation
import FirebaseDatabase

class DatabaseManager {
    
    let dataBase = Database.database().reference()
    
    func writeMessage() {
        self.dataBase.child("TEST").setValue(["message" : "HoHoHo"])
    }
}
