//
//  UITextField + Extension.swift
//  inSociety
//
//  Created by Aleksey Libin on 21.08.2023.
//

import UIKit

extension UITextField {
    func addKeyboardObservers() {
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
  @objc private func keyboardWillShow(_ notification: Notification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      UIView.animate(withDuration: 0.3) {
        self.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height)
      }
    }
  }
  
  @objc private func keyboardWillHide(_ notification: Notification) {
    UIView.animate(withDuration: 0.3) {
      self.transform = .identity
    }
  }
}
