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
    
    static func currentUserMessage() -> UIColor {
        return UIColor.systemGray
    }
    
    static func friendMessage() -> UIColor {
        return UIColor.systemYellow
    }
        
    
    static func mainDark() -> UIColor {
        return UIColor(red: 27/255, green: 31/255, blue: 34/255, alpha: 1)
    }
    
    static func secondaryDark() -> UIColor {
        return UIColor(red: 34/255, green: 39/255, blue: 43/255, alpha: 1)
    }
    
    static func thirdDark() -> UIColor {
        return UIColor(red: 30/255, green: 35/255, blue: 39/255, alpha: 1)
    }
    
    static func mainYellow() -> UIColor {
        return UIColor(red: 239/255, green: 223/255, blue: 37/255, alpha: 1)
    }
    
    static func buttonShadowColor() -> UIColor {
        return UIColor(red: 235/255, green: 186/255, blue: 140/255, alpha: 1)
    }
    
}
