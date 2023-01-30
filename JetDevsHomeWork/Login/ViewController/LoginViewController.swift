//
//  LoginViewController.swift
//  JetDevsHomeWork
//
//  Created by Jenson John on 30/01/23.
//

import UIKit
import MaterialComponents
import RxSwift
import RxCocoa

protocol LoginViewControllerDelegate: AnyObject {
    
    func didLoginSuccess(info: LoginResponse)
}

class LoginViewController: UIViewController {
    
    // IB Outlets
    @IBOutlet weak var emailTextField: MDCOutlinedTextField!
    @IBOutlet weak var passwordTextField: MDCOutlinedTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Declarations
    weak var delegate: LoginViewControllerDelegate?
    private var bag = DisposeBag()
    private let viewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        createObservables()
        configureUI()
        
    }

}

// MARK: - private methods

private extension LoginViewController {
    
    func configureUI() {
        setUpTextFields()
    }
    
    func setUpTextFields() {
        let normalBorderColor = #colorLiteral(red: 0.787740171, green: 0.787740171, blue: 0.787740171, alpha: 1)
        let floatingLabelColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        // Email
        emailTextField.keyboardType = .emailAddress
        emailTextField.label.text = "Email"
        emailTextField.placeholder = "Email"
        emailTextField.setOutlineColor(normalBorderColor, for: .normal)
        emailTextField.setOutlineColor(normalBorderColor, for: .editing)
        emailTextField.setFloatingLabelColor(floatingLabelColor, for: .editing)
        emailTextField.setNormalLabelColor(normalBorderColor, for: .normal)
        emailTextField.leadingAssistiveLabel.text = ""
        
        // Password
        passwordTextField.setOutlineColor(normalBorderColor, for: .normal)
        passwordTextField.setOutlineColor(normalBorderColor, for: .editing)
        passwordTextField.setFloatingLabelColor(floatingLabelColor, for: .editing)
        passwordTextField.setNormalLabelColor(normalBorderColor, for: .normal)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.label.text = "Password"
        passwordTextField.placeholder = "Password"
        passwordTextField.leadingAssistiveLabel.text = ""
        
    }
    
    func createObservables() {
        emailTextField.rx.text.map({$0 ?? ""}).bind(to: viewModel.email).disposed(by: bag)
        passwordTextField.rx.text.map({$0 ?? ""}).bind(to: viewModel.password).disposed(by: bag)
        
        viewModel.isValidEmail.subscribe( onNext: { [weak self] isValid in
            
            self?.emailTextField.leadingAssistiveLabel.text = isValid ? "" : "Please enter valid email"
        }).disposed(by: bag)
        
        viewModel.isValidPassword.subscribe( onNext: { [weak self] isValid in
            
            self?.passwordTextField.leadingAssistiveLabel.text = isValid ? "" : "Password should have minimum 6 characters"
        }).disposed(by: bag)
        
        viewModel.isValidInput.bind(to: loginButton.rx.isEnabled).disposed(by: bag)
        viewModel.isValidInput.subscribe( onNext: { [weak self] isValid in
            let disabledColor = #colorLiteral(red: 0.787740171, green: 0.787740171, blue: 0.787740171, alpha: 1)
            let enabledColor = #colorLiteral(red: 0.2016438842, green: 0.399077177, blue: 0.6221905351, alpha: 1)
            self?.loginButton.backgroundColor = isValid ? enabledColor : disabledColor
        }).disposed(by: bag)
        
        viewModel.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: bag)
        
        viewModel.loginResult.observeOn(MainScheduler.instance)
            .subscribe { [weak self] response in
                
                guard (response != nil) else { return }
                guard let `self` = self else {
                    return
                }
                if (response?.errorMessage?.isEmpty ?? false) && response?.data?.user != nil {
                    self.delegate?.didLoginSuccess(info: response! )
                    self.dismiss(animated: true)
                } else {
                    self.showAlert(alertText: "Login failed!", alertMessage: response?.errorMessage ?? somethingWentWrong)
                }
                
            } onError: { error in
                self.showAlert(alertText: "Error", alertMessage: error.localizedDescription)
                debugPrint("Login error \(error)")
            }.disposed(by: bag)
        
        viewModel.errorMessage.subscribe( onNext: { [weak self] errorMessage in
            guard !errorMessage.isEmpty else { return }
            guard let `self` = self else {
                return
            }
            self.showAlert(alertText: "Login failed!", alertMessage: errorMessage )
            debugPrint("errorMessage \(errorMessage)")
        }).disposed(by: bag)
    }
    
}
// MARK: - Button actions

extension LoginViewController {
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        viewModel.performLogin()
    }
}
