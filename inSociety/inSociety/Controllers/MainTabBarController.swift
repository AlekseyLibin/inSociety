//
//  MainTabBarController.swift
//  inSociety
//
//  Created by Aleksey Libin on 14.10.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private let currentUser: UserModel
    
    init(currentUser: UserModel = UserModel(userName: "userName",
                                            userAvatarString: "ProfilePhoto",
                                            email: "email",
                                            description: "description",
                                            sex: "sex",
                                            id: "id")) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let peopleViewController = PeopleViewController(currentUser: currentUser)
        let listViewController = ListViewController(currentUser: currentUser)
        let profileViewController = ProfileViewController(currentUser: currentUser)
        
        tabBar.tintColor = .black
//        tabBar.backgroundColor = .black
        
        guard
            let peopleImage = UIImage(named: "PeopleTabBarLogo"),
            let chatImage = UIImage(named: "ChatTabBarLogo"),
            let profileImage = UIImage(named: "ProfileTabBarLogo")
        else { return }
        
        viewControllers = [
            generateViewController(rootViewControler: profileViewController,
                                   title: "Profile", image: profileImage),
            
            generateViewController(rootViewControler: peopleViewController,
                                   title: "People", image: peopleImage),
            
            generateViewController(rootViewControler: listViewController,
                                   title: "Chats", image: chatImage)
            
        ]
    }
    
    private func generateViewController(rootViewControler: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewControler)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        
        return navigationVC
    }
}
