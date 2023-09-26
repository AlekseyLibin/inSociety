//
//  ExtensionsString.swift
//  inSociety
//
//  Created by Aleksey Libin on 16.08.2023.
//

import Foundation

enum ExtensionsString: String {
  
  case confirm
  case done
  case continueWithGoogle
  
  var localized: String {
    NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
  }
}
