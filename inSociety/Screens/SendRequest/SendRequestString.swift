//
//  SendRequestString.swift
//  inSociety
//
//  Created by Aleksey Libin on 16.08.2023.
//

import Foundation

enum SendRequestString: String {
  
  case success
  case messageAndRequestSent
  case error
  case about
  case her
  case him
  case them
  
  var localized: String {
    NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
  }
}
