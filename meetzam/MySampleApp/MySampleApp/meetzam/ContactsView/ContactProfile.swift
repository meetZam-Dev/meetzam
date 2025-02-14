//
//  ContactProfile.swift
//  MySampleApp
//
//  Created by 孟琦 on 4/14/17.
//
//

import UIKit
import AWSMobileHubHelper

class ContactProfile: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // background
        self.view.backgroundColor = UIColor.init(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        self.mainScrollView.backgroundColor = UIColor.clear
        self.mainView.backgroundColor = UIColor.clear
        
        //profile picture
        self.mainView.addSubview(userPicField)
        
        // user name
        displayName.frame = CGRect(x: 20, y: userPicField.frame.height + 5, width: UIScreen.main.bounds.width, height: 30)
        displayName.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        self.mainView.addSubview(displayName)
        
        // user bio
        userBioField.frame = CGRect(x: 20, y: userPicField.frame.height + 35, width: UIScreen.main.bounds.width, height: 20)
        userBioField.font = UIFont(name: "HelveticaNeue-Thin", size: 15)
        userBioField.textColor = UIColor.gray
        self.mainView.addSubview(userBioField)
        
        // also liked
        alsoLiked.text = "Liked"
        alsoLiked.frame = CGRect(x: 20, y: userPicField.frame.height + 70, width: UIScreen.main.bounds.width, height: 20)
        alsoLiked.font = UIFont(name: "HelveticaNeue-Thin", size: 18)
        alsoLiked.textColor = UIColor.darkGray
        self.mainView.addSubview(alsoLiked)
        
        
        // liked movie backgroundLabel
        backgroundLabel.frame = CGRect(x: 0, y: UIScreen.main.bounds.width + 100, width: UIScreen.main.bounds.width, height: 140)
        backgroundLabel.text = ""
        backgroundLabel.backgroundColor = UIColor.init(red: 173/255, green: 173/255, blue: 173/255, alpha: 1)
        self.mainView.addSubview(backgroundLabel)
        
        
        // movies
        moviePic1.frame = CGRect(x: 0, y: UIScreen.main.bounds.width + 100, width: (UIScreen.main.bounds.width-30)/4, height: 140)
        moviePic2.contentMode = .scaleToFill
        
        moviePic2.frame = CGRect(x: moviePic1.frame.width, y: UIScreen.main.bounds.width + 100, width: (UIScreen.main.bounds.width)/4, height: 140)
        
        moviePic3.frame = CGRect(x: moviePic1.frame.width*2, y: UIScreen.main.bounds.width + 100, width: (UIScreen.main.bounds.width)/4, height: 140)
        
        moviePic4.frame = CGRect(x: moviePic1.frame.width*4-10, y: UIScreen.main.bounds.width + 150, width: 30, height: 50)
        moviePic4.contentMode = UIViewContentMode.scaleAspectFit
        moviePic4.image = #imageLiteral(resourceName: "Dot")
        moviePic4.alpha = 0.8
        
        self.mainView.addSubview(moviePic1)
        self.mainView.addSubview(moviePic2)
        self.mainView.addSubview(moviePic3)
        self.mainView.addSubview(moviePic4)
        
        // Go Chat button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(moreButtonAction))
//            UIBarButtonItem(title: "Chat", style: .plain, target: self, action: #selector(goChat))

    }
    
    // report button
    @IBAction func reportButton(_ sender: Any) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // profile click + sign action
    func moreButtonAction() {
        let popUpMenu = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        let chatAction = UIAlertAction.init(title: "Go Chat", style: .default, handler: goChat)
        let reportAction = UIAlertAction.init(title: "Report", style: .default, handler: goReport)
        
        popUpMenu.addAction(chatAction)
        popUpMenu.addAction(reportAction)
        popUpMenu.addAction(cancelAction)
        
        self.present(popUpMenu, animated: true, completion: nil)
    }
    
    func goChat(alert: UIAlertAction!) {
        // first exit navigation view controller
        let queue = DispatchQueue.init(label: "com.meetzam.goChat")
        
        queue.sync {
            self.navigationController?.popViewController(animated: false)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                let mainVC = UIApplication.shared.keyWindow?.rootViewController
                if mainVC is MainViewController {
                    let navVC = (mainVC as! MainViewController).viewControllers?[3]
                    if navVC is NaviViewController {
                        let chatVC = (navVC as! NaviViewController).topViewController
                        if chatVC is ChatViewController {
                            if let name = self.displayName.text {
                                print("Going to Chat \(name)")
                                (chatVC as! ChatViewController).didSelectContactNameFromContact = name
                                (mainVC as! MainViewController).selectedIndex = 3
                            }
                        }
                    }
                }
            })
        }
    }
    
    func goReport(alert: UIAlertAction!) {
        print("Clicked Report")
        API().reportUser(userId: AWSIdentityManager.default().identityId!)
    }
    
    
    var userPicField = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
    
    let displayName = UILabel()
    
    let userBioField = UILabel()
    
    let alsoLiked = UILabel()
    
    let backgroundLabel = UILabel()
    
    var moviePic1 = UIImageView()
    
    var moviePic2 = UIImageView()
    
    var moviePic3 = UIImageView()
    
    var moviePic4 = UIImageView()
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
}
