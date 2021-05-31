//
//  ProfileViewController.swift
//  Movien
//
//  Created by Асыланбек Нурмухамбет on 5/30/21.
//  Copyright © 2021 kbtu.edu.as1k.kz. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
    
    let client = Service()
    var cancelRequest: Bool = false
    var user: User? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cancelRequest = false
        
        if NetworkCheck.isConnectedToNetwork() {
            print("You have internet connection!".localized())
        } else {
            print("No internet connection!".localized())
            connectionAlert()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserInfo()
    }
    
    
    private func loadUserInfo() {
        Service.fetchUser() { (user) in
            guard let user = user else { return }
            self.user = user
            DispatchQueue.main.async {
                self.fullName.text = user.name
                self.userName.text = user.username
            }
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
}
