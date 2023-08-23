//
//  SetupProfileString.swift
//  inSociety
//
//  Created by Aleksey Libin on 16.08.2023.
//

import Foundation

enum SetupProfileString: String {
  
  case fullName
  case aboutMe
  case aboutMePlaceholder
  case sex
  case submit
  case setupProfile
  case error
  
  var localized: String {
    NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
  }
}
