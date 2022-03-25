//
//  UIColor+Extension.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/2/22.
//

import Foundation
import UIKit


infix operator >>> : BitwiseShiftPrecedence

public func >>> (lhs: Int64, rhs: Int64) -> Int64 {
    return Int64(bitPattern: UInt64(bitPattern: lhs) >> UInt64(rhs))
}

extension UIColor {
    
    ///16进制颜色
    convenience init(hex: String) {
        let scanner = Scanner(string: hex.replacingOccurrences(of: "#", with: ""))
//        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
    
    
    static func rgbSingle(_ s: CGFloat) -> UIColor {
        return rgb(s, G: s, B: s)
    }
    
    static func rgb(_ R: CGFloat, G: CGFloat, B: CGFloat) -> UIColor {
        return UIColor(red: R/255.0, green: G/255.0, blue: B/255.0, alpha: 1.0)
    }
    
    static func rgba(_ R: CGFloat, G: CGFloat, B: CGFloat, A: CGFloat) -> UIColor {
        return UIColor(red: R/255.0, green: G/255.0, blue: B/255.0, alpha: A)
    }
    
 
    /// 通过int值初始化颜色
    static func intColor(color: Int) -> UIColor {
        return UIColor(red: CGFloat(red(color))/255.0,
                       green: CGFloat(green(color))/255.0,
                       blue: CGFloat(blue(color))/255.0,
                       alpha: CGFloat(alpha(color))/255.0)
    }
    
    static func red(_ color: Int) -> Int {
        return (color >> 16) & 0xFF
    }
    
    static func green(_ color: Int) -> Int {
        return (color >> 8) & 0xFF
    }
 
    static func blue(_ color: Int) -> Int {
        return color & 0xFF
    }
    
    static func alpha(_ color: Int) -> Int {
        return Int(Int64(color) >>> 24)
    }
    
}



extension UIColor {
     
    
    //返回随机颜色
    open class var randomColor:UIColor{
         get
         {
             let red = CGFloat(arc4random()%256)/255.0
             let green = CGFloat(arc4random()%256)/255.0
             let blue = CGFloat(arc4random()%256)/255.0
             return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
         }
     }
    
    // Hex String -> UIColor
    convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
         
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
         
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
         
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
         
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
         
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
     
    // UIColor -> Hex String
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
         
        let multiplier = CGFloat(255.999999)
         
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
         
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
}
