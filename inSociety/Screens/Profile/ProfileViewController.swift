//
//  ProfileViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 01.11.2022.
//

import UIKit
import SDWebImage
import FirebaseAuth

protocol ProfileViewControllerProtocol: BaseViewCotrollerProtocol {
  func showAlert(with title: String, and message: String?)
  func updateViews(with userModel: UserModel)
  func activeChats(changeQuantity count: Int)
  func waitingChats(changeQuantity count: Int)
  var currentUser: UserModel { get }
}

final class ProfileViewController: BaseViewController {
  
  let currentUser: UserModel
  
  private let avatarView = UIImageView()
  private let avatarActivityIndicatorView = UIActivityIndicatorView()
  private let fullNameLabel = UILabel()
  private let aboutMeLabel = UILabel()
  private let activeChatsNumberLabel = UILabel(text: ProfileString.activeChats.localized)
  private let waitingChatsNumberLabel = UILabel(text: ProfileString.waitingChats.localized)
  private let editButton = CustomButton(title: ProfileString.edit.localized, titleColor: .systemBlue, mainBackgroundColor: .secondaryDark)
  private let logOutButton = CustomButton(title: ProfileString.logOutOrDelete.localized, titleColor: .systemRed, mainBackgroundColor: .secondaryDark)
  private let configurator: ProfileConfiguratorProtocol = ProfileConfigurator()
  var presenter: ProfilePresenterProtocol!
  
