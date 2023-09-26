//
//  ChatString.swift
//  inSociety
//
//  Created by Aleksey Libin on 20.09.2023.
//

import Foundation

enum ChatString: String {
  
  case message
  case availableActions
  case reportThisUser
  case blockThisUser
  case deleteThisChat
  case success
  case error
  case confirm
  case submit
  case cancel
  case deleteChat
  case delete
  case deleteWarningPt1 // Are you sure you want to delete your chat with
  case deleteWarningPt2 // Chat will be deleted for both of us.
  case report
  case reportSentSuccessfully // "Report has been sent successfully and will be reviewed within 24 hours"
  case describeTheProblem // "Describe the problem you spotted"
  
  var localized: String {
    NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
  }
}
