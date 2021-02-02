//
//  ProfileController.swift
//  BASE CRM
//
//  Created by khiemht on 2/3/21.
//  Copyright © 2021 HTK Technologies. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onLogout() {
        RealmManager.shared.reset()
        RouterManager.shared.handleRouter(LoginRoute())
    }

}
