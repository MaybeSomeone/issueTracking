//
//  NSObject+Extension.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/2/22.
//

import Foundation
import UIKit
import AVFoundation


extension NSObject {
    
    /// 获取当前视图控制器
    /// - Returns: 返回视图
    func currentViewController() -> (UIViewController?) {
       var window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
       if window?.windowLevel != UIWindow.Level.normal{
         let windows = UIApplication.shared.windows
         for  windowTemp in windows{
           if windowTemp.windowLevel == UIWindow.Level.normal{
              window = windowTemp
              break
            }
          }
        }
       let vc = window?.rootViewController
       return currentViewController(vc)
    }


    func currentViewController(_ vc :UIViewController?) -> UIViewController? {
       if vc == nil {
          return nil
       }
       if let presentVC = vc?.presentedViewController {
          return currentViewController(presentVC)
       }
       else if let tabVC = vc as? UITabBarController {
          if let selectVC = tabVC.selectedViewController {
              return currentViewController(selectVC)
           }
           return nil
        }
        else if let naiVC = vc as? UINavigationController {
           return currentViewController(naiVC.visibleViewController)
        }
        else {
           return vc
        }
     }

    /// 弹框展示标题、副标题、确认按钮、取消按钮、确认回调、取消回调
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 副标题
    ///   - sureTit: 确认按钮文字
    ///   - cancelTit: 取消按钮文字
    ///   - sureBlock: 确认回调
    ///   - cancelBlock: 取消回调
    func showAlter(title:String,message:String,sureTit:String,cancelTit:String,sureBlock: (() -> Void)?,cancelBlock:  (() -> Void)?)  {
        UIAlertController.showAlter(title: title, message: message, sureTit: sureTit, cancelTit: cancelTit, fromVC: currentViewController()!, sureBlock: sureBlock, cancelBlock: cancelBlock)
    }
    
    /// 弹框展示标题、副标题、确认按钮、确认回调
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 副标题
    ///   - sureTit: 确认按钮文字
    ///   - sureBlock: 确认回调
    ///   - fromVC: 控制器
    func showAlter(title:String,message:String,sureTit:String,sureBlock: (() -> Void)?)  {
        UIAlertController.showAlter(title: title, message: message, sureTit: sureTit, fromVC: currentViewController()!, sureBlock: sureBlock)
    }
}




extension UIAlertController{
    
    /// 弹框展示标题、副标题、确认按钮、取消按钮、确认回调、取消回调
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 副标题
    ///   - sureTit: 确认按钮文字
    ///   - cancelTit: 取消按钮文字
    ///   - sureBlock: 确认回调
    ///   - cancelBlock: 取消回调
    ///   - fromVC: 控制器
    static func showAlter(title:String,message:String,sureTit:String,cancelTit:String,fromVC:UIViewController,sureBlock: (() -> Void)?,cancelBlock:  (() -> Void)?)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let btnOK = UIAlertAction(title: sureTit, style: .default, handler: { action in
            DispatchQueue.main.async {
                sureBlock?()
            }
        })
        let btnCancel = UIAlertAction(title: cancelTit, style: .cancel, handler: { action in
            
            DispatchQueue.main.async {
                cancelBlock?()
            }
        })
        alert.addAction(btnOK)
        alert.addAction(btnCancel)
        fromVC.present(alert, animated: true, completion: nil)
    }
    
    
    /// 弹框展示标题、副标题、确认按钮、确认回调
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 副标题
    ///   - sureTit: 确认按钮文字
    ///   - sureBlock: 确认回调
    ///   - fromVC: 控制器
    static func showAlter(title:String,message:String,sureTit:String,fromVC:UIViewController,sureBlock: (() -> Void)?)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let btnOK = UIAlertAction(title: sureTit, style: .default, handler: { action in
            DispatchQueue.main.async {
                sureBlock?()
            }
        })
        alert.addAction(btnOK)
        fromVC.present(alert, animated: true, completion: nil)
    }
    
}
