//
//  SignUpViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 13.10.2022.
//

import UIKit

class SignUpViewController: UIViewController {
    
    weak var delegate: AuthNavigationDelegate?
    
    let greetingLabel = UILabel(text: "Pleased to see you!", font: .galvji30())
    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Password")
    let confirmPasswordLabel = UILabel(text: "Confirm password")
    let alreadyWithUsLabel = UILabel(text: "Already with us?")
    
    let emailextField = UnderlinedTextField(font: .galvji20())
    let passwordTextField = UnderlinedTextField(font: .galvji20())
    let confirmPasswordtextField = UnderlinedTextField(font: .galvji20())
    
    let signUpButon = UIButton(title: "Sign up", titleColor: .white, backgroundColor: .darkButtonColor())
    let loginButton = UIButton(title: "Login", titleColor: .loginButtonTitleColor(), backgroundColor: nil)
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setUpViews()
        
        signUpButon.addTarget(self, action: #selector(signUpButonPressed), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
    }
    
    @objc private func signUpButonPressed() {
        AuthService.shared.register(email: emailextField.text,
                                    password: passwordTextField.text,
                                    confirmPassword: confirmPasswordtextField.text) { result in
            switch result {
            
            case .success(_):
                self.showAlert(with: "Success", and: "You have been registrated") {
                    self.present(SetupProfileViewController(), animated: true)
                }
            case .failure(let error ):
                self.showAlert(with: "Failure!", and: error.localizedDescription)
            }
        }
    }
    
    @objc private func loginButtonPressed() {
        dismiss(animated: true) {
            self.delegate?.toLoginVC()
        }
    }
}



//MARK: - Setup Views
extension SignUpViewController {
    
    private func setUpViews() {
        
        let emailStackView = UIStackView(
            arrangedSubviews: [emailLabel, emailextField], axis: .vertical, spacing: 0)
        let passwordStackView = UIStackView(
            arrangedSubviews: [passwordLabel, passwordTextField], axis: .vertical, spacing: 0)
        let confirmPasswordStackView = UIStackView(
            arrangedSubviews: [confirmPasswordLabel, confirmPasswordtextField], axis: .vertical, spacing: 0)
        
        signUpButon.translatesAutoresizingMaskIntoConstraints = false
        signUpButon.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [
        emailStackView, passwordStackView, confirmPasswordStackView, signUpButon
        ], axis: .vertical, spacing: 40)
        
        let bottomStackView = UIStackView(arrangedSubviews: [alreadyWithUsLabel, loginButton],
                                          axis: .horizontal, spacing: 0)
        
        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(greetingLabel)
        view.addSubview(stackView)
        view.addSubview(bottomStackView)
        
        NSLayoutConstraint.activate([
            greetingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 100),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 80),
            bottomStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loginButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        
    }
}



//MARK: - SwiftUI
import SwiftUI

struct SignUpVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let signUpViewController = SignUpViewController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return signUpViewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
