//
//  UIImageView + Extension.swift
//  inSociety
//
//  Created by Aleksey Libin on 12.10.2022.
//

import UIKit

extension UIImageView {
    
    func setupColor(_ color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
    
    convenience init(named: String, contentMode: UIImageView.ContentMode) {
        self.init()
        self.image = UIImage(named: named)
        self.contentMode = contentMode
    }
}
