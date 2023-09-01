//
//  MessageModel.swift
//  inSociety
//
//  Created by Aleksey Libin on 26.10.2022.
//

import UIKit
import MessageKit
import FirebaseFirestore

struct MessageModel {
    
    var sender: MessageKit.SenderType
    let content: String
    var sentDate: Date
    var read: Bool
    let id: String?
    
  init(user: UserModel, content: String) {
        self.content = content
        sender = Sender(senderID: user.id, senderName: user.fullName)
        sentDate = Date()
        read = false
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
            let read = data["read"] as? Bool ?? false
        
        self.sender = Sender(senderID: senderID, senderName: senderUserName)
        self.sentDate = sentDate.dateValue()
        self.read = read
        self.id = document.documentID
        self.content = content
    }
    
    var representation: [String: Any] {
        let rep: [String: Any] = [
            "content": content,
            "senderID": sender.senderId,
            "senderUserName": sender.displayName,
            "sentDate": sentDate,
            "read": read
        ]
        return rep
    }
    
}

// MARK: - MessageType
extension MessageModel: MessageType {
  var kind: MessageKit.MessageKind {
      return .text(content)
  }
  var messageId: String {
      return id ?? UUID().uuidString
  }
}

// MARK: - Hashable
extension MessageModel: Hashable {
  func hash(into hasher: inout Hasher) {
      hasher.combine(messageId)
  }
  
  static func == (lhs: MessageModel, rhs: MessageModel) -> Bool {
      return lhs.messageId == rhs.messageId
  }
}

// MARK: - Comparable
extension MessageModel: Comparable {
    static func < (lhs: MessageModel, rhs: MessageModel) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
    
}

// MARK: - Decodable
extension MessageModel: Decodable {
  private enum CodingKeys: String, CodingKey {
      case sender, content, sentDate, read, id
  }
  
  private enum SenderCodingKeys: String, CodingKey {
      case senderID, senderUserName
  }

  init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      content = try container.decode(String.self, forKey: .content)
      sentDate = try container.decode(Date.self, forKey: .sentDate)
      id = try container.decodeIfPresent(String.self, forKey: .id)
      read = try container.decode(Bool.self, forKey: .read)
      
      let senderContainer = try container.nestedContainer(keyedBy: SenderCodingKeys.self, forKey: .sender)
      let senderID = try senderContainer.decode(String.self, forKey: .senderID)
      let senderUserName = try senderContainer.decode(String.self, forKey: .senderUserName)
      sender = Sender(senderID: senderID, senderName: senderUserName)
  }

}
