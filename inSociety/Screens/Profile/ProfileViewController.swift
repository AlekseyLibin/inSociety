//
//  ProfileViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 01.11.2022.
//

import UIKit
import SDWebImage
import FirebaseAuth

protocol ProfileViewControllerProtocol: AnyObject {
  func showAlert(with title: String, and message: String?)
  func activeChats(changeQuantity count: Int)
  func waitingChats(changeQuantity count: Int)
}

final class ProfileViewController: BaseViewController {
  
  private let currentUser: UserModel
  
  private var avatarView = UIImageView()
  private var fullNameLabel = UILabel()
  private var descriptionLabel = UILabel()
  private var activeChatsNumberLabel = UILabel(text: "Active chats data")
  private var waitingChatsNumberLabel = UILabel(text: "Waiting chats data")
  
  private var logOutButton = UIButton(title: "Log out", titleColor: .systemRed, backgroundColor: .darkButtonColor())
  private let configurator: ProfileConfiguratorProtocol = ProfileConfigurator()
  var presenter: ProfilePresenterProtocol!
  
  init(currentUser: UserModel) {
    self.currentUser = currentUser
    super.init(nibName: nil, bundle: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configurator.configure(viewController: self)
    
    setupViews()
    
  }
  
  @objc private func logOut() {
    let alertController = UIAlertController(title: "Are you sure you want to log out?", message: nil, preferredStyle: .actionSheet)
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    alertController.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { _ in
      self.presenter.signOut()
    }))
    present(alertController, animated: true)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Setup Views
private extension ProfileViewController {
  func setupViews() {
    view.backgroundColor = .mainDark()
    tabBarController?.tabBar.backgroundColor = .mainDark()
    navigationController?.navigationBar.backgroundColor = .mainDark()
    presenter.fillChatsInformation(by: currentUser)
    logOutButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)
    
    avatarView.sd_setImage(with: URL(string: currentUser.userAvatarString))
    avatarView.clipsToBounds = true
    avatarView.layer.masksToBounds = true
    avatarView.layer.cornerRadius = 10
    avatarView.contentMode = .scaleAspectFill
    
    fullNameLabel.text = currentUser.userName
    fullNameLabel.font = .galvji30()
    fullNameLabel.textColor = .mainYellow()
    fullNameLabel.textAlignment = .center
    
    descriptionLabel.text = currentUser.description
    descriptionLabel.numberOfLines = 3
    descriptionLabel.font = .galvji20()
    descriptionLabel.textColor = .mainYellow()
    
    activeChatsNumberLabel.font = .galvji25()
    activeChatsNumberLabel.textColor = .mainYellow()
    
    waitingChatsNumberLabel.font = .galvji25()
    waitingChatsNumberLabel.textColor = .mainYellow()
    
    setupConstraints()
  }
  
  func setupConstraints() {
    
    let secondaryView = UIView()
    secondaryView.layer.cornerRadius = 20
    secondaryView.backgroundColor = .secondaryDark()
    
    [avatarView, secondaryView, fullNameLabel, descriptionLabel, activeChatsNumberLabel, waitingChatsNumberLabel, logOutButton].forEach { subView in
      view.addSubview(subView)
      subView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    NSLayoutConstraint.activate([
      avatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      avatarView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
      avatarView.heightAnchor.constraint(equalTo: avatarView.widthAnchor),
      
      fullNameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 40),
      fullNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
      fullNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      descriptionLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 30),
      descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
      descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      activeChatsNumberLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 120),
      activeChatsNumberLabel.widthAnchor.constraint(equalToConstant: 250),
      activeChatsNumberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
      
      waitingChatsNumberLabel.topAnchor.constraint(equalTo: activeChatsNumberLabel.bottomAnchor, constant: 20),
      waitingChatsNumberLabel.widthAnchor.constraint(equalToConstant: 250),
      waitingChatsNumberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
      
      logOutButton.topAnchor.constraint(equalTo: waitingChatsNumberLabel.bottomAnchor, constant: 70),
      logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      logOutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
      logOutButton.heightAnchor.constraint(equalToConstant: 50),
      
      secondaryView.topAnchor.constraint(equalTo: fullNameLabel.safeAreaLayoutGuide.topAnchor, constant: -25),
      secondaryView.bottomAnchor.constraint(equalTo: logOutButton.bottomAnchor, constant: 25),
      secondaryView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
      secondaryView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
  }
  
}

extension ProfileViewController: ProfileViewControllerProtocol {
  func activeChats(changeQuantity count: Int) {
    self.activeChatsNumberLabel.text = "Active chats: \(count.description)"
  }
  
  func waitingChats(changeQuantity count: Int) {
    self.waitingChatsNumberLabel.text = "Waiting chats: \(count.description)"
  }
  
}
