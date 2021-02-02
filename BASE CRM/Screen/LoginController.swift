//
//  ViewController.swift
//  BaseDemo
//
//  Created by BASEBS on 8/5/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit
import Alamofire
import SkyFloatingLabelTextField
//import RealmSwift

protocol LoginControllerOutput {
    func fetchAuthentication(username: String, password: String)
}

class LoginController: BaseViewController {
    @IBOutlet weak var tfUserName: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tfPassword: SkyFloatingLabelTextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var btnCheckbox: UIButton!
    
    ///  MARK: - Output
    var output: LoginControllerOutput?

    var isCheck: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Clean
//        LoginConfiguration.shared.configure(viewController: self)
        
        // Init
        self.initBaseAbility()
    }
    
    override func setupView() {
        tfUserName.placeholder = "User name"
        tfUserName.title = "User name"
        tfUserName.delegate = self
        tfPassword.placeholder = "Password"
        tfPassword.title = "Password"
        tfPassword.isSecureTextEntry = true
        tfPassword.delegate = self
        
        btnLogin.layer.cornerRadius = 8
        
        let tapRecognization = UITapGestureRecognizer(target: self, action: #selector(self.tapDismiss(gesture:)))
        self.view.addGestureRecognizer(tapRecognization)
    }
    
    @objc func tapDismiss(gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    @IBAction func loginAction(_ sender : AnyObject) {
        //Interaction layer
        self.view.endEditing(true)
        self.showLoading()
//        Networking.shared.fetchLogin(with: tfUserName.text!, password: tfPassword.text!, completion: (Bool) -> ())
//        self.output?.fetchAuthentication(username: tfUserName.text!, password: tfPassword.text!)
        Networking.shared.fetchLogin(with: tfUserName.text!, password: tfPassword.text!) { (isDone) in
            self.hideLoading()
            if isDone {
                RouterManager.shared.handleRouter(MainRoute())
            } else {
                self.showAlert(title: "ERROR!", message: "Please try again!")
            }
        }
    }
    
    @IBAction func actionCheck() {
        isCheck = !isCheck
        
        if (isCheck) {
            btnCheckbox.setImage(UIImage(named: "checked_box"), for: .normal)
        } else {
            btnCheckbox.setImage(UIImage(named: "check_box"), for: .normal)
        }
        
    }
}

//extension LoginController: LoginPresenterOutput {
//    func pushView() {
//        self.hideLoading()
//
////        Networking.shared.getOwnerInfo { [weak self] in
//            onTransition()
////        }
//    }
//
//    private func onTransition() {
//        RouterManager.shared.handleRouter(MainRoute())
//    }
//
//    func presentError(_ error: Error) {
//        self.hideLoading()
//        DispatchQueue.main.asyncAfter(deadline: .now() + delayTime) {
//            self.showAlert(title: AlertType.error.rawValue, message: error.localizedDescription)
//        }
//    }
//}

extension LoginController: XibInitalization {
    typealias Element = LoginController
}

extension LoginController: UITextFieldDelegate {}

extension LoginController {}
