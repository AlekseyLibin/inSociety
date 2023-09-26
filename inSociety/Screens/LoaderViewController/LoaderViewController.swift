//
//  LoaderViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 05.09.2023.
//

import UIKit
import FirebaseAuth

final class LoaderViewController: UIViewController {
  
  private let titleLabel = UILabel(text: "InSociety", font: .boldSystemFont(ofSize: 60))
  private let poweredByLabel = UILabel(text: "Powered by", font: .systemFont(ofSize: 16))
  private let nameLabel = UILabel(text: "Aleksey Libin", font: UIFont(name: "Hiragino Sans W3", size: 20))
  private let labelsStackView: UIStackView
  private let scrollView = UIScrollView()
  private let titleLogoImageView = UIImageView(named: "logo.rounded", contentMode: .scaleAspectFit)
  private let greetingLabel = UILabel(text: LoaderString.greeting.localized, font: .systemFont(ofSize: 16))
  private let privacyPolicyButton = UIButton()
  private let termsOfUseButton = UIButton()
  private let agreeButton = UIButton()
  private let agreeLabel = UILabel(text: LoaderString.iAgreeToConditions.localized)
  private let continueButton = CustomButton(title: LoaderString.continue.localized, titleColor: .white,
                                                    font: .boldSystemFont(ofSize: 25), mainBackgroundColor: .systemBlue,
                                                    highlight: true, cornerRadius: 15)
  
  private var privacyPolicyVC: DocumentViewController!
  private var termsOfUseVC: DocumentViewController!
  
  private let isUserAgreedWithConditions: Bool
  
