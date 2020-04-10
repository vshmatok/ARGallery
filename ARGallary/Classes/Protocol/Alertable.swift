//
//  Alertable.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/21/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import UIKit

protocol Alertable: AnyObject {
    func showAlert(model: AlertModel)
    func showInputAlert(model: InputAlertModel)
}

extension Alertable where Self: UIViewController {
    func showAlert(model: AlertModel) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: model.style)

            model.actions.forEach({
                let action = UIAlertAction(title: $0.title, style: $0.style, handler: $0.handler)
                alert.addAction(action)
            })

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)

            self?.present(alert, animated: true)
        }
    }

    func showInputAlert(model: InputAlertModel) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)

            alert.addTextField { textField in
                textField.placeholder = model.textFieldPlaceholder
            }

            let action = UIAlertAction(title: "OK", style: .default) { _ in
                let text = alert.textFields?.first?.text
                model.handler?(text)
            }
            alert.addAction(action)

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)

            self?.present(alert, animated: true)
        }
    }
}
