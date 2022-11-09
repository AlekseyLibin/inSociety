//
//  ViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 12.10.2022.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

class AuthViewController: UIViewController {
        
    let logoImage = UIImageView(named: "inSociety", contentMode: .scaleAspectFit)
    let googleLabel = UILabel(text: "Get started with")
    let emailLabel = UILabel(text: "Or sign up with")
    let loginLabel = UILabel(text: "Already on board?")
    
    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white)
    let emailButton = UIButton(title: "email", titleColor: .black, backgroundColor: .mainYellow())
    let loginButton = UIButton(title: "Login", titleColor: .mainYellow(), backgroundColor: nil)
    
    let signUpVC = SignUpViewController()
    let loginVC = LoginViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        emailButton.addTarget(self, action: #selector(emailButtonPressed), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleButtonPressed), for: .touchUpInside)
        
        signUpVC.delegate = self
        loginVC.delegate = self
        
    }
    
}



//MARK: - Buttons realization
extension AuthViewController {
    
    @objc private func emailButtonPressed() {
        present(signUpVC, animated: true)
    }
    
    @objc private func loginButtonPressed() {
        present(loginVC, animated: true)
    }
    
    @objc private func googleButtonPressed() {
        let clientID = FirebaseApp.app()?.options.clientID
        AuthService.shared.googleLogin(clientID: clientID, presentingVC: self) { result in
            switch result {
            case .success(let user):
                FirestoreService.shared.getUserData(user: user) { result in
                    switch result {
                    case .success(let userModel):
                        self.showAlert(with: "You have successfully logged in", and: "") {
                            
                            let main = MainTabBarController(currentUser: userModel)
                            main.modalPresentationStyle = .fullScreen
                            self.present(main, animated: true)
                        }
                    case .failure(_):
                        self.showAlert(with: "You have successfully registrated", and: "") {
                            self.present(SetupProfileViewController(currentUser: user), animated: true)
                        }
                    }
                }
            case .failure(let failure):
                self.showAlert(with: "Error", and: failure.localizedDescription)
            }
        }
    }
}



//MARK: - Setup views
extension AuthViewController {
    
    private func setupViews() {
        
        view.backgroundColor = .mainDark()
        
        logoImage.setupColor(.mainYellow())
        
        loginButton.layer.borderColor = UIColor.mainYellow().cgColor
        loginButton.layer.borderWidth = 2
        
        googleButton.customizeGoogleButton()
        
        [googleLabel, emailLabel, loginLabel].forEach { label in
            label.textColor = .lightGray
        }
        
        let googleView = LabelButtonView(label: googleLabel, button: googleButton)
        let emailView = LabelButtonView(label: emailLabel, button: emailButton)
        let loginView = LabelButtonView(label: loginLabel, button: loginButton)
        
        let stackView = UIStackView(arrangedSubviews: [googleView, emailView, loginView],
                                    axis: .vertical, spacing: 50)
        
        let secondaryView = UIView()
        secondaryView.layer.cornerRadius = 20
        secondaryView.backgroundColor = .secondaryDark()
        
        
        view.addSubview(logoImage)
        view.addSubview(secondaryView)
        view.addSubview(stackView)
        
        
        [logoImage, secondaryView, stackView].forEach { subView in
            view.addSubview(subView)
            subView.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            
            logoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            logoImage.heightAnchor.constraint(equalTo: logoImage.widthAnchor, multiplier: 0.34),
            
            stackView.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 100),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            secondaryView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: -35),
            secondaryView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondaryView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            secondaryView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 35)
        ])
        
    }
}



//MARK: - AuthNavigationDelegate
extension AuthViewController: AuthNavigationDelegate {
    func toLoginVC() {
        present(loginVC, animated: true)
    }
    
    func toSignUpVC() {
        present(signUpVC, animated: true)
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

