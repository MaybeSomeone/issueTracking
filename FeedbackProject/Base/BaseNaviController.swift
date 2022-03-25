//
//  BaseNaviController.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/2/22.
//

import UIKit

class BaseNaviController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isTranslucent = false
        navigationBar.shadowImage = UIImage()
        interactivePopGestureRecognizer?.delegate = self
        navigationBar.barStyle = .default
        navigationBar.barTintColor = .white
        
        
        if #available(iOS 15.0, *){
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.navbarColor
            appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
            
        }  else{
            navigationBar.backgroundColor = .navbarColor
            navigationBar.isTranslucent = false
            let dict:NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]
            navigationBar.titleTextAttributes = dict as? [NSAttributedString.Key : Any]
        }
        
        // Do any additional setup after loading the view.
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


extension BaseNaviController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
    
}
