//
//  BaseTabBarController.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/2/22.
//

import UIKit

class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupChildViewControllers()
        setupTabBar()
        
    
    }
    
    private func setupTabBar() {
        tabBar.isTranslucent = false
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        
//        tabBar.backgroundColor = .init(hex: "#F0F0F0").withAlphaComponent(0.2)
//        tabBar.barTintColor = .init(hex: "#F0F0F0").withAlphaComponent(0.2)
        tabBar.backgroundColor = .init(hex: "#F0F0F0")
        tabBar.barTintColor = .init(hex: "#F0F0F0")
        tabBar.tintColor = .tabbarColor
        
    }
    /// 设置子控制器
    private func setupChildViewControllers() {
        addChildViewController(IssueHomeViewController(), title: "Issue traking", imageName: "ic_issue")
        addChildViewController(FeedbackViewController(), title: "Feedback", imageName: "ic_feedback")
        addChildViewController(InfoViewController(), title: "Info", imageName: "ic_setting")
    }
    
    /// 添加子控制器
    private func addChildViewController(_ childViewController: UIViewController, title: String, imageName: String) {
        childViewController.title = title
        childViewController.tabBarItem.image = UIImage(named: imageName)
        let navigationController = BaseNaviController(rootViewController: childViewController)
        addChild(navigationController)
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
