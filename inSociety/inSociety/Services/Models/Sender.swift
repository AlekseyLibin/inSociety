//
//  SenderModel.swift
//  inSociety
//
//  Created by Aleksey Libin on 28.10.2022.
//

import MessageKit

class Sender: SenderType {
    var senderId: String
    
    var displayName: String
    
    init(senderID: String, senderName: String) {
        self.senderId = senderID
        self.displayName = senderName
    }
    
}
