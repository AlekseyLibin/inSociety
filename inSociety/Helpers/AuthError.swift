//
//  AuthError.swift
//  inSociety
//
//  Created by Aleksey Libin on 20.10.2022.
//

import Foundation

enum AuthError: String {
    
    case fieldsAreNotFilled
    case emailFieldIsEmpty
    case invalidEmail
    case passwordFieldIsEmpty
    case confirmPasswordFieldIsEmpty
    case passwordContainsSpecificSymbols
    case passwordsDoNotMatch
    case couldNotAuthWithGoogle
  
  var localized: String {
    NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
  }
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
      return NSLocalizedString(self.localized, comment: "")
      /*
       switch self {
       case .fieldsAreNotFilled:
           return NSLocalizedString("Fill in all the fields", comment: "")
       case .emailInvalid:
           return NSLocalizedString("Email type is invalid", comment: "")
       case .passwordContainsSpecificSymbols:
           return NSLocalizedString("Password contains specific symbols", comment: "")
       case .passwordsDoNotMatch:
           return NSLocalizedString("Passwords do not match", comment: "")
       case .passwordFieldIsEmpty:
           return NSLocalizedString("Password field is empty", comment: "")
       case .confirmPasswordFieldIsEmpty:
           return NSLocalizedString("Confirm password field is empty", comment: "")
       case .emailFieldIsEmpty:
           return NSLocalizedString("Email field is empty", comment: "")
       case .couldNotAuthWithGoogle:
           return NSLocalizedString("Could not authorize with Goole", comment: "")
       }
       */
   }
}