  init(currentUser: UserModel) {
    self.currentUser = currentUser
    super.init(nibName: nil, bundle: nil)
    configurator.configure(viewController: self)
    setupTopBar()
    setupViews()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    presenter.fillUpActualInformation()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    presenter.fillUpActualInformation()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Setup Views
private extension ProfileViewController {
  func setupViews() {
    view.backgroundColor = .mainDark
    tabBarController?.tabBar.backgroundColor = .mainDark
    presenter.fillChatsInformation(by: currentUser)
    
    editButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
    logOutButton.addTarget(self, action: #selector(logOutButtonPressed), for: .touchUpInside)
    
    avatarView.sd_setImage(with: URL(string: currentUser.avatarString))
    avatarView.clipsToBounds = true
    avatarView.layer.masksToBounds = true
    avatarView.layer.cornerRadius = 15
    avatarView.contentMode = .scaleAspectFill
    
    fullNameLabel.text = currentUser.fullName
    fullNameLabel.font = .light25
    fullNameLabel.textColor = .mainYellow

    aboutMeLabel.text = currentUser.description
    aboutMeLabel.numberOfLines = 0
    aboutMeLabel.font = .italicSystemFont(ofSize: 15)
    aboutMeLabel.textColor = .gray
    
    activeChatsNumberLabel.font = .light25
    activeChatsNumberLabel.textColor = .mainYellow
    
    waitingChatsNumberLabel.font = .light25
    waitingChatsNumberLabel.textColor = .mainYellow
    
    setupConstraints()
  }
  
  @objc func editButtonPressed() {
    presenter.editButtonPressed()
  }
  
  @objc private func logOutButtonPressed() {
    presenter.logOutOrDeleteButtonPressed(by: currentUser)
  }
  
  func setupTopBar() {
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .mainDark
    
    let titleLabel = UILabel(text: ProfileString.profile.localized)
    titleLabel.font = .systemFont(ofSize: 20)
    titleLabel.textColor = .systemGray
    
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    navigationItem.titleView = titleLabel
  }
  
  func setupConstraints() {
    let profileInformationBackgroudView = UIView()
    profileInformationBackgroudView.layer.cornerRadius = 15
    profileInformationBackgroudView.backgroundColor = .secondaryDark
    
    profileInformationBackgroudView.addSubview(avatarView)
    profileInformationBackgroudView.addSubview(avatarActivityIndicatorView)
    profileInformationBackgroudView.addSubview(fullNameLabel)
    profileInformationBackgroudView.addSubview(aboutMeLabel)
    
    profileInformationBackgroudView.translatesAutoresizingMaskIntoConstraints = false
    avatarView.translatesAutoresizingMaskIntoConstraints = false
    avatarActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
    aboutMeLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(profileInformationBackgroudView)
    
    let chatsInformationStackView = UIStackView(arrangedSubviews: [activeChatsNumberLabel, waitingChatsNumberLabel])
    chatsInformationStackView.backgroundColor = .secondaryDark
    chatsInformationStackView.layer.cornerRadius = 20
    chatsInformationStackView.axis = .vertical
    chatsInformationStackView.distribution = .fillEqually
    activeChatsNumberLabel.translatesAutoresizingMaskIntoConstraints = false
    waitingChatsNumberLabel.translatesAutoresizingMaskIntoConstraints = false
    chatsInformationStackView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(chatsInformationStackView)
    
    editButton.translatesAutoresizingMaskIntoConstraints = false
    editButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .light)
    view.addSubview(editButton)
    
    logOutButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(logOutButton)
    
    NSLayoutConstraint.activate([
      profileInformationBackgroudView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      profileInformationBackgroudView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
      profileInformationBackgroudView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
      profileInformationBackgroudView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
      
      avatarView.topAnchor.constraint(equalTo: profileInformationBackgroudView.topAnchor, constant: 10),
      avatarView.leadingAnchor.constraint(equalTo: profileInformationBackgroudView.leadingAnchor, constant: 10),
      avatarView.bottomAnchor.constraint(equalTo: profileInformationBackgroudView.bottomAnchor, constant: -10),
      avatarView.widthAnchor.constraint(equalTo: avatarView.heightAnchor, multiplier: 1),
      
      avatarActivityIndicatorView.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
      avatarActivityIndicatorView.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
      
      fullNameLabel.topAnchor.constraint(equalTo: avatarView.topAnchor),
      fullNameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 20),
      fullNameLabel.trailingAnchor.constraint(equalTo: profileInformationBackgroudView.trailingAnchor, constant: -20),

      aboutMeLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 15),
      aboutMeLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 20),
      aboutMeLabel.trailingAnchor.constraint(equalTo: profileInformationBackgroudView.trailingAnchor, constant: -20),
      aboutMeLabel.bottomAnchor.constraint(equalTo: profileInformationBackgroudView.bottomAnchor, constant: -15),
      
      editButton.topAnchor.constraint(equalTo: profileInformationBackgroudView.bottomAnchor, constant: 20),
      editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      editButton.widthAnchor.constraint(equalTo: profileInformationBackgroudView.widthAnchor),
      editButton.heightAnchor.constraint(equalTo: editButton.widthAnchor, multiplier: 0.125),
      
      chatsInformationStackView.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 50),
      chatsInformationStackView.leadingAnchor.constraint(equalTo: profileInformationBackgroudView.leadingAnchor),
      chatsInformationStackView.trailingAnchor.constraint(equalTo: profileInformationBackgroudView.trailingAnchor),
      chatsInformationStackView.heightAnchor.constraint(equalTo: profileInformationBackgroudView.heightAnchor, multiplier: 1.2),
      activeChatsNumberLabel.leadingAnchor.constraint(equalTo: chatsInformationStackView.leadingAnchor, constant: 20),
      
      logOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
      logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      logOutButton.widthAnchor.constraint(equalTo: profileInformationBackgroudView.widthAnchor),
      logOutButton.heightAnchor.constraint(equalTo: logOutButton.widthAnchor, multiplier: 0.15)
    ])
  }
}

extension ProfileViewController: ProfileViewControllerProtocol {
  func updateViews(with userModel: UserModel) {
    avatarActivityIndicatorView.isHidden = false
    avatarActivityIndicatorView.startAnimating()
    
    let userImageURL = URL(string: userModel.avatarString)
    avatarView.sd_setImage(with: userImageURL) { [weak self] _, _, _, _ in
      self?.avatarActivityIndicatorView.stopAnimating()
      self?.avatarActivityIndicatorView.isHidden = true
    }
    
    fullNameLabel.text = userModel.fullName
    aboutMeLabel.text = userModel.description
  }
  
  func activeChats(changeQuantity count: Int) {
    self.activeChatsNumberLabel.text = "\(ProfileString.activeChats.localized): \(count.description)"
  }
  
  func waitingChats(changeQuantity count: Int) {
    self.waitingChatsNumberLabel.text = "\(ProfileString.waitingChats.localized): \(count.description)"
  }
}
