//
//  SignUpInteractor.swift
//  inSociety
//
//  Created by Aleksey Libin on 30.11.2022.
//

import FirebaseAuth

protocol SignUpInteractorProtocol: AnyObject {
    func registrateUser(email: String?, password: String?,
                        confirmPass: String?, completion: @escaping(Result<User, Error>) -> Void)
}

final class SignUpInteractor {
    
}

extension SignUpInteractor: SignUpInteractorProtocol {
    
    func registrateUser(email: String?, password: String?,
                        confirmPass: String?, completion: @escaping (Result<User, Error>) -> Void) {
        AuthService.shared.register(email: email,
                                    password: password,
                                    confirmPassword: confirmPass) { result in
            
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error ):
                completion(.failure(error))
            }
        }
    }
    
}
