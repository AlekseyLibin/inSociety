//
//  UnderlinedTextField.swift
//  inSociety
//
//  Created by Aleksey Libin on 13.10.2022.
//

import UIKit

class UnderlinedTextField: UITextField {
    convenience init(font: UIFont?) {
        self.init()
        
        self.font = font
        self.borderStyle = .none
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var lineView = UIView()
        lineView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        lineView.backgroundColor = .tfLine()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lineView)
        
        NSLayoutConstraint.activate([
            lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            lineView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
    }
}
