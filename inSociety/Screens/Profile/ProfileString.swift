//
//  ProfileString.swift
//  inSociety
//
//  Created by Aleksey Libin on 14.08.2023.
//

import Foundation

enum ProfileString: String {
  
  case activeChats
  case waitingChats
  case logOut
  case logOutWarning
  case cancel
  case profile
  case edit
  case noActiveChatsQuantity
  case noWaitingChatsQuantity
  case error
  case userNotFound
  
  var localized: String {
    NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
  }
}
