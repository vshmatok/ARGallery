//
//  Loadable.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/21/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import SVProgressHUD
import UIKit

protocol Loadable: AnyObject {
    func showLoader(contentView: UIView?)
    func showWith(contentView: UIView?, status: String?)
    func showInfoWith(contentView: UIView?, status: String?)
    func showSuccessWith(contentView: UIView?, status: String?)
    func showErrorWith(contentView: UIView?, status: String?)
    func hideLoader(completion: (() -> Void)?)
}

extension Loadable where Self: UIViewController {
    // MARK: - Public

    func showLoader(contentView: UIView? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let contentView = contentView ?? self.getContainerView()
            SVProgressHUD.setContainerView(contentView)
            SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.show()
        }
    }

    func showWith(contentView: UIView? = nil, status: String?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let contentView = contentView ?? self.getContainerView()
            SVProgressHUD.setContainerView(contentView)
            SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.show(withStatus: status)
        }
    }

    func showInfoWith(contentView: UIView? = nil, status: String?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let contentView = contentView ?? self.getContainerView()
            SVProgressHUD.setContainerView(contentView)
            SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.showInfo(withStatus: status)
        }
    }

    func showSuccessWith(contentView: UIView? = nil, status: String? = "Success") {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let contentView = contentView ?? self.getContainerView()
            SVProgressHUD.setContainerView(contentView)
            SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.showSuccess(withStatus: status)
        }
    }

    func showErrorWith(contentView: UIView? = nil, status: String? = "Failure") {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let contentView = contentView ?? self.getContainerView()
            SVProgressHUD.setContainerView(contentView)
            SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.setMinimumDismissTimeInterval(0.1)
            SVProgressHUD.setMaximumDismissTimeInterval(2)
            SVProgressHUD.showError(withStatus: status)
        }
    }

    func hideLoader(completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss(completion: completion)
        }
    }

    // MARK: - Private

    private func getContainerView() -> UIView {
        let view: UIView
        if let viewForHud = UIApplication.shared.keyWindow {
            view = viewForHud
        } else if let viewForHud = navigationController?.view {
            view = viewForHud
        } else {
            view = self.view
        }
        return view
    }
}
