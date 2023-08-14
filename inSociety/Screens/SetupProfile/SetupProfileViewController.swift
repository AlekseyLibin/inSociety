//
//  SetupProfileViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 13.10.2022.
//

import UIKit
import FirebaseAuth
import SDWebImage

protocol SetupProfileViewControllerProtocol: BaseViewCotrollerProtocol {
  func showAlert(with title: String, and message: String?, completion: @escaping () -> Void)
  func updateViews(with userModel: UserModel)
  var currentUser: User { get }
  var target: SetupProfileViewController.Target { get }
}

final class SetupProfileViewController: BaseViewController {
  
  enum Target {
    case create
    case modify
  }
  
  private let fillImageView = FillImageView()
  private let scrollView = UIScrollView()
  private let setupView = UIView()
  private let fullNameLabel = UILabel(text: "Full name")
  private let aboutMeLabel = UILabel(text: "About me")
  private let sexLabel = UILabel(text: "Sex")
  private let fullNameTextField = UnderlinedTextField(font: .galvji20())
  private let aboutMeTextField = UnderlinedTextField(font: .galvji20())
  private let sexSegmentedControl = UISegmentedControl(elements: UserModel.Sex.allCases)
  private let submitButton = UIButton(title: "Submit", titleColor: .white,
                                      backgroundColor: .thirdDark())
  
  var presenter: SetupProfilePresenterProtocol!
  private let configurator: SetupProfileConfiguratorProtocol = SetupProfileConfigurator()
  
  let currentUser: User
  let target: Target
  
  init(currentUser: User, target: SetupProfileViewController.Target) {
    self.currentUser = currentUser
    self.target = target
    super.init(nibName: nil, bundle: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configurator.configure(viewController: self)
    presenter.fillAvailableDataForCurrentUser()
    setupViews()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    UserDefaults.standard.set(tabBarController?.tabBar.frame.height,
                              forKey: "tabBarHeight")
    UserDefaults.standard.synchronize()
    setupContentSize()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupContentSize() {
    let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
    let setupViewHeight = setupView.frame.height
    scrollView.contentSize = CGSize(width: view.frame.width, height: setupViewHeight + tabBarHeight)
  }
  
  @objc private func addProfilePhoto() {
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    imagePickerController.sourceType = .photoLibrary
    present(imagePickerController, animated: true)
  }
  
  @objc private func submitButtonPressed() {
    let newUser = SetupNewUser(name: fullNameTextField.text,
                               avatarImage: fillImageView.profileImage,
                               email: currentUser.email ?? "no email",
                               desctiption: aboutMeTextField.text,
                               sex: sexSegmentedControl.titleForSegment(at: sexSegmentedControl.selectedSegmentIndex),
                               id: currentUser.uid)
    
    presenter.submitButtonPressed(with: newUser)
  }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension SetupProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    picker.dismiss(animated: true)
    guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
    fillImageView.setProfileImage(image)
    
  }
}

// MARK: - Setup views
private extension SetupProfileViewController {
  func setupViews() {
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .mainDark()
    
    let titleLabel = UILabel(text: "Setup Profile")
    titleLabel.font = .systemFont(ofSize: 25)
    titleLabel.textColor = .mainYellow()
    
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    
    navigationItem.titleView = titleLabel
    view.backgroundColor = .mainDark()
    
    scrollView.showsVerticalScrollIndicator = false
    scrollView.addKeyboardObservers()
    scrollView.hideKeyboardWhenTappedOrSwiped()
    
    submitButton.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
    submitButton.setTitleColor(.mainYellow(), for: .normal)
    fillImageView.buttonPressed(target: self, action:  #selector(addProfilePhoto), for: .touchUpInside)
    
    [fullNameLabel, aboutMeLabel, sexLabel].forEach { label in
      label.textColor = .mainYellow()
    }
    
    sexSegmentedControl.selectedSegmentTintColor = UIColor.mainYellow()
    let yellowAttribute = [NSAttributedString.Key.foregroundColor: UIColor.mainYellow()]
    sexSegmentedControl.setTitleTextAttributes(yellowAttribute, for:.normal)
    let blackAttribute = [NSAttributedString.Key.foregroundColor: UIColor.black]
    sexSegmentedControl.setTitleTextAttributes(blackAttribute, for:.selected)
    
    fullNameTextField.autocapitalizationType = .none
    fullNameTextField.autocorrectionType = .no
    aboutMeTextField.autocapitalizationType = .none
    aboutMeTextField.autocorrectionType = .no
    
    setupConstraints()
  }
  
  func setupConstraints() {
    
    let fullNameStackview = UIStackView(arrangedSubviews: [fullNameLabel, fullNameTextField],
                                        axis: .vertical, spacing: 10)
    let aboutMeStackView = UIStackView(arrangedSubviews: [aboutMeLabel, aboutMeTextField],
                                       axis: .vertical, spacing: 10)
    let sexStackView = UIStackView(arrangedSubviews: [sexLabel, sexSegmentedControl],
                                   axis: .vertical, spacing: 15)
    let stackView = UIStackView(arrangedSubviews: [fullNameStackview, aboutMeStackView, sexStackView, submitButton],
                                axis: .vertical, spacing: 60)
    
    setupView.layer.cornerRadius = 20
    setupView.backgroundColor = .secondaryDark()
    
    view.addSubview(scrollView)
    scrollView.addSubview(setupView)
    scrollView.addSubview(fillImageView)
    scrollView.addSubview(stackView)
    
    [scrollView, setupView,
     fillImageView,
     stackView
    ].forEach { view in
      view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      setupView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 25),
      setupView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
      setupView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
      setupView.bottomAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 25),
      
      fillImageView.topAnchor.constraint(equalTo: setupView.topAnchor, constant: 40),
      fillImageView.centerXAnchor.constraint(equalTo: setupView.centerXAnchor),
      
      stackView.topAnchor.constraint(equalTo: fillImageView.bottomAnchor, constant: 100),
      stackView.leadingAnchor.constraint(equalTo: setupView.leadingAnchor, constant: 25),
      stackView.trailingAnchor.constraint(equalTo: setupView.trailingAnchor, constant: -25),
      
      submitButton.heightAnchor.constraint(equalToConstant: 60)
    ])
  }
}

// MARK: - SetupProfileViewControllerProtocol
extension SetupProfileViewController: SetupProfileViewControllerProtocol {
  func updateViews(with userModel: UserModel) {
    
    let userImageURL = URL(string: userModel.avatarString)
    let newImageView = UIImageView()
    newImageView.sd_setImage(with: userImageURL)
    guard let image = newImageView.image else { return }
    fillImageView.setProfileImage(image)
    
    fullNameTextField.text = userModel.fullName
    aboutMeTextField.text = userModel.description
    sexSegmentedControl.selectedSegmentIndex = UserModel.Sex.allCases.firstIndex(of: userModel.sex) ?? 2
  }
}
