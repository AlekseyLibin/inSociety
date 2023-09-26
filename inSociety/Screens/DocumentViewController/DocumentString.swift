//
//  DocumentString.swift
//  inSociety
//
//  Created by Aleksey Libin on 20.09.2023.
//

import Foundation

enum DocumentString: String {
  
  case done
  
  var localized: String {
    NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
  }
}
