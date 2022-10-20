//
//  Validator.swift
//  inSociety
//
//  Created by Aleksey Libin on 20.10.2022.
//

import Foundation

class Validator {
    
    static func checkRegisterValidation(email: String?,
                                password: String?,
                                confirmPassword: String?) -> AuthError? {
        
        //MARK: - Empty fields
        guard
            let email = email,
            let password = password,
            let confirmPassword = confirmPassword,
            !email.isEmpty,
            !password.isEmpty,
            !confirmPassword.isEmpty
        else { return .fieldsAreNotFilled }
        
        
        //MARK: - Invalid email type
        let emailRegex = "[A-Z0-9a-z.]+@[A-Za-z0-9.]+\\.[A-Za-z]{2,64}"
        let isValid =  NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
        guard isValid else { return .emailInvalid }
        
        
        //MARK: - Invalid password type
        guard !password.isEmpty else { return .passwordFieldIsEmpty }
        guard !password.contains(" ") else { return .passwordContainsSpecificSymbols }
        guard !confirmPassword.isEmpty else { return .confirmPasswordFieldIsEmpty}
        guard password == confirmPassword else { return .passwordsDoNotMatch }
        
        return nil
    }
    
    static func checkLoginValidation(email: String?, password: String?) -> AuthError? {
        
        guard
            let email = email,
            let password = password,
            !email.isEmpty,
            !password.isEmpty
        else { return .fieldsAreNotFilled }
        
        return nil
    }
    
}
