//
//  MessageModel.swift
//  inSociety
//
//  Created by Aleksey Libin on 26.10.2022.
//

import UIKit
import FirebaseFirestore

struct MessageModel: Hashable {
    let content: String
    let senderID: String
    let senderUserName: String
    var sentDate: Date
    let id: String?
    
    init(user: UserModel, content: String) {
        self.content = content
        senderID = user.id
        senderUserName = user.userName
        sentDate = Date()
        id = nil
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard
            let content = data["content"] as? String,
            let senderID = data["senderID"] as? String,
            let senderUserName = data["senderUserName"] as? String,
            let sentDate = data["sentDate"] as? Timestamp
        else { return nil }
        
        self.senderID = senderID
        self.senderUserName = senderUserName
        self.sentDate = sentDate.dateValue()
        self.id = document.documentID
        self.content = content
    }
    
    var representation: [String: Any] {
        let rep: [String: Any] = [
            "content": content,
            "senderID": senderID,
            "senderUserName": senderUserName,
            "sentDate": sentDate
        ]
        return rep
    }
}
