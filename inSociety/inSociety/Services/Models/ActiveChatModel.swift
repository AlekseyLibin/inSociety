//
//  ActiveChatModel.swift
//  inSociety
//
//  Created by Aleksey Libin on 18.10.2022.
//

import UIKit
import Foundation

struct ActiveChatModel: Hashable, Decodable {
    var userName: String
    var userAvatarString: String
    var lastMessage: String
    var id: Int
    
    
    
    func contains(filter: String?) -> Bool {
        guard let filter = filter, filter.isEmpty == false else { return true }
        
        let lowercasedFilter = filter.lowercased()
        return userName.lowercased().contains(lowercasedFilter)
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ActiveChatModel, rhs: ActiveChatModel) -> Bool {
        return lhs.id == rhs.id
    }
}
