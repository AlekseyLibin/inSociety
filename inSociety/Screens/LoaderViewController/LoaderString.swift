//
//  LoaderString.swift
//  inSociety
//
//  Created by Aleksey Libin on 19.09.2023.
//

import Foundation

enum LoaderString: String {
  
  case greeting
  case privacyPolicy
  case termsOfUse
  case iAgreeToConditions
  case `continue`
  
  var localized: String {
    NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
  }
}
