//
//  UserCell.swift
//  inSociety
//
//  Created by Aleksey Libin on 18.10.2022.
//

import UIKit
import SDWebImage

final class UserCell: UICollectionViewCell {
  
  private var userImageView = UIImageView()
  private let userNameLabel = UILabel(text: "", font: .laoSangamMN20())
  private let containerView = UIView()
  
  static var reuseID: String = "UserCell"
  
  override func prepareForReuse() {
    userImageView.image = nil
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    self.containerView.layer.cornerRadius = 5
    self.containerView.clipsToBounds = true
  }
  
}

// MARK: - SelfConfiguringCell
extension UserCell: SelfConfiguringCell {
  
  // HCell - Hashable cell.
  func configure<HCell>(with value: HCell) where HCell : Hashable {
    guard let user: UserModel = value as? UserModel else { return }
    userNameLabel.text = user.fullName
    userNameLabel.textColor = .mainWhite()
    userNameLabel.backgroundColor = .secondaryDark()
    userNameLabel.textAlignment = .center
    guard let url = URL(string: user.avatarString) else { return }
    userImageView.sd_setImage(with: url)
    userImageView.backgroundColor = .secondaryDark()
    userImageView.contentMode = .scaleAspectFill
  }
}

// MARK: Setup constraints
private extension UserCell {
  func setupViews() {
    backgroundColor = .mainDark()
    
    layer.shadowColor = UIColor.thirdDark().cgColor
    layer.cornerRadius = 5
    layer.shadowRadius = 5
    layer.shadowOpacity = 1
    layer.shadowOffset = CGSize(width: 0, height: 5)
    layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    
    userImageView.translatesAutoresizingMaskIntoConstraints = false
    userNameLabel.translatesAutoresizingMaskIntoConstraints = false
    containerView.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(containerView)
    containerView.addSubview(userImageView)
    containerView.addSubview(userNameLabel)
    
    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
      containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
      containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
      
      userImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      userImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      userImageView.widthAnchor.constraint(equalTo: widthAnchor),
      userImageView.heightAnchor.constraint(equalTo: widthAnchor),
      
      userNameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor),
      userNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
      userNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      userNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }
}
