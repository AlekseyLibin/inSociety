//
//  ViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 12.10.2022.
//

import UIKit

class AuthViewController: UIViewController {
    
//    let backgroundImage = UIImageView(image: .authVCBackground(), contentMode: .scaleAspectFill)
    
    let logoImage = UIImageView(image: .inSociety(), contentMode: .scaleAspectFit)
    
    let googleLabel = UILabel(text: "Get started with")
    let emailLabel = UILabel(text: "Or sign up with")
    let loginLabel = UILabel(text: "Already on board?")
    
    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white, isShadow: true)
    let emailButton = UIButton(title: "email", titleColor: .white, backgroundColor: .darkButtonColor())
    let loginButton = UIButton(title: "Login", titleColor: .loginButtonTitleColor(), backgroundColor: .white, isShadow: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        view.backgroundColor = .systemGray
        setupViews()
    }
}



//MARK: - Setup views
extension AuthViewController {
    
    private func setupViews() {
        
        view.addSubview(logoImage)
        
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            logoImage.heightAnchor.constraint(equalTo: logoImage.widthAnchor, multiplier: 0.34)
        ])
        
        
        let googleView = LabelButtonView(label: googleLabel, button: googleButton)
        let emailView = LabelButtonView(label: emailLabel, button: emailButton)
        let loginView = LabelButtonView(label: loginLabel, button: loginButton)
        
        
        view.addSubview(googleView)
        view.addSubview(emailView)
        view.addSubview(loginView)
        
        googleView.translatesAutoresizingMaskIntoConstraints = false
        emailView.translatesAutoresizingMaskIntoConstraints = false
        loginView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            googleView.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 100),
            googleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googleView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            emailView.topAnchor.constraint(equalTo: googleView.bottomAnchor, constant: 40),
            emailView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailView.widthAnchor.constraint(equalTo: googleView.widthAnchor),
            
            loginView.topAnchor.constraint(equalTo: emailView.bottomAnchor, constant: 40),
            loginView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginView.widthAnchor.constraint(equalTo: googleView.widthAnchor),
        ])
    }
}



//MARK: - SwiftUI
import SwiftUI

struct AuthVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let authViewController = AuthViewController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return authViewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}

