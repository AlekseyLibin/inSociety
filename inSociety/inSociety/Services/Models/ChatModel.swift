//
//  ChatModel.swift
//  inSociety
//
//  Created by Aleksey Libin on 18.10.2022.
//

import UIKit
import Foundation

struct ChatModel: Hashable, Decodable {
    var friendName: String
    var friendAvatarString: String
    var lastMessageContent: String
    var friendID: String
    
    
    var representation: [String: Any] {
        var rep: [String: Any] = [
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
