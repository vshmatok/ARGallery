//
//  SignUpViewController.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 11/7/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, Alertable, Loadable {

    // MARK: - IBOutlets

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var signupButton: UIButton!

    // MARK: - Properties

    private let firebaseManager = FirebaseManager()

    // MARK: - IBOutlet

    @IBAction private func didTappedSignUpButton(_ sender: UIButton) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            email.hasValidEmail(),
            password.hasValidPassword() else {
                showErrorWith(status: "Credentials not valid")
                return
        }
        showLoader()
        firebaseManager.createUser(withEmail: email, password: password) { [weak self] (result) in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case .success:
                self.navigationController?.popViewController(animated: true)
            case let .failure(error):
                print(error.localizedDescription)
                self.showErrorWith(status: "Failed to register")
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
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
