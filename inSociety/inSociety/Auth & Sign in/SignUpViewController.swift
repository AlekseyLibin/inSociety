//
//  SignUpViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 13.10.2022.
//

import UIKit

class SignUpViewController: UIViewController {
    
    weak var delegate: AuthNavigationDelegate?
    
    let scrollView = UIScrollView()
    
    let greetingLabel = UILabel(text: "Pleased to see you!", font: .galvji30())
    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Password")
    let confirmPasswordLabel = UILabel(text: "Confirm password")
    let alreadyWithUsLabel = UILabel(text: "Already with us?")
    
    let emailextField = UnderlinedTextField(font: .galvji20())
    let passwordTextField = UnderlinedTextField(font: .galvji20())
    let confirmPasswordtextField = UnderlinedTextField(font: .galvji20())
    
    let signUpButon = UIButton(title: "Sign up", titleColor: .white, backgroundColor: .darkButtonColor(), isShadow: false)
    let loginButton = UIButton(title: "Login", titleColor: .mainYellow(), backgroundColor: nil)
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        signUpButon.addTarget(self, action: #selector(signUpButonPressed), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        scrollView.contentSize = view.frame.size
    }
    
}



//MARK: - Buttons realization
extension SignUpViewController {
    @objc private func signUpButonPressed() {
        AuthService.shared.register(email: emailextField.text,
                                    password: passwordTextField.text,
                                    confirmPassword: confirmPasswordtextField.text) { result in
            switch result {
            
            case .success(let user):
                self.showAlert(with: "Success", and: "You have been registrated") {
                    self.present(SetupProfileViewController(currentUser: user), animated: true)
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
        
        view.backgroundColor = .mainDark()
        
        scrollView.hideKeyboardWhenTappedOrSwiped()
        scrollView.addKeyboardObservers()
        
        [greetingLabel, emailLabel, passwordLabel, confirmPasswordLabel].forEach { label in
            label.textColor = .mainYellow()
        }
        
        alreadyWithUsLabel.textColor = .lightGray
        
        emailextField.autocapitalizationType = .none
        passwordTextField.autocapitalizationType = .none
        confirmPasswordtextField.autocapitalizationType = .none
        
        let emailStackView = UIStackView(
            arrangedSubviews: [emailLabel, emailextField], axis: .vertical, spacing: 10)
        let passwordStackView = UIStackView(
            arrangedSubviews: [passwordLabel, passwordTextField], axis: .vertical, spacing: 10)
        let confirmPasswordStackView = UIStackView(
            arrangedSubviews: [confirmPasswordLabel, confirmPasswordtextField], axis: .vertical, spacing: 10)
        
        let stackView = UIStackView(arrangedSubviews: [
        emailStackView, passwordStackView, confirmPasswordStackView, signUpButon
        ], axis: .vertical, spacing: 40)
        
        let bottomStackView = UIStackView(arrangedSubviews: [alreadyWithUsLabel, loginButton],
                                          axis: .horizontal, spacing: 0)
        
        let secondaryView = UIView()
        secondaryView.layer.cornerRadius = 20
        secondaryView.backgroundColor = .secondaryDark()
        
        view.addSubview(scrollView)
        scrollView.addSubview(greetingLabel)
        scrollView.addSubview(secondaryView)
        scrollView.addSubview(stackView)
        scrollView.addSubview(bottomStackView)
        
        [scrollView, greetingLabel, stackView, signUpButon, bottomStackView,loginButton, secondaryView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            greetingLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 100),
            greetingLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 150),
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8),
            
            bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 100),
            bottomStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            secondaryView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: -35),
            secondaryView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondaryView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            secondaryView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 35),
            
            signUpButon.heightAnchor.constraint(equalToConstant: 60),
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
