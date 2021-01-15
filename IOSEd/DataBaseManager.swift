//
//  DataBaseManager.swift
//  IOSEd
//
//  Created by Anna Yatsun on 11.01.2021.
//

import Foundation
import FirebaseDatabase
import FirebaseFirestore
import FirebaseAuth

class DatabaseManager {
    
    let dataBase = Database.database().reference()
   // let message: Message = []
    
    func write(with message: ChatApp) {
        message.messages.last.map {
            self.dataBase.childByAutoId().setValue([
                "message": $0.messega,
                "fromUserId": $0.fromUserId,
                "IsRead": $0.isRead?.description
            ])
        }

        

//        self.dataBase.updateChildValues([message.user.fullName: message.messages])
    }

    
    func loadMessge(completion:  @escaping ([Message]) -> ()) {
        self.dataBase.observeSingleEvent(of: .value) {

    
            
            let dictionary = $0.value as? NSDictionary
            let messages = dictionary?.allKeys.map { key -> Message in
                let keyValue = (key as? String) ?? ""
                let messageValue = dictionary?[keyValue] as? NSDictionary
                let message = messageValue?["message"] as? String
                let fromUserId = messageValue?["fromUserId"] as? String
                var IsRead: Bool
                switch messageValue?["IsRead"] as? String {
                case "true":
                    IsRead = true
                case "false":
                    IsRead = false
                default:
                    IsRead = false
                }
                
                
                return Message(id: keyValue, fromUserId: fromUserId, messega: message, isRead: IsRead)
            } ?? []
            
            print(messages.count)
            completion(messages)
            
        }
    }
}

struct ChatApp {
    let id: UUID?
    let user: User
    let messages: [Message]
   // var createdAt: Date?
}


struct Message: Codable {
    let id: String?
    let fromUserId: String?
    let messega: String?
    let isRead:Bool?
    
}


class DataMenegerSecond {
    let dataBase = Database.database().reference(withPath: "users")
    
    func write(with user: User) {
        self.dataBase.child(user.userId ?? "").setValue([
            "userId": user.userId,
            "familyName": user.familyName,
            "fullName": user.fullName,
            "givenName": user.givenName,
            "email": user.email
        ])
    }
    
    func loadUser(completion: @escaping ([User]) -> ())  {
        self.dataBase.observeSingleEvent(of: .value) {
            print($0)
            let dictionary = $0.value as? NSDictionary
            let aaa = dictionary?.allKeys.map {  userKey -> User in
               let user =  dictionary?[userKey] as? NSDictionary
                
                let familyName = user?["familyName"] as? String
                let givenName = user?["givenName"] as? String
                let fullName = user?["fullName"] as? String
                let userId = user?["userId"] as? String
                let email = user?["email"] as? String
                return User(userId: userId, idToken: nil, fullName: fullName, givenName: givenName, familyName: familyName, email: email)

            }
            completion(aaa ?? [])
        }
        
    }
}
