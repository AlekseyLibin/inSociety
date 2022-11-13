//
//  ChatModel.swift
//  inSociety
//
//  Created by Aleksey Libin on 18.10.2022.
//

import UIKit
import FirebaseFirestore

struct ChatModel: Hashable, Decodable {
    var friendName: String
    var friendAvatarString: String
    var lastMessageContent: String
    var friendID: String
    
    
    init(friendName: String, friendAvatarString: String, lastMessageContent: String, friendID: String) {
        self.friendName = friendName
        self.friendAvatarString = friendAvatarString
        self.lastMessageContent = lastMessageContent
        self.friendID = friendID
    }
    
    
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let friendName = data["friendName"] as? String,
              let friendAvatarString = data["friendAvatarURL"] as? String,
              let lastMessageContent = data["lastMessage"] as? String,
              let friendID = data["friendID"] as? String
        else { return nil }
        
        self.friendName = friendName
        self.friendAvatarString = friendAvatarString
        self.lastMessageContent = lastMessageContent
        self.friendID = friendID

    }
    
    
    var representation: [String: Any] {
        let rep: [String: Any] = [
            "friendName": friendName,
            "friendAvatarURL": friendAvatarString,
            "lastMessage": lastMessageContent,
            "friendID": friendID
        ]
        return rep
    }
    
    
    func contains(filter: String?) -> Bool {
        guard let filter = filter, filter.isEmpty == false else { return true }
        
        let lowercasedFilter = filter.lowercased()
        return friendName.lowercased().contains(lowercasedFilter)
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendID)
    }
    
    static func == (lhs: ChatModel, rhs: ChatModel) -> Bool {
        return lhs.friendID == rhs.friendID
    }
}
