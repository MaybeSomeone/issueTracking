//
//  AppConfig.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/2/22.
//

import UIKit

func DebugPrint<T>(_ message: T,
                    file: String = #file,
                    method: String = #function,
                    line: Int = #line) {
    #if DEBUG
    print("[\((file as NSString).lastPathComponent)]---[\(line)]---\(method)--- \(message)")
    #endif
}

//MARK:UIColor----共用颜色设置
extension UIColor {
    
    /// 浅黑背景
    static let mLightBlack: UIColor = UIColor(hex: "#292929")
    
    /// 深黑背景
    static let mDeepBlack: UIColor = UIColor(hex: "#111111")
    
    /// 白字体颜色
    static let textColor: UIColor = UIColor(hex: "#E8E8E8")
    
    /// 未选中颜色
    static let textNormalColor: UIColor = UIColor(hex: "#808080")
    
    /// 未选中title颜色
    static let textTitleNormalColor: UIColor = UIColor(hex: "#B3B3B3")
    
    /// 灰色字体颜色
    static let textGrayColor: UIColor = UIColor(hex: "#6B7280")
  
    /// 主题颜色
    static let mainColor: UIColor = UIColor.rgba(255.0, G: 91.0, B: 139.0, A: 1.0)
    
    /// 主题颜色
    static let alphaMainColor: UIColor = UIColor.rgba(255.0, G: 91.0, B: 139.0, A: 0.5)
    
    /// tabbar颜色
    static let tabbarColor: UIColor = UIColor(hex: "#007CC2")

    /// navbar颜色
    static let navbarColor: UIColor = UIColor(hex: "#007CC2")
    
    /// 首页背景颜色
    static let homeBackColor: UIColor = UIColor(hex: "#12161E")
    
    ///遮罩背景颜色
    static let shadeViewColor: UIColor = UIColor(hex: "#000000")

    ///取消按钮颜色
    static let cancelbtnColor: UIColor = UIColor(hex: "#191919")
    
    ///分割线颜色
    static let lineColor: UIColor = UIColor(hex: "#EAEAEA")

    /// 黑色网格
    static var black_grid: UIColor? {
        guard let image = UIImage(named: "black_ grid") else { return nil }
        return UIColor(patternImage: image)
    }
}


//MARK:UIFont----共用字体设置
extension UIFont {
    /// 防止获取Font失败，给出默认字体
    private static func font(name: String, size: CGFloat) -> UIFont {
        return UIFont.init(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    ///
    /// tabBar签栏标题字体
    static let font_tabBarItem: UIFont                      = font(name: "PingFangSC-Bold", size: 18.0)
    /// 全局导航栏标题字体
    static let font_navigationTitle: UIFont                 = font(name: "PingFangSC-Medium",size: 16.0)
    ///通用8号字体
    static let font_commonSmallTitle: UIFont                 = font(name: "PingFangSC-Bold",size: 8.0)
    ///通用10号字体
    static let font_commonBoldTitle: UIFont                 = font(name: "PingFangSC-Bold",size: 10.0)
    ///通用10号字体主要用于silder前缀说明，按钮拼接小字体
    static let font_commonNormalTitle: UIFont               = font(name: "PingFangSC-Regular",size: 10.0)
    ///通用cell标题12号字体
    static let font_commonCellTitle: UIFont                 = font(name: "PingFangSC-Regular",size: 12.0)
    ///通用cell标题未选中细体12号字体
    static let font_commonLightCellTitle: UIFont             = font(name: "PingFangSC-Light",size: 12.0)
    ///通用View标题14号字体
    static let font_commonViewTitle: UIFont                 = font(name: "PingFangSC-Regular",size: 14.0)
    ///通用View标题18号字体
    static let font_commonBig18Title: UIFont                = font(name: "PingFangSC-Medium",size: 18.0)

}


//MARK:适配刘海屏参数
class AppConfig {
    /// 底部安全距离
    static func mWindowSafebottom() -> CGFloat {
        return mWindow()?.safeAreaInsets.bottom ?? 0
    }
    
    /// 顶部安全距离
    static func mWindowSafetop() -> CGFloat {
        return mWindow()?.safeAreaInsets.top ?? 0
    }
    
    /// 获取window
    static func mWindow() -> UIWindow? {
        guard let appdelegate = UIApplication.shared.delegate,
              let aWindow = appdelegate.window else {
            return nil
        }
        return aWindow
    }
    
    /// 判断是否是iPhoneX刘海屏系列
    static func isIphoneXSeries() -> Bool {
        if UIDevice.current.userInterfaceIdiom != .phone {
            return false
        }
        if #available(iOS 11.0, *) {
            if (self.mWindow()?.safeAreaInsets.bottom ?? 0 ) > 0.0 {
                return true
            }
        }
        return false
    }
}


//MARK:CGFloat----适配屏幕参数
extension CGFloat {
    
    static let screenWidth = UIScreen.main.bounds.width
    
    static let screenHeight = UIScreen.main.bounds.height
    
    /// 获取statusBar高度
    static func statusBarHeight() -> CGFloat {
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let barH =  window?.windowScene?.statusBarManager?.statusBarFrame.height
//        let barH = UIApplication.shared.statusBarFrame.size.height
        if barH == 0 {
            if AppConfig.isIphoneXSeries() == true {
                return 44.0
            }else {
                return 20 //20.0
            }
        }
        return barH!
    }
    
    /// 导航栏高度
    static func naviHeight() -> CGFloat {
        var height: CGFloat = 64
        if AppConfig.isIphoneXSeries() == true {
            height = 88
        }
        return height
    }
    
    /// 获取bottomBar高度 34 或者0
    static func bottomBarHeight() -> CGFloat {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let barH =  window?.windowScene?.statusBarManager?.statusBarFrame.height
        if barH == 0 {
            if AppConfig.isIphoneXSeries() == true {
                return 34
            }else {
                return 0 //20.0
            }
        }
        return barH!
    }
    
    /// 获取bottom高度 49 或者83
    static func bottomHeight() -> CGFloat {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let barH =  window?.windowScene?.statusBarManager?.statusBarFrame.height
        if barH == 0 {
            if AppConfig.isIphoneXSeries() == true {
                return 34.0 + 49
            }else {
                return 49 //20.0
            }
        }
        return barH!
    }
}
