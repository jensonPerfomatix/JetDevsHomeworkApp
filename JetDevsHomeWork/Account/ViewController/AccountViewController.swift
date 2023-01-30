//
//  AccountViewController.swift
//  JetDevsHomeWork
//
//  Created by Gary.yao on 2021/10/29.
//

import UIKit
import Kingfisher

class AccountViewController: UIViewController {

	@IBOutlet weak var nonLoginView: UIView!
	@IBOutlet weak var loginView: UIView!
	@IBOutlet weak var daysLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var headImageView: UIImageView!
	override func viewDidLoad() {
        super.viewDidLoad()

		self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
		nonLoginView.isHidden = false
		loginView.isHidden = true
    }
	
	@IBAction func loginButtonTap(_ sender: UIButton) {
        let loginVC = LoginViewController()
        loginVC.delegate = self
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true)
	}
	
}

extension AccountViewController: LoginViewControllerDelegate {
    
    func didLoginSuccess(info: LoginResponse) {
        guard let userInfo = info.data?.user else {
            return
        }
        
        // Save locally
        let data = Data(from: userInfo)
        let status = KeychainManager.save(key: "UserInfo", data: data)
        print("Saved user info locally status: \(status)")
        
        nonLoginView.isHidden = true
        loginView.isHidden = false
        headImageView.image = nil
        headImageView.kf.indicatorType = .activity
        if let userImage = userInfo.userProfileURL {
            if let url = URL(string: userImage) {
                headImageView.kf.setImage(with: url)
            }
        }
        if headImageView.image == nil {
            headImageView.image = #imageLiteral(resourceName: "Avatar")
        }
        nameLabel.text = (userInfo.userName ?? notAvailable)
        let numberOfDays = userInfo.createDayAgo
        var message = "Created \(numberOfDays) day ago"
        if numberOfDays > 1 {
            message = "Created \(numberOfDays) days ago"
        }
        daysLabel.text = message
        
    }
    
}
