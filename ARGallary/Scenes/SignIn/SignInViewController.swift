//
//  SignInViewController.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 11/7/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, Alertable, Loadable {

    // MARK: - IBOutlet

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var signInButton: UIButton!

    // MARK: - Properties

    private var firebaseManager: FirebaseManager?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseManager = FirebaseManager()
    }

    // MARK: - IBAction

    @IBAction private func didTappedSignInButton(_ sender: UIButton) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            email.hasValidEmail(),
            password.hasValidPassword() else {
                showErrorWith(status: "Credentials not valid or empty")
                return
        }
        showLoader()
        firebaseManager?.login(withEmail: email, password: password) { [weak self] (result) in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case .success:
                UserDefaultsUtils.setValueForKey(.isAuthorized, true)
                ApplicationRouter.preparationScreen.change()
            case let .failure(error):
                print(error.localizedDescription)
                self.showErrorWith(status: "Wrong email or password")
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            passwordTextField.becomeFirstResponder()
        case 1:
            passwordTextField.resignFirstResponder()
        default:
            break
        }

        return true
    }
}
