//
//  MainTabBarController.swift
//  inSociety
//
//  Created by Aleksey Libin on 14.10.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listViewController = ListViewController()
        let peopleViewController = PeopleViewController()
        
        tabBar.tintColor = .black
        
        guard
            let peopleImage = UIImage(named: "PeopleTabBarLogo"),
            let chatImage = UIImage(named: "ChatTabBarLogo")
        else { return }
        
        viewControllers = [
            generateViewController(rootViewControler: listViewController,
                                   title: "Conversations", image: chatImage),
            
            generateViewController(rootViewControler: peopleViewController,
                                   title: "People", image: peopleImage)
        ]
    }
    
    private func generateViewController(rootViewControler: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewControler)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        
        return navigationVC
    }
}
