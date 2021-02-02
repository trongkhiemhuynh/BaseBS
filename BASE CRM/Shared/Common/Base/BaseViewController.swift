//
//  BaseViewController.swift
//  BaseDemo
//
//  Created by BASEBS on 8/19/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit

protocol BaseControllerInput: class {
    func showAlertInfo(description: String)
}

class BaseViewController: UIViewController {

//    @IBOutlet weak var vTitle: CustomTitleView!
    @IBOutlet weak var vContent: UIView!
    
    //variable
    var isHiddenNavigationBar = true
    weak var controllerOwner: UIViewController?
    weak var delegateInput: BaseControllerInput?
    
    var viewType: MagicViewType!
    var titleLabel: String?
    
    lazy var vLoad: UIView = {
        let v = self.view.loadingView
        return v
    }()
    
//    public lazy var alertController: UIAlertController = {
//        return UIAlertController()
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = isHiddenNavigationBar
        
        setupView()
        initData()
        initCommon()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = isHiddenNavigationBar
    }

    func setupView() {}
    
    func initData() {}
    
    deinit {
        Logger.info("deinit")
    }
    
    lazy var vLoading: UIView = {
        let v = UIView()
        let activity = UIActivityIndicatorView()
        activity.style = .gray
        
        activity.startAnimating()
        
        v.addSubview(activity)
        v.backgroundColor = UIColor.init(white: 0.0, alpha: 0.2)
        
        v.frame = CGRect(origin: .zero, size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
        activity.frame = v.frame
        activity.center = v.center
        
        return v
    }()
    
    func showLoading() {
        self.view.addSubview(self.vLoading)
    }
    
    func hideLoading() {
        self.vLoading.removeFromSuperview()
    }
    
    @IBAction func onBackNavigation(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension BaseViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

extension BaseViewController : BaseAbility {
    func initCommon() {
        
    }
    
    func initUIs() {
        
    }
    
    func initBinding() {
        
    }
    
    func initActions() {
        
    }
}
