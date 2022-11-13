//
//  AddPhotoViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 13.10.2022.
//

import UIKit

class AddPhotoView: UIView {
    
    var profileImageView: UIImageView = {
        let image = UIImageView(named: "ProfilePhoto", contentMode: .scaleAspectFill)
        image.clipsToBounds = true
        image.layer.borderColor = UIColor.black.cgColor
        image.layer.borderWidth = 1
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var addProfilePhoto: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "AddProfilePhoto")
        button.setImage(image, for: .normal)
        button.tintColor = .mainYellow()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        addSubview(addProfilePhoto)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: self.topAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            addProfilePhoto.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 15),
            addProfilePhoto.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            addProfilePhoto.widthAnchor.constraint(equalToConstant: 30),
            addProfilePhoto.heightAnchor.constraint(equalToConstant: 30),
            
            self.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor),
            self.trailingAnchor.constraint(equalTo: addProfilePhoto.trailingAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
