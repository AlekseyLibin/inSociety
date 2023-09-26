//
//  SetupProfileInteractor.swift
//  inSociety
//
//  Created by Aleksey Libin on 30.11.2022.
//

import UIKit

protocol SetupProfileInteractorProtocol {
  func submitButtonPressed(with newUser: SetupNewUser, completion: @escaping (Result<UserModel, Error>) -> Void)
  func getDataForCurrentUser(completion: @escaping (Result<UserModel, Error>) -> Void)
}

final class SetupProfileInteractor {
  
}

extension SetupProfileInteractor: SetupProfileInteractorProtocol {
  func getDataForCurrentUser(completion: @escaping (Result<UserModel, Error>) -> Void) {
    FirestoreService.shared.getCurrentUserModel(completion: completion)
  }
  
  func submitButtonPressed(with newUser: SetupNewUser, completion: @escaping (Result<UserModel, Error>) -> Void) {
    FirestoreService.shared.profile(save: newUser) { result in
      switch result {
      case .success(let currentUserModel):
        completion(.success(currentUserModel))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
}
