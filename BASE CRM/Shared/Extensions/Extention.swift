//
//  Extention.swift
//  BaseDemo
//
//  Created by BASEBS on 8/20/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Foundation
import UIKit

// MARK: UIApplication extensions

extension UIApplication {

    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

extension UIViewController {
    
    func add(_ child: UIViewController, contentView: UIView) {
//        addChild(child)
        contentView.addSubview(child.view)
        child.view.frame = contentView.bounds
        child.didMove(toParent: self)
    }
    
    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
//        removeFromParent()
    }

    func onLoading() {
//        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
//        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 100, height: 100))
//        loadingIndicator.hidesWhenStopped = true
//        loadingIndicator.style = .gray //UIActivityIndicatorView.Style.gray
//        loadingIndicator.startAnimating()
//
//        alert.view.addSubview(loadingIndicator)
//        present(alert, animated: true, completion: nil)
        
        
    }
    
    func onDismissLoading() {
//        let controller = UIApplication.getTopViewController()
//        print("dragon")
//        print(controller?.nibName)
//        
//        controller?.dismiss(animated: true, completion: nil)
    }
    
    func didPopView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAlert(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    func showError(title: String, message: String?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        if message == NSError.sessionExpired().localizedDescription {
            let actionExpired = UIAlertAction(title: "OK", style: .default) { (action) in
                RouterManager.shared.handleRouter(LoginRoute())
                RealmManager.shared.reset()
            }
            
            alertController.addAction(actionExpired)
        } else {
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(action)
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    func onPromtPopUp(message: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                alert.dismiss(animated: true) {
                    completion()
                }
            }
        }
    }
}

extension UIView {
    func addConstraint(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat, superView: UIView) {
        leftAnchor.constraint(equalTo: superView.leftAnchor, constant: leading).isActive = true
        topAnchor.constraint(equalTo: superView.topAnchor, constant: top).isActive = true
        rightAnchor.constraint(equalTo: superView.rightAnchor, constant: trailing).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: bottom).isActive = true
    }
    
    func addTapDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onDismiss(_ :)))
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func onDismiss(_ gestureRecognizer: UIGestureRecognizer) {
        self.endEditing(true)
    }
    
    var loadingView: UIView {
        //TODO
        let vLoading = UIView(frame: CGRect(origin: .zero, size: CGSize(width: widthScreen, height: heightScreen)))
        let indicator = UIActivityIndicatorView(style: .gray)
        
        vLoading.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        //        indicator.center = vLoading.center
        let widthSize: CGFloat = 50.0
        
        indicator.frame = CGRect(origin: CGPoint(x: (widthScreen - widthSize)/2, y: (heightScreen - widthSize)/2), size: CGSize(width: widthSize, height: widthSize))
        //        indicator.frame.size = CGSize(width: 50, height: 50)
        indicator.startAnimating()
        vLoading.addSubview(indicator)
        
        return vLoading
    }
}

extension UIButton {
    func centerButtonAndImageWithSpacing(spacing : CGFloat) {
        let insetAmount = spacing/2.0
        
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right:  -insetAmount)
    }
}

