//
//  UIColor + Extension.swift
//  inSociety
//
//  Created by Aleksey Libin on 12.10.2022.
//

import UIKit
import SwiftUI

extension UIColor {
  
  static var friendMessage: UIColor {
    return UIColor.systemGray
  }
  
  static var currentUserMessage: UIColor {
    return UIColor(red: 239/255, green: 223/255, blue: 37/255, alpha: 0.75)
  }
  
  static var mainDark: UIColor {
    return UIColor(red: 27/255, green: 31/255, blue: 34/255, alpha: 1)
  }
  
  static var secondaryDark: UIColor {
    return UIColor(red: 34/255, green: 39/255, blue: 43/255, alpha: 1)
  }
  
  static var mainYellow: UIColor {
    return UIColor(red: 239/255, green: 223/255, blue: 37/255, alpha: 1)
  }
  
}
