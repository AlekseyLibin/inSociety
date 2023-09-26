//
//  PeopleString.swift
//  inSociety
//
//  Created by Aleksey Libin on 16.08.2023.
//

import Foundation

enum PeopleString: String {
  
  case peopleNearby
  case error
  case cancel
  case isBlocked
  case doYouWantToUnblock
  case unblock
  
  var localized: String {
    NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
  }
}
