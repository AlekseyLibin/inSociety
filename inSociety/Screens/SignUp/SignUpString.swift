//
//  SignUpString.swift
//  inSociety
//
//  Created by Aleksey Libin on 16.08.2023.
//

import Foundation

enum SignUpString: String {
  
  case pleasedToSeeYou
  case email
  case password
  case confirmPassword
  case alreadyWithUs
  case signUp
  case login
  case error
  
  
  var localized: String {
    NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
  }
}
