//
//  LoginViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 13.10.2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    let greetingLabel = UILabel(text: "Welcome back!", font: .galvji26())
    let loginWithLabel = UILabel(text: "Login with")
    let orLabel = UILabel(text: "or")
    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Password")
    
    let emailextField = UnderlinedTextField(font: .galvji20())
    let passwordTextField = UnderlinedTextField(font: .galvji20())
    
    
    let loginButon = UIButton(title: "Login",
                              titleColor: .white, backgroundColor: .darkButtonColor())
    let googleButton = UIButton(title: "Google",
                                titleColor: .black, backgroundColor: .white, isShadow: true)
    let signUpButton = UIButton(title: "Create new account",
                                titleColor: .signUpButonTitleColor(), backgroundColor: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setUpViews()
    }
}


//MARK: - Setup views
extension LoginViewController {
    
    private func setUpViews() {
        googleButton.customizedGoogleButton()

        let loginView = LabelButtonView(label: loginWithLabel, button: googleButton)
        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailextField],
                                         axis: .vertical, spacing: 10)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField],
                                            axis: .vertical, spacing: 10)
        let stackView = UIStackView(arrangedSubviews: [
            loginView, orLabel, emailStackView, passwordStackView, loginButon, signUpButton
        ], axis: .vertical, spacing: 50)
        
        view.addSubview(greetingLabel)
        view.addSubview(stackView)
        
        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            greetingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 100),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            loginButon.heightAnchor.constraint(equalToConstant: 60)
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
