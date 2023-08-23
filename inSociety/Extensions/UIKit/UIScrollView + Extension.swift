//
//  UIScrollView + Extension.swift
//  inSociety
//
//  Created by Aleksey Libin on 01.11.2022.
//

import UIKit

// MARK: - Keyboard observers on UIScrolLView
extension UIScrollView {
//  func addKeyboardObservers() {
//    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//  }
//
//  //  @objc func keyboardWillShow(notification: Notification) {
//  //    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//  //      let tabBarHeight = CGFloat(UserDefaults.standard.integer(forKey: "tabBarHeight"))
//  //      contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height - tabBarHeight + 10, right: 0)
//  //      showsVerticalScrollIndicator = false
//  //    }
//  //  }
//  //
//  //  @objc func keyboardWillHide(notification: Notification) {
//  //    contentInset = UIEdgeInsets()
//  //    setContentOffset(CGPoint(x: 0, y: 0), animated: true)
//  //  }
//
//  @objc func keyboardWillShow(_ notification: Notification) {
//    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//      UIView.animate(withDuration: 0.3) {
//        self.textField.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height)
//      }
//    }
//  }
//
//  @objc func keyboardWillHide(_ notification: Notification) {
//    UIView.animate(withDuration: 0.3) {
//      self.textField.transform = .identity
//    }
//  }
}

// MARK: - Is at bottom
extension UIScrollView {
  var isAtBottom: Bool {
    return contentOffset.y >= verticalOffsetForBottom
  }
  
  var verticalOffsetForBottom: CGFloat {
    let scrollViewHeight = bounds.height
    let scrollContentSizeHeight = contentSize.height
    let bottomInset = contentInset.bottom
    let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
    return scrollViewBottomOffset
  }
}
