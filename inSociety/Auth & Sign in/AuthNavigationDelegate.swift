//
//  AuthNavigationDelegate.swift
//  inSociety
//
//  Created by Aleksey Libin on 19.10.2022.
//

import Foundation

protocol AuthNavigationDelegate: AnyObject {
    func toLoginVC()
    func toSignUpVC()
}
