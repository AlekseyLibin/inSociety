//
//  UIColor + Extension.swift
//  inSociety
//
//  Created by Aleksey Libin on 12.10.2022.
//

import UIKit
import SwiftUI


extension UIColor {
    
    static func mainWhite() -> UIColor {
        return UIColor(red: 245/255, green: 240/255, blue: 245/255, alpha: 1)
    }
    
    static func darkButtonColor() -> UIColor {
        return UIColor(red: 65/255, green: 65/255, blue: 65/255, alpha: 1)
    }
    
    static func shadowColor() -> UIColor? {
        return UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1)
    }
    
    static func loginButtonTitleColor() -> UIColor {
        return UIColor(red: 85/255, green: 230/255, blue: 226/255, alpha: 1)
    }
    
    static func signUpButonTitleColor() -> UIColor {
        return UIColor(red: 153/255, green: 15/255, blue: 255/255, alpha: 1)
    }
    
    static func tfLine() -> UIColor {
        return UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1)
    }
    
    
    
    //I USE IT!
    static func currentUserMessage() -> UIColor {
        return UIColor.systemGray
    }
    
    static func friendMessage() -> UIColor {
        return UIColor.systemYellow
    }
    
    //General
    
    
    static func mainDark() -> UIColor {
        return UIColor(red: 26/255, green: 19/255, blue: 63/255, alpha: 1)
    }
    
    static func mainYellow() -> UIColor {
        return UIColor(red: 239/255, green: 223/255, blue: 37/255, alpha: 1)
    }
    
}
