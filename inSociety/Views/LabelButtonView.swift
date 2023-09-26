//
//  LabelButtonView.swift
//  inSociety
//
//  Created by Aleksey Libin on 12.10.2022.
//

import UIKit

final class LabelButtonView: UIView {
  
  init(label: UILabel, button: UIButton, secondButton: UIView? = nil) {
    super.init(frame: .zero)
    
    addSubview(label)
    addSubview(button)
    
    translatesAutoresizingMaskIntoConstraints = false
    label.translatesAutoresizingMaskIntoConstraints = false
    button.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
      label.leadingAnchor.constraint(equalTo: self.leadingAnchor)
    ])
    
    NSLayoutConstraint.activate([
      button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
      button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      button.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      button.heightAnchor.constraint(equalToConstant: 60)
      
    ])
    
    guard let secondButton else {
      bottomAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
      return
    }
    addSubview(secondButton)
    secondButton.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      secondButton.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 15),
      secondButton.leadingAnchor.constraint(equalTo: button.leadingAnchor),
      secondButton.trailingAnchor.constraint(equalTo: button.trailingAnchor),
      secondButton.heightAnchor.constraint(equalTo: button.heightAnchor)
    ])
    bottomAnchor.constraint(equalTo: secondButton.bottomAnchor).isActive = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
