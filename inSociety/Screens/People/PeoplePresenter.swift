//
//  PeoplePresenter.swift
//  inSociety
//
//  Created by Aleksey Libin on 03.02.2023.
//

import Foundation
import FirebaseFirestore

protocol PeoplePresenterProtocol: AnyObject {
  func usersObserve(users: [UserModel], completion: @escaping(Result<[UserModel], Error>) -> Void) -> ListenerRegistration?
  func friendSelected(_ userModel: UserModel)
}

final class PeoplePresenter {
  
  init(viewContrroller: PeopleViewController) {
    self.viewController = viewContrroller
  }
  
  private unowned let viewController: PeopleViewControllerProtocol
  var interactor: PeopleInteractorProtocol!
  var router: PeopleRouterProtocol!
  
}

extension PeoplePresenter: PeoplePresenterProtocol {
  func friendSelected(_ userModel: UserModel) {
    interactor.checkNoChats(with: userModel) { result in
      switch result {
      case .success:
        self.router.toSendRequestVC(userModel)
      case .failure(let error):
        self.viewController.showAlert(with: error.localizedDescription, and: "")
      }
    }
  }
  
  func usersObserve(users: [UserModel], completion: @escaping(Result<[UserModel], Error>) -> Void) -> ListenerRegistration? {
    interactor.usersObserve(users: users, completion: completion)
  }
  
  func checkNoChats(with friend: UserModel, completion: @escaping (Result<Void, Error>) -> Void) {
    interactor.checkNoChats(with: friend, completion: completion)
  }
}
