//
//  ViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 12.10.2022.
//

import UIKit
import Lottie
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

protocol AuthViewControllerProtocol: BaseViewCotrollerProtocol {
  func showAlert(with title: String, and message: String?, completion: @escaping () -> Void)
  func showAlert(with title: String, and message: String?)
}

final class AuthViewController: BaseViewController {
  
  private let backgroundAnimationView = LottieAnimationView(name: "BackgroundAnimation")
  private let logoImage = UIImageView(named: "inSociety", contentMode: .scaleAspectFit)
  private let googleLabel = UILabel(text: AuthString.getStartedWith.localized)
  private let emailLabel = UILabel(text: AuthString.orSignUpWith.localized)
  private let loginLabel = UILabel(text: AuthString.alreadyOnBoard.localized)
  
  private let googleButton = UIButton(title: AuthString.google.localized, titleColor: .black, backgroundColor: .white)
  private let emailButton = UIButton(title: AuthString.email.localized, titleColor: .black, backgroundColor: .mainYellow)
  private let loginButton = UIButton(title: AuthString.login.localized, titleColor: .mainYellow, backgroundColor: nil)
  
  var presenter: AuthPresenterInputProtocol!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let configurator = AuthConfigurator()
    configurator.configure(with: self)
    playBackgroundAnimation()
    setupViews()
  }
  
  deinit {
    stopBackgroundAnimation()
  }
  
}

private extension AuthViewController {
  func setupViews() {
    view.backgroundColor = .mainDark
    logoImage.setupColor(.mainYellow)
    emailButton.addBaseShadow()
    
    loginButton.layer.borderColor = UIColor.mainYellow.cgColor
    loginButton.addBaseShadow()
    loginButton.layer.borderWidth = 2
    
    googleButton.customizeGoogleButton()
    
    emailButton.addTarget(self, action: #selector(emailButtonPressed), for: .touchUpInside)
    loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
    googleButton.addTarget(self, action: #selector(googleButtonPressed), for: .touchUpInside)
    
    [googleLabel, emailLabel, loginLabel].forEach { label in
      label.textColor = .lightGray
    }
    setupConstraints()
  }
  
  func setupConstraints() {
    let googleView = LabelButtonView(label: googleLabel, button: googleButton)
    let emailView = LabelButtonView(label: emailLabel, button: emailButton)
    let loginView = LabelButtonView(label: loginLabel, button: loginButton)
    
    let stackView = UIStackView(arrangedSubviews: [googleView, emailView, loginView],
                                axis: .vertical, spacing: 50)
    
    [logoImage, stackView].forEach { subView in
      view.addSubview(subView)
      subView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    NSLayoutConstraint.activate([
      logoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
      logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      logoImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
      logoImage.heightAnchor.constraint(equalTo: logoImage.widthAnchor, multiplier: 0.34),
      
      stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
      stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -view.frame.width * 0.25)
    ])
  }
  
  func playBackgroundAnimation() {
    backgroundAnimationView.frame = view.bounds
    backgroundAnimationView.alpha = 0.4
    backgroundAnimationView.contentMode = .scaleAspectFit
    backgroundAnimationView.loopMode = .autoReverse
    backgroundAnimationView.animationSpeed = 0.3
    view.addSubview(backgroundAnimationView)
    backgroundAnimationView.play()
  }
  
  func stopBackgroundAnimation() {
    self.backgroundAnimationView.stop()
    self.backgroundAnimationView.removeFromSuperview()
    LottieAnimationCache.shared?.clearCache()
  }
  
  // MARK: - Actions
  @objc func emailButtonPressed() {
    presenter.emailButtonPressed()
  }
  
  @objc func loginButtonPressed() {
    presenter.loginButtonPressed()
  }
  
  @objc func googleButtonPressed() {
    AuthService.shared.googleLogin(presentingVC: self) { [weak self] result in
      self?.presenter.signInWithGoogle(with: result)
    }
  }
}

extension AuthViewController: AuthViewControllerProtocol {
  
}
