//
//  UnderlinedTextField.swift
//  inSociety
//
//  Created by Aleksey Libin on 13.10.2022.
//

import UIKit

final class UnderlinedTextField: UITextField, UITextFieldDelegate {
  convenience init(font: UIFont?) {
    self.init()
    addDoneButton()
    
    self.font = font
    self.borderStyle = .none
    self.translatesAutoresizingMaskIntoConstraints = false
    
    var lineView = UIView()
    lineView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
    lineView.backgroundColor = .mainYellow
    lineView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(lineView)
    
    NSLayoutConstraint.activate([
      lineView.leadingAnchor.constraint(equalTo: leadingAnchor),
      lineView.trailingAnchor.constraint(equalTo: trailingAnchor),
      lineView.bottomAnchor.constraint(equalTo: bottomAnchor),
      lineView.heightAnchor.constraint(equalToConstant: 0.5)
    ])
  }
  
  private func addDoneButton() {
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    keyboardType = .default
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
    toolbar.items = [flexibleSpace, doneButton]
    inputAccessoryView = toolbar
    delegate = self
  }
  
  @objc private func doneButtonTapped() {
      endEditing(true)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
      return true
  }
}
