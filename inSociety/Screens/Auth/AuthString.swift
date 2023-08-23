//
//  AuthString.swift
//  inSociety
//
//  Created by Aleksey Libin on 14.08.2023.
//

import Foundation

enum AuthString: String {
  
  case getStartedWith
  case orSignUpWith
  case alreadyOnBoard
  case google
  case login
  case email
  case youHaveBeenRegistrated
  case error
  
  var localized: String {
    NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
  }
}