extension UIColor {
    convenience init?(hex : String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat((hexNumber & 0x0000ff)) / 255
                    a = 1.0
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
    
    convenience init?(red: CGFloat, green: CGFloat, blue: CGFloat) {
        let r,g,b : CGFloat
        
        r = red/255
        g = green/255
        b = blue/255
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}

extension UILabel {
  func addCharacterSpacing(kernValue: Double = 1.15) {
    if let labelText = text, labelText.count > 0 {
      let attributedString = NSMutableAttributedString(string: labelText)
      attributedString.addAttribute(.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
      attributedText = attributedString
    }
  }
}

extension URLRequest {
//
//    /**
//     Configures the URL request for `multipart/form-data`. The request's `httpBody` is set, and a value is set for the HTTP header field `Content-Type`.
//
//     - Parameter parameters: The form data to set.
//     - Parameter encoding: The encoding to use for the keys and values.
//
//     - Throws: `MultipartFormDataEncodingError` if any keys or values in `parameters` are not entirely in `encoding`.
//
//     - Note: The default `httpMethod` is `GET`, and `GET` requests do not typically have a response body. Remember to set the `httpMethod` to e.g. `POST` before sending the request.
//     - Seealso: https://html.spec.whatwg.org/multipage/form-control-infrastructure.html#multipart-form-data
//     */
    public mutating func setMultipartFormData(_ parameters: [String: String], encoding: String.Encoding) throws {
        Logger.info(parameters)
        let makeRandom = { UInt32.random(in: (.min)...(.max)) }
        let boundary = String(format: "------------------------%08X%08X", makeRandom(), makeRandom())

        let contentType: String = try {
            guard let charset = CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(encoding.rawValue)) else {
                throw MultipartFormDataEncodingError.characterSetName
            }
            return "multipart/form-data; charset=\(charset); boundary=\(boundary)"
        }()
        addValue(contentType, forHTTPHeaderField: "Content-Type")

        httpBody = try {
            var body = Data()

            for (rawName, rawValue) in parameters {
                print("setMultipartFormData")
                print(rawName)
                print(rawValue)
                if !body.isEmpty {
                    body.append("\r\n".data(using: .utf8)!)
                }

                body.append("--\(boundary)\r\n".data(using: .utf8)!)

                guard
                    rawName.canBeConverted(to: encoding),
                    let disposition = "Content-Disposition: form-data; name=\"\(rawName)\"\r\n".data(using: encoding) else {
                    throw MultipartFormDataEncodingError.name(rawName)
                }
                body.append(disposition)

                body.append("\r\n".data(using: .utf8)!)

                guard let value = rawValue.data(using: encoding) else {
                    throw MultipartFormDataEncodingError.value(rawValue, name: rawName)
                }

                body.append(value)
            }

            body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

            return body
        }()
    }
}

extension UIViewController {
//    var transition: BASEAnimator {
//        return BASEAnimator()
//    }
////    let transition = BASEAnimation()
//
//    func onComplete(info dictObject: Dictionary<String, String>) {
//        //FIXME
//        let vSuccess = Bundle.main.loadNibNamed("PopupView", owner: self, options: nil)?[1] as! PopUpSuccessful
//
//        self.view.addSubview(vSuccess)
//        vSuccess.frame = self.view.bounds
//
////        UIView.animate(withDuration: delayTime, delay: 0.0, options: .allowAnimatedContent, animations: {
////            self.view.layoutIfNeeded()
////        }) { (_) in
////        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + delayTime) {
//            vSuccess.removeFromSuperview()
//            self.didPopView()
//        }
//    }

//    func onAddNew() {
//        //FIXME
//        let vc = UIViewController()
//        let presenter = PresenterView.xibInstance()
//        presenter.vTitle.lblTitle.text = "Edit note"
//
//        let creatNote = CreatNewNote.xibInstance()
//        creatNote.hideSave()
//        creatNote.hideBack()
//        creatNote.vTitleView.isHidden = true
//        creatNote.frame = CGRect(x: sectionInsetsDefault.left, y: CGPoint.zero.y, width: presenter.vContent.bounds.width - sectionInsetsDefault.left*2, height: presenter.vContent.bounds.height)
//
//        vc.view.addSubview(presenter)
//        presenter.frame = vc.view.bounds
//
//        presenter.onChangeAction(type: .save)
//        presenter.vContent.addSubview(creatNote)
//
//        presenter.controller = self
//        presenter.delegate = vc
//        onPushController(vc)
//    }

//    func generateView(subView: UIView, title: String?, actionType: PresenterActionType, controller: UIViewController = UIViewController()) {
////        let vc = UIViewController()
//        let presenter = PresenterView.xibInstance()
//        presenter.vTitle.lblTitle.text = title
//
//        subView.frame = presenter.vContent.bounds
//
//        controller.view.addSubview(presenter)
//        presenter.frame = controller.view.bounds
//
//        presenter.onChangeAction(type: actionType)
//        presenter.vContent.addSubview(subView)
//
//        presenter.controller = self
//        presenter.delegate = controller
//        controller.transitioningDelegate = self
//
//        onPushController(controller)
//    }

    func addNewAccount() {
//        let route = AccountDetailRoute()
//        RouterManager.shared.handleRouter(route)
//
//        route.handleData { (vc) in
//            vc.viewType = .account_new
//        }
    }

    func addNewContact() {
//        let route = ContactDetailRoute()
//        RouterManager.shared.handleRouter(route)
//
//        route.handleData { (vc) in
//            vc.viewType = .contact_new
//        }
    }

//    func addNewObject() {
//        print("New Object")
//        let newObjectController = ObjectNewController()
////        self.navigationController?.pushViewController(detailController, animated: true)
//        newObjectController.viewType = .object_new
//        generateView(subView: UIView(), title: "Creat New", actionType: .save, controller: newObjectController)
//    }

    public func onPushController(_ controller: UIViewController) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delayTime) {

            self.navigationController?.pushViewController(controller, animated: true)
//            self.present(controller, animated: true, completion: nil)
        }
    }
}

//extension UIViewController: UIViewControllerTransitioningDelegate {
//    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return transition
//    }
//    
//    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return nil
//    }
//}
