//
//  SenderModel.swift
//  inSociety
//
//  Created by Aleksey Libin on 28.10.2022.
//

import MessageKit

final class Sender: SenderType {
  var senderId: String
  
  var displayName: String
  
  init(senderID: String, senderName: String) {
    self.senderId = senderID
    self.displayName = senderName
  }
  
  static func == (lhs: Sender, rhs: Sender) -> Bool {
    guard lhs.senderId == rhs.senderId,
          lhs.displayName == rhs.displayName else { return false }
    return true
  }
}

