//
//  MessageModel.swift
//  inSociety
//
//  Created by Aleksey Libin on 26.10.2022.
//

import UIKit
import MessageKit
import FirebaseFirestore

struct MessageModel: Hashable, MessageType {
    
    var sender: MessageKit.SenderType
    let content: String
    var sentDate: Date
    let id: String?
    
    var kind: MessageKit.MessageKind {
        return .text(content)
    }
    var messageId: String {
        return id ?? UUID().uuidString
    }

    
    init(user: UserModel, content: String) {
        self.content = content
        sender = Sender(senderID: user.id, senderName: user.userName)
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
        
        self.sender = Sender(senderID: senderID, senderName: senderUserName)
        self.sentDate = sentDate.dateValue()
        self.id = document.documentID
        self.content = content
    }
    
    var representation: [String: Any] {
        let rep: [String: Any] = [
            "content": content,
            "senderID": sender.senderId,
            "senderUserName": sender.displayName,
            "sentDate": sentDate
        ]
        return rep
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
    }
    
    static func == (lhs: MessageModel, rhs: MessageModel) -> Bool {
        return lhs.messageId == rhs.messageId
    }
    
}
extension MessageModel: Comparable {
    static func < (lhs: MessageModel, rhs: MessageModel) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
    
    
}
