//
//  MainTabBarController.swift
//  inSociety
//
//  Created by Aleksey Libin on 14.10.2022.
//

import UIKit

protocol MainTabBarControllerProtocol: AnyObject {
  
}

final class MainTabBarController: UITabBarController {
  
  private let currentUser: UserModel
  var presenter: MainPresenterProtocol!
  private let configurator: MainConfiguratorProtocol = MainConfigurator()
  
  init(currentUser: UserModel) {
    self.currentUser = currentUser
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .mainDark
    tabBar.tintColor = .mainYellow
    
    configurator.configure(viewController: self)
    let peopleViewController = PeopleViewController(currentUser: currentUser)
    let listViewController = ChatsViewController(currentUser: currentUser)
    let profileViewController = ProfileViewController(currentUser: currentUser)
    
    guard
      let peopleImage = UIImage(named: "peopleTabBarImage"),
      let chatImage = UIImage(named: "chatsTabBarImage"),
      let profileImage = UIImage(named: "profileTabBarImage")
    else { return }
    
    viewControllers = [
      generateViewController(rootViewControler: peopleViewController,
                             title: MainString.people.localized, image: peopleImage),
      
      generateViewController(rootViewControler: listViewController,
                             title: MainString.chats.localized, image: chatImage),
      
      generateViewController(rootViewControler: profileViewController,
                             title: MainString.profile.localized, image: profileImage)
    ]
  }
  
  private func generateViewController(rootViewControler: UIViewController, title: String, image: UIImage) -> UIViewController {
    let navigationVC = UINavigationController(rootViewController: rootViewControler)
    navigationVC.tabBarItem.title = title
    navigationVC.tabBarItem.image = image
    return navigationVC
  }
}

extension MainTabBarController: MainTabBarControllerProtocol {
  
}
