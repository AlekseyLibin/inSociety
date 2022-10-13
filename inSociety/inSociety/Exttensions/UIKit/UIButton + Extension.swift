//
//  UIButton + Extension.swift
//  inSociety
//
//  Created by Aleksey Libin on 12.10.2022.
//

import Foundation
import UIKit

extension UIButton {
    
    convenience init(title: String,
                     titleColor: UIColor,
                     font: UIFont? = .galvji20(),
                     backgroundColor: UIColor?,
                     cornerRadius: CGFloat = 4,
                     isShadow: Bool = false) {
        self.init(type: .system)
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = font
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        
        if isShadow {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowRadius = 4
            self.layer.shadowOpacity = 0.2
            self.layer.shadowOffset = CGSize(width: 0, height: 4)
        }
    }
    
    func customizedGoogleButton() {
        
        let logo = UIImageView(named: "GoogleLogo", contentMode: .scaleAspectFit)
        self.addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logo.widthAnchor.constraint(equalToConstant: 40),
            logo.heightAnchor.constraint(equalToConstant: 40),
            logo.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            logo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25)
        ])
    }
}
