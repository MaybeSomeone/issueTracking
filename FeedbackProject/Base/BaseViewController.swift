//
//  BaseViewController.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/2/22.
//

import UIKit
import Foundation

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .init(hex: "#FCFCFC")
        extendedLayoutIncludesOpaqueBars = false

        setupNaviBackItem()
        // Do any additional setup after loading the view.
    }
    
    func setupNaviBackItem() {
        let vcNum = navigationController?.viewControllers.count
        if vcNum != 1 {
            let leftItem = UIBarButtonItem(image: UIImage(named: "navi_back"), style: .plain, target: self, action: #selector(backItemTapped))
            navigationItem.leftBarButtonItem = leftItem
        }else{
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 16))
            imageView.image = UIImage(named: "logo_infosys")
            let barButtonItem = UIBarButtonItem(customView: imageView)
            navigationItem.leftBarButtonItem = barButtonItem
        }
       
    }
    
    @objc func backItemTapped() {
        if (navigationController != nil) {
            if navigationController?.viewControllers.count ?? 0 > 1 {
                navigationController?.popViewController(animated: true)
            }else {
                navigationController?.dismiss(animated: true, completion: nil)
            }
        }else{
           dismiss(animated: true, completion: nil)
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
