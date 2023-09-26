//
//  ChatRequestString.swift
//  inSociety
//
//  Created by Aleksey Libin on 16.08.2023.
//

import Foundation

enum ChatRequestString: String {
  
  case chatRequest
  case somebody
  case wantsToChatWithYou
  case accept
  case deny
  
  var localized: String {
    NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
  }
}
