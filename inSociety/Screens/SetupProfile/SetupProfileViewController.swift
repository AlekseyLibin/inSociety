//
//  SetupProfileViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 13.10.2022.
//

import UIKit
import FirebaseAuth
import SDWebImage

protocol SetupProfileViewControllerProtocol: AnyObject {
  func showAlert(with title: String, and message: String?, completion: @escaping () -> Void)
}

final class SetupProfileViewController: BaseViewController {
  
  private let fillImageView = AddPhotoView()
  
  private let scrollView = UIScrollView()
  
  private let setupLabel = UILabel(text: "Setup profile", font: .galvji30())
  private let fullNameLabel = UILabel(text: "Full name")
  private let aboutMeLabel = UILabel(text: "About me")
  private let sexLabel = UILabel(text: "Sex")
  
  private let fullNameTextField = UnderlinedTextField(font: .galvji20())
  private let aboutMeTextField = UnderlinedTextField(font: .galvji20())
  
  private let sexSegmentedControl = UISegmentedControl(elements: ["Male", "Female", "Other"])
  private let submitButton = UIButton(title: "Submit", titleColor: .white,
                                      backgroundColor: .darkButtonColor())
  
  var presenter: SetupProfilePresenterProtocol!
  private let configurator: SetupProfileConfiguratorProtocol = SetupProfileConfigurator()
  
  private let currentUser: User
  
  init(currentUser: User) {
    self.currentUser = currentUser
    super.init(nibName: nil, bundle: nil)
    
    if let name = currentUser.displayName {
      fullNameTextField.text = name
    }
    if let photoUrl = currentUser.photoURL {
      fillImageView.profileImageView.sd_setImage(with: photoUrl)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configurator.configure(viewController: self)
    setupViews()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    scrollView.contentSize = view.frame.size
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc private func addProfilePhoto() {
    
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    imagePickerController.sourceType = .photoLibrary
    present(imagePickerController, animated: true)
    
  }
  
  @objc private func submitButtonPressed() {
    
    let newUser = SetupNewUser(name: fullNameTextField.text,
                               avatarImage: fillImageView.profileImageView.image,
                               email: currentUser.email ?? "no email",
                               desctiption: aboutMeTextField.text,
                               sex: sexSegmentedControl.titleForSegment(at: sexSegmentedControl.selectedSegmentIndex),
                               id: currentUser.uid)
    
    presenter.submitButtonPressed(with: newUser)
  }
}


//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension SetupProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    picker.dismiss(animated: true)
    guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
    fillImageView.profileImageView.image = image
    
  }
}


//MARK: - Setup views
private extension SetupProfileViewController {
  func setupViews() {
    
    view.backgroundColor = .mainDark()
    
    scrollView.addKeyboardObservers()
    scrollView.hideKeyboardWhenTappedOrSwiped()
    
    submitButton.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
    fillImageView.addProfilePhoto.addTarget(self, action: #selector(addProfilePhoto), for: .touchUpInside)
    
    [setupLabel, fullNameLabel, aboutMeLabel, sexLabel].forEach { label in
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
                                axis: .vertical, spacing: 50)
    
    let secondaryView = UIView()
    secondaryView.layer.cornerRadius = 20
    secondaryView.backgroundColor = .secondaryDark()
    
    view.addSubview(scrollView)
    scrollView.addSubview(setupLabel)
    scrollView.addSubview(secondaryView)
    scrollView.addSubview(fillImageView)
    scrollView.addSubview(stackView)
    
    [scrollView, setupLabel, secondaryView, fillImageView, stackView].forEach { view in
      view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    NSLayoutConstraint.activate([
      
      scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      setupLabel.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor, constant: 50),
      setupLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      
      fillImageView.topAnchor.constraint(equalTo: setupLabel.bottomAnchor, constant: 80),
      fillImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      
      stackView.topAnchor.constraint(equalTo: fillImageView.bottomAnchor, constant: 100),
      stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8),
      
      secondaryView.topAnchor.constraint(equalTo: fillImageView.safeAreaLayoutGuide.topAnchor, constant: -35),
      secondaryView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      secondaryView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
      secondaryView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 35),
      
      submitButton.heightAnchor.constraint(equalToConstant: 60)
    ])
  }
}


//MARK: - SetupProfileViewControllerProtocol
extension SetupProfileViewController: SetupProfileViewControllerProtocol {
  
}
