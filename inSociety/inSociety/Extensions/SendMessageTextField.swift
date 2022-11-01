//
//  SendMessageTextField.swift
//  inSociety
//
//  Created by Aleksey Libin on 18.10.2022.
//

import UIKit

class SendMessageTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        placeholder = "Aa"
        font = UIFont.systemFont(ofSize: 14)
        borderStyle = .none
        clearButtonMode = .whileEditing
        layer.cornerRadius = 18
        layer.masksToBounds = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setImage(UIImage(named: "Send"), for: .normal)
        rightView = sendButton
        rightView?.frame =  CGRect(x: 0, y: 0, width: 20, height: 20)
        rightViewMode = .always
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 30, dy: 0)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 30, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 30, dy: 0)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
