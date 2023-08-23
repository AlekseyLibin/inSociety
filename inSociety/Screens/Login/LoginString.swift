//
//  LoginString.swift
//  inSociety
//
//  Created by Aleksey Libin on 14.08.2023.
//

import Foundation

enum LoginString: String {
  
  case welcomeBack
  case loginWith
  case orSignUpWithAnotherMethod
  case email
  case password
  case google
  case login
  case createNewAccount
  case youHaveBeenRegistrated
  case error
  
  var localized: String {
    NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
  }
}
