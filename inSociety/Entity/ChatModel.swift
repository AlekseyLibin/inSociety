//
//  ChatModel.swift
//  inSociety
//
//  Created by Aleksey Libin on 18.10.2022.
//

import UIKit
import FirebaseFirestore

final class ChatModel {
  var friendName: String
  var friendAvatarString: String
  var friendID: String
  var messages: [MessageModel]
  
  init(friendName: String, friendAvatarString: String, friendID: String, messages: [MessageModel]) {
    self.friendName = friendName
    self.friendAvatarString = friendAvatarString
    self.friendID = friendID
    self.messages = messages
  }
  
  init?(document: QueryDocumentSnapshot) {
    let data = document.data()
    guard let friendName = data["friendName"] as? String,
          let friendAvatarString = data["friendAvatarURL"] as? String,
          let friendID = data["friendID"] as? String
    else { return nil }

    self.friendName = friendName
    self.friendAvatarString = friendAvatarString
    self.friendID = friendID
    self.messages = []
    fillUpMessages(by: document)
    return
  }
  
  private func fillUpMessages(by document: QueryDocumentSnapshot) {
    let messagesCollection = document.reference.collection("messages")
    messagesCollection.getDocuments { [weak self] snapshot, error in
      guard let snapshot = snapshot else { print(error!.localizedDescription); return }
      snapshot.documents.forEach { document in
        guard let message = MessageModel(document: document) else { return }
        self?.messages.append(message)
      }
    }
  }

  var representation: [String: Any] {
    let representation: [String: Any] = [
      "friendName": friendName,
      "friendAvatarURL": friendAvatarString,
      "friendID": friendID
    ]
    return representation
  }
  
  func contains(filter: String?) -> Bool {
    guard let filter = filter, filter.isEmpty == false else { return true }
    
    let lowercasedFilter = filter.lowercased()
    return friendName.lowercased().contains(lowercasedFilter)
  }

// MARK: - Decodable
  private enum CodingKeys: String, CodingKey {
    case friendName
    case friendAvatarString
    case messages
    case friendID
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    friendName = try container.decode(String.self, forKey: .friendName)
    friendAvatarString = try container.decode(String.self, forKey: .friendAvatarString)
    messages = try container.decode([MessageModel].self, forKey: .messages)
    friendID = try container.decode(String.self, forKey: .friendID)
  }
}

// MARK: - Hashable
extension ChatModel: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(friendID)
  }
  
  static func == (lhs: ChatModel, rhs: ChatModel) -> Bool {
    return lhs.friendID == rhs.friendID && lhs.messages.sorted() == rhs.messages.sorted()
  }
}

// MARK: - Comparable
extension ChatModel: Comparable {
    static func < (lhs: ChatModel, rhs: ChatModel) -> Bool {
      if let lhsSentDate = lhs.messages.sorted().last?.sentDate,
         let rhsSentDate = rhs.messages.sorted().last?.sentDate {
        return lhsSentDate > rhsSentDate
      } else { return true }
    }
    
}
