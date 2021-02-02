//
//  SplashViewController.swift
//  BaseDemo
//
//  Created by BASEBS on 8/5/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit

class SplashViewController: BaseViewController {

    @IBOutlet weak var lblSlogan : UILabel!
    @IBOutlet weak var iv: UIImageView!
    @IBOutlet weak var lblWelcome : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        lblSlogan.addCharacterSpacing(kernValue: 4)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func initData() {
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.scrollDirection = .horizontal
//        let vc = GuideController(collectionViewLayout: flowLayout)
//        if let w = UIApplication.shared.delegate?.window {
//            w?.rootViewController = vc
//        }
        
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in

        Networking.shared.checkToken { (data, error) in
            if error != nil {
                RouterManager.shared.handleRouter(LoginRoute())
            } else {
                RouterManager.shared.handleRouter(MainRoute())
            }
        }
//        }
    }
    
    func animation(view: UIView) {
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "bounds")
        keyFrameAnimation.duration = 1
        keyFrameAnimation.timingFunctions = [CAMediaTimingFunction(name: .linear), CAMediaTimingFunction(name: .easeInEaseOut)]
        let initalBounds = NSValue(cgRect: view.bounds)
        let secondBounds = NSValue(cgRect: CGRect(x: 0, y: 0, width: view.frame.size.width/2, height: view.frame.size.height/2))
        let finalBounds = NSValue(cgRect: CGRect(x: 0, y: 0, width: view.frame.size.width*2 , height: view.frame.size.height*2))
        keyFrameAnimation.values = [initalBounds, secondBounds, finalBounds]
        keyFrameAnimation.keyTimes = [0, 1, 2]
        
        view.layer.add(keyFrameAnimation, forKey: "bounds")
    }
    
    func flipAnimation(view: UIView) {
        let label = view
        
        UIView.transition(with: label, duration: 2.0, options: [.transitionFlipFromLeft], animations: {
//            label.textColor = .black
        }) { (done) in
            print(done)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension SplashViewController : XibInitalization {
    typealias Element = SplashViewController
}