  init() {
    labelsStackView = UIStackView(arrangedSubviews: [poweredByLabel, nameLabel], axis: .vertical, spacing: 0)
    isUserAgreedWithConditions = UserDefaults.standard.bool(forKey: "isUserAgreedWithConditions")
    super.init(nibName: nil, bundle: nil)
    setupDefaultViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
//    navigationController?.setNavigationBarHidden(!isUserAgreedWithConditions, animated: false)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if isUserAgreedWithConditions {
      navigateToNextScreen()
    } else {
      showNewUserContent()
    }
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
//    navigationController?.setNavigationBarHidden(false, animated: false)
  }
  
  private func navigateToNextScreen() {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = windowScene.windows.first else { return }
    if Auth.auth().currentUser != nil {
      FirestoreService.shared.getCurrentUserModel { [weak self] result in
        switch result {
        case .success(let currentUser):
          window.rootViewController = MainTabBarController(currentUser: currentUser)
          self?.navigationController?.setViewControllers([], animated: false)
        case .failure:
          self?.navigationController?.setViewControllers([AuthViewController()], animated: true)
          window.rootViewController = self?.navigationController
        }
      }
    } else {
      self.navigationController?.setViewControllers([AuthViewController()], animated: true)
      window.rootViewController = navigationController
    }
  }
  
  @objc private func showPrivacyPolicy() {
    present(privacyPolicyVC, animated: true)
  }
  
  @objc private func showTermsOfUse() {
    present(termsOfUseVC, animated: true)
  }
  
  @objc private func agreeButtonPressed(_ sender: UIButton) {
    guard let image = sender.currentImage else { return }
    if image == UIImage(systemName: "square") {
      sender.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
      continueButton.isEnabled = true
      continueButton.backgroundColor = .systemBlue
    } else if image == UIImage(systemName: "checkmark.square.fill") {
      sender.setImage(UIImage(systemName: "square"), for: .normal)
      continueButton.isEnabled = false
      continueButton.backgroundColor = .lightGray
    }
  }
  
  @objc private func continueButtonPressed() {
    UserDefaults.standard.set(true, forKey: "isUserAgreedWithConditions")
    navigationController?.setViewControllers([AuthViewController()], animated: true)
  }
  
  private func setupDefaultViews() {
    view.backgroundColor = .mainDark
    
    titleLogoImageView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(titleLogoImageView)
    
    poweredByLabel.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1)
    nameLabel.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1)
    labelsStackView.alignment = .center
    labelsStackView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(labelsStackView)
    
    NSLayoutConstraint.activate([
      titleLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      titleLogoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -20),
      titleLogoImageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.75),
      titleLogoImageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.75),
      
      labelsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      labelsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
      nameLabel.heightAnchor.constraint(equalToConstant: 30)
    ])
  }
  
  private func showNewUserContent() {
    privacyPolicyVC = DocumentViewController(.privacyPolicy)
    termsOfUseVC = DocumentViewController(.termsOfUse)
    
    view.addSubview(scrollView)
    scrollView.delaysContentTouches = false
    scrollView.showsVerticalScrollIndicator = false
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    
    titleLabel.textColor = .white
    titleLabel.adjustsFontSizeToFitWidth = true
    titleLabel.textAlignment = .center
    titleLabel.alpha = 0
    view.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    titleLogoImageView.removeFromSuperview()
    view.addSubview(titleLogoImageView)
    titleLogoImageView.translatesAutoresizingMaskIntoConstraints = false
    
    greetingLabel.textColor = .white
    greetingLabel.adjustsFontSizeToFitWidth = true
    greetingLabel.alpha = 0
    greetingLabel.numberOfLines = 0
    greetingLabel.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(greetingLabel)
    
    NSLayoutConstraint.activate([
      greetingLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
      greetingLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      greetingLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9)
    ])
    
    privacyPolicyButton.setTitle(LoaderString.privacyPolicy.localized, for: .normal)
    privacyPolicyButton.titleLabel?.font = .systemFont(ofSize: 15)
    privacyPolicyButton.titleLabel?.textAlignment = .left
    privacyPolicyButton.setTitleColor(.mainYellow, for: .normal)
    privacyPolicyButton.setTitleColor(.mainDark, for: .highlighted)
    privacyPolicyButton.alpha = 0
    privacyPolicyButton.addTarget(self, action: #selector(showPrivacyPolicy), for: .touchUpInside)
    privacyPolicyButton.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(privacyPolicyButton)
    
    NSLayoutConstraint.activate([
      privacyPolicyButton.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 30),
      privacyPolicyButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15)
    ])
    
    termsOfUseButton.setTitle(LoaderString.termsOfUse.localized, for: .normal)
    termsOfUseButton.titleLabel?.font = .systemFont(ofSize: 15)
    termsOfUseButton.titleLabel?.textAlignment = .left
    termsOfUseButton.setTitleColor(.mainYellow, for: .normal)
    termsOfUseButton.setTitleColor(.mainDark, for: .highlighted)
    termsOfUseButton.alpha = 0
    termsOfUseButton.addTarget(self, action: #selector(showTermsOfUse), for: .touchUpInside)
    termsOfUseButton.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(termsOfUseButton)
    
    NSLayoutConstraint.activate([
      termsOfUseButton.topAnchor.constraint(equalTo: privacyPolicyButton.bottomAnchor),
      termsOfUseButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15)
    ])
    
    agreeButton.setImage(UIImage(systemName: "square"), for: .normal)
    agreeButton.addTarget(self, action: #selector(agreeButtonPressed), for: .touchUpInside)
    agreeButton.alpha = 0
    agreeButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(agreeButton)
    
    agreeLabel.font = .systemFont(ofSize: 12)
    agreeLabel.adjustsFontSizeToFitWidth = true
    agreeLabel.textColor = .lightGray
    agreeLabel.textAlignment = .left
    agreeLabel.numberOfLines = 0
    agreeLabel.alpha = 0
    agreeLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(agreeLabel)
    
    continueButton.isEnabled = false
    continueButton.backgroundColor = .lightGray
    continueButton.setTitle(LoaderString.continue.localized, for: .normal)
    continueButton.titleLabel?.textAlignment = .center
    continueButton.setTitleColor(.gray, for: .highlighted)
    continueButton.alpha = 0
    continueButton.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
    continueButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(continueButton)
    
    NSLayoutConstraint.activate([
      continueButton.heightAnchor.constraint(equalToConstant: 60),
      continueButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
      continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
      
      agreeButton.leadingAnchor.constraint(equalTo: continueButton.leadingAnchor),
      agreeButton.widthAnchor.constraint(equalToConstant: 40),
      agreeButton.heightAnchor.constraint(equalToConstant: 50),
      agreeButton.bottomAnchor.constraint(equalTo: continueButton.topAnchor),
      
      agreeLabel.leadingAnchor.constraint(equalTo: agreeButton.trailingAnchor),
      agreeLabel.trailingAnchor.constraint(equalTo: continueButton.trailingAnchor),
      agreeLabel.bottomAnchor.constraint(equalTo: agreeButton.bottomAnchor),
      agreeLabel.topAnchor.constraint(equalTo: agreeButton.topAnchor)
    ])
    
    UIView.animate(withDuration: 0.5, delay: 0.25, options: .curveEaseOut) {
      self.moveLogoToTop()
    } completion: { _ in
      UIView.animate(withDuration: 0.8, delay: 0.1, options: .curveEaseOut) {
        self.expandTitleView()
      } completion: { _ in
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
          self.showContent()
        }
      }
    }
  }
  
  private func moveLogoToTop() {
    NSLayoutConstraint.activate([
      titleLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      titleLogoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
      titleLogoImageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
      titleLogoImageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
      
      titleLabel.leadingAnchor.constraint(equalTo: titleLogoImageView.leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: titleLogoImageView.trailingAnchor),
      titleLabel.topAnchor.constraint(equalTo: titleLogoImageView.topAnchor),
      titleLabel.bottomAnchor.constraint(equalTo: titleLogoImageView.bottomAnchor)
    ])
    
    labelsStackView.removeFromSuperview()
    titleLogoImageView.layoutIfNeeded()
    view.layoutIfNeeded()
  }
  
  private func expandTitleView() {
    titleLabel.removeFromSuperview()
    titleLabel.alpha = 1
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(titleLabel)
    
    titleLogoImageView.removeFromSuperview()
    titleLogoImageView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(titleLogoImageView)
    
    NSLayoutConstraint.activate([
      titleLogoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
      titleLogoImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
      titleLogoImageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.25),
      titleLogoImageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.25),
      
      titleLabel.leadingAnchor.constraint(equalTo: titleLogoImageView.trailingAnchor, constant: 25),
      titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -35),
      titleLabel.topAnchor.constraint(equalTo: titleLogoImageView.topAnchor),
      titleLabel.bottomAnchor.constraint(equalTo: titleLogoImageView.bottomAnchor),
      
      scrollView.topAnchor.constraint(equalTo: titleLogoImageView.bottomAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -130)
    ])
    
    titleLabel.layoutIfNeeded()
    self.titleLogoImageView.layoutIfNeeded()
    self.view.layoutIfNeeded()
  }
  
  private func showContent() {
    let height = 100 + greetingLabel.frame.height + privacyPolicyButton.frame.height + termsOfUseButton.frame.height
    self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: height)
    greetingLabel.alpha = 1
    privacyPolicyButton.alpha = 1
    termsOfUseButton.alpha = 1
    agreeButton.alpha = 1
    agreeLabel.alpha = 1
    self.continueButton.alpha = 1
    self.view.layoutIfNeeded()
  }
}
