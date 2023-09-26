//
//  AddPhotoViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 13.10.2022.
//

import UIKit

final class FillImageView: UIView {
  
  private let profileImageView = UIImageView(named: "ProfilePhoto", contentMode: .scaleAspectFill)
  private let setImageButton = UIButton(type: .system)
  
  var profileImage: UIImage? {
    guard profileImageView.image != UIImage(named: "ProfilePhoto") else { return nil }
    return profileImageView.image
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    profileImageView.clipsToBounds = true
    profileImageView.layer.borderColor = UIColor.mainYellow.cgColor
    profileImageView.layer.borderWidth = 0.3
    profileImageView.layer.masksToBounds = true
    profileImageView.layer.cornerRadius = 60
    profileImageView.translatesAutoresizingMaskIntoConstraints = false
    
    setImageButton.tintColor = .mainYellow
    setImageButton.setImage(UIImage(named: "AddProfilePhoto"), for: .normal)
    setImageButton.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(profileImageView)
    addSubview(setImageButton)
    setupConstraints()
  }
  
  func setProfileImage(by image: UIImage?) {
    guard let image = image else { return }
    profileImageView.image = image
    setImageButton.setImage(UIImage(named: "ChangeProfilePhoto"), for: .normal)
  }
  
  func setProfileImage(by url: URL?) {
    profileImageView.sd_setImage(with: url) { image, _, _, _ in
      if image !=  nil {
        self.setImageButton.setImage(UIImage(named: "ChangeProfilePhoto"), for: .normal)
      } else {
        self.profileImageView.image = UIImage(named: "ProfilePhoto")
      }
    }
  }
  
  func buttonPressed(target: Any?, action: Selector, for event: UIControl.Event) {
    setImageButton.addTarget(target, action: action, for: event)
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      profileImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      profileImageView.widthAnchor.constraint(equalToConstant: 120),
      profileImageView.heightAnchor.constraint(equalToConstant: 120),
      
      setImageButton.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20),
      setImageButton.centerYAnchor.constraint(equalTo: centerYAnchor),
      setImageButton.widthAnchor.constraint(equalToConstant: 35),
      setImageButton.heightAnchor.constraint(equalToConstant: 35),
      
      bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor),
      trailingAnchor.constraint(equalTo: setImageButton.trailingAnchor)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
