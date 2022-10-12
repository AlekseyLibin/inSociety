//
//  ViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 12.10.2022.
//

import UIKit

class AuthViewController: UIViewController {
    
    let logoImage = UIImageView(image: .inSociety(), contentMode: .scaleAspectFit)
    
    let googleLabel = UILabel(text: "Get started with")
    let emailLabel = UILabel(text: "Or sign up with")
    let loginLabel = UILabel(text: "Already on board?")
    
    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white, isShadow: true)
    let emailButton = UIButton(title: "Email", titleColor: .white, backgroundColor: .emailButtonColor())
    let loginButton = UIButton(title: "Login", titleColor: .loginButtonColor(), backgroundColor: .white, isShadow: true)
    override func viewDidLoad() {
        super.viewDidLoad()
         
        view.backgroundColor = .gray
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

