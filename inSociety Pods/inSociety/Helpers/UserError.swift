//
//  UserError.swift
//  inSociety
//
//  Created by Aleksey Libin on 21.10.2022.
//

import Foundation

enum UserError {
    
    case notFilled
    case noPhoto
    case cannotGetUserInfo
    case cannotUnwrapFBDataToUserModel
}

extension UserError: LocalizedError {
    var errorDescription: String? {
        
        switch self {
        case .notFilled:
            return NSLocalizedString("Fill in all the fields", comment: "")
        case .noPhoto:
            return NSLocalizedString("User has not selected a photo", comment: "")
        case .cannotGetUserInfo:
            return NSLocalizedString("Could not get user info", comment: "")
        case .cannotUnwrapFBDataToUserModel:
            return NSLocalizedString("Could not unwrap data from Firebase into UserModel. Maybe not all of the fields are filled", comment: "") 
        }
    }
}
