//
//  MessageModel.swift
//  inSociety
//
//  Created by Aleksey Libin on 26.10.2022.
//

import UIKit

struct MessageModel: Hashable {
    let content: String
    let senderID: String
    let senderUserName: String
    var sentDate: Date
    let id: String?
    
    init(user: UserModel, content: String) {
        self.content = content
        self.senderID = user.id
        self.senderUserName = user.userName
        self.sentDate = Date()
        self.id = nil
    }
    
    var representation: [String: Any] {
        var rep: [String: Any] = [
            "content": content,
            "senderID": senderID,
            "senderUserName": senderUserName,
            "sentDate": sentDate
        ]
        return rep
    }
}
