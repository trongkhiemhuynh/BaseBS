//
//  CustomTabbar.swift
//  BaseDemo
//
//  Created by BASEBS on 8/19/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit
import CoreLocation

let BASEBS_HN = CLLocation(latitude: 21.0086301, longitude: 105.8376027)
let BASEBS_HCM = CLLocation(latitude: 10.7648, longitude: 106.7025)

//protocol AddressControllerOutput: class {
//    func changeLocation(_ location: CLLocation?)
//}

class AddressController: BaseViewController {
    
    @IBOutlet weak var vPager: BASEPager!
    @IBOutlet weak var vMap: MapView!
    
//    weak var delegate: AddressControllerOutput?
    let arrLocation = [BASEBS_HCM, BASEBS_HN]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationManager.shared.request()
        
        LocationManager.shared.clLocationNameHandler = {[weak self] (locationName) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                let alertController = UIAlertController(title: "My Location", message: locationName, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: ButtonView.ok.rawValue, style: .default, handler: nil))
                
                self?.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func setupView() {
//        vTitle.btnFilter.isHidden = true
//        vTitle.btnSearch.isHidden = true
//        vTitle.lblTitle.text = "Location"
        
        vPager.delegateAddSubView = self
        vPager.controller = self
        vPager.arrLocation = arrLocation
        vPager.delegate = self
        
        vMap.controller = self
        vMap.onUpdateLocation(arrLocation.first!)
        vPager.setupView()
    }
    
    @IBAction func onBack() {
        didPopView()
    }
}

extension AddressController: XibInitalization {
    typealias Element = AddressController
}

extension AddressController: BaseViewOutput {
    func didAddNew(type: String) {
        
    }
}

extension AddressController: BASEPagerOutput {
    func onChangedAt(index: Int) {
        vMap.onUpdateLocation(arrLocation[index])
    }
}
