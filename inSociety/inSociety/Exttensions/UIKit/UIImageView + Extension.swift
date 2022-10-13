//
//  UIImageView + Extension.swift
//  inSociety
//
//  Created by Aleksey Libin on 12.10.2022.
//

import UIKit

extension UIImageView {
    
    convenience init(image: UIImage?, contentMode: UIImageView.ContentMode) {
        self.init()
        self.image = image
        self.contentMode = contentMode
    }
}

extension UIImage {
    
    static func inSociety() -> UIImage? {
        return UIImage(named: "inSociety")
    }
    
    static func authVCBackground() -> UIImage? {
        return UIImage(named: "authVCBackground")
    }
}
