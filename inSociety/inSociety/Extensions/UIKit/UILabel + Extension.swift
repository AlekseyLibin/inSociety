//
//  UILabel + Extension.swift
//  inSociety
//
//  Created by Aleksey Libin on 12.10.2022.
//

import UIKit

extension UILabel {
    
    convenience init(text: String, font: UIFont? = .galvji20()) {
        self.init()
        self.text = text
        self.font = font
    }
}
