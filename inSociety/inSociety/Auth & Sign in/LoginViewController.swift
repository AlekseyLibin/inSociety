//
//  LoginViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 13.10.2022.
//

import UIKit
import FirebaseCore

class LoginViewController: UIViewController {
    
    weak var delegate: AuthNavigationDelegate?
    
    let greetingLabel = UILabel(text: "Welcome back!", font: .galvji30())
    let loginWithLabel = UILabel(text: "Login with")
    let orLabel = UILabel(text: "or")
    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Password")
    
    let emailextField = UnderlinedTextField(font: .galvji20())
    let passwordTextField = UnderlinedTextField(font: .galvji20())
    
    
    let loginButton = UIButton(title: "Login",
                               titleColor: .white, backgroundColor: .darkButtonColor())
    let googleButton = UIButton(title: "Google",
                                titleColor: .black, backgroundColor: .white, isShadow: true)
    let signUpButton = UIButton(title: "Create new account",
                                titleColor: .signUpButonTitleColor(), backgroundColor: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setUpViews()
        
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleButtonPressed), for: .touchUpInside)
    }
    
    @objc private func loginButtonPressed() {
        AuthService.shared.login(email: emailextField.text,
                                 password: passwordTextField.text) { result in
            switch result {
            case .success(let user):
                self.showAlert(with: "Success", and: "You have successfully logged in") {
                    FirestoreService.shared.getUserData(user: user) { result in
                        switch result {
                        case .success(let currentUser):
                            let mainTabBar = MainTabBarController(currentUser: currentUser)
                            mainTabBar.modalPresentationStyle = .fullScreen
                            self.present(mainTabBar, animated: true)
                        case .failure(_):
                            self.present(SetupProfileViewController(currentUser: user), animated: true)
                        }
                    }
                }
            case .failure(let error):
                self.showAlert(with: "Failure", and: error.localizedDescription)
            }
        }
    }
    
    @objc private func signUpButtonPressed() {
        dismiss(animated: true) {
            self.delegate?.toSignUpVC()
        }
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
extension LoginViewController {
    
    private func setUpViews() {
        googleButton.customizedGoogleButton()
        
        emailextField.autocapitalizationType = .none
        passwordTextField.autocapitalizationType = .none

        let loginView = LabelButtonView(label: loginWithLabel, button: googleButton)
        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailextField],
                                         axis: .vertical, spacing: 10)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField],
                                            axis: .vertical, spacing: 10)
        let stackView = UIStackView(arrangedSubviews: [
            loginView, orLabel, emailStackView, passwordStackView, loginButton, signUpButton
        ], axis: .vertical, spacing: 50)
        
        view.addSubview(greetingLabel)
        view.addSubview(stackView)
        
        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            greetingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 75),
            greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 100),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            loginButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}



//MARK: - SwiftUI
import SwiftUI

struct LoginVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let loginViewController = LoginViewController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return loginViewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
