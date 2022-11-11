//
//  UIView + Extension.swift
//  inSociety
//
//  Created by Aleksey Libin on 03.11.2022.
//

import UIKit


//MARK: - Hide keyboard when tapped arround
extension UIView {
     func hideKeyboardWhenTappedOrSwiped() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        swipe.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
        self.addGestureRecognizer(swipe)
    }
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
}
