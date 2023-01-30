//
//  LoginViewModel.swift
//  JetDevsHomeWork
//
//  Created by Jenson John on 30/01/23.
//

import Foundation
import RxSwift
import RxRelay

class LoginViewModel {
    
    let networkManager = NetworkManager()
    let isLoading = BehaviorRelay<Bool>(value: false)
    let email = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    var loginResult = BehaviorRelay<LoginResponse?>(value: nil)
    let errorMessage = BehaviorRelay<String>(value: "")
    
    // Validations
    var isValidEmail: Observable<Bool> {
        email.map { $0.isValidEmail() }
    }
    
    var isValidPassword: Observable<Bool> {
        password.map { password in
            return password.count < 6 ? false : true
        }
    }
    
    var isValidInput: Observable<Bool> {
        return Observable.combineLatest(isValidEmail, isValidPassword).map({ $0 && $1 })
    }
}

extension LoginViewModel {

    func performLogin() {
        guard let url = URL(string: "https://3d02g.mocklab.io/login") else { fatalError("Invalid URL")
        }
        
        var params = Parameters()
        params["email"] = email.value
        params["password"] = password.value
        isLoading.accept(true)
        
        networkManager.request(fromURL: url, httpMethod: .post, params: params) { [weak self] (result: Result<LoginResponse, Error>) in
            guard let `self` = self else {
                return
            }
            self.isLoading.accept(false)
           
            switch result {
            case .success(let loginResponse):
                self.loginResult.accept(loginResponse)
            case .failure(let error):
                debugPrint("Login API call error: \(error.localizedDescription)")
                self.errorMessage.accept(somethingWentWrong)
            }
        }
        
    }
}
