//
//  GoogleButton.swift
//  inSociety
//
//  Created by Aleksey Libin on 23.09.2023.
//

import UIKit
import AuthenticationServices

final class GoogleButton: UIButton {
  
  private let logoView = UIImageView()
  
  init() {
    super.init(frame: .zero)
    backgroundColor = .white
    setTitle(ExtensionsString.continueWithGoogle.localized, for: .normal)
    setTitleColor(.black, for: .normal)
    layer.masksToBounds = true
    layer.cornerRadius = 10
    logoView.image = UIImage(named: "googleLogo")
    logoView.contentMode = .scaleAspectFit
    logoView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(logoView)
    
    guard let titleLabel else { return }
    NSLayoutConstraint.activate([
      
      titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      
      logoView.centerYAnchor.constraint(equalTo: centerYAnchor),
      logoView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -5),
      logoView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
      logoView.widthAnchor.constraint(equalTo: logoView.heightAnchor)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
