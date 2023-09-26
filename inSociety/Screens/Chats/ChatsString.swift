//
//  ChatsString.swift
//  inSociety
//
//  Created by Aleksey Libin on 16.08.2023.
//

import Foundation

enum ChatsString: String {
  
  case waitingChats
  case activeChats
  case waitingChatsMessage
  case activeChatsMessage
  case chats
  case success
  case chatRequestDenied
  case error
  
  var localized: String {
    NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
  }
}
