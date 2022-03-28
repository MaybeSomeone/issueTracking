//
//  UIView+Extension.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/2/23.
//

import UIKit


extension UIView {
    /// 批量添加 view
    func addSubviews(_ views: Array<UIView>) {
        views.forEach {addSubview($0)}
    }
    
    
    func addCorner(conrners: UIRectCorner , radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: conrners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
}


enum RadiusType: Int {
    case radiusAll // 四边圆角
    
    case radiusTop // 上圆角
    case radiusLeft // 左圆角
    case radiusBottom // 下圆角
    case radiusRight // 右圆角
    
    case radiusTopleft // 上左角
    case radiusTopright // 上右角
    case radiusBottomleft // 下左角
    case radiusBottomright // 下右角
}

extension UIView {
    /// 必须在frame确定之后才行
    /// 单边或双边圆角
    /// sideType: 圆角类型
    /// cornerRadius: 圆角半径
    func layoutCornerRadiusType(sideType: RadiusType, cornerRadius: CGFloat) {
        
        let cornerSize = CGSize(width: cornerRadius, height: cornerRadius)
        
        var maskPath: UIBezierPath!
        
        switch sideType {
        case .radiusTop:
            maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: cornerSize)
        case .radiusLeft:
            maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: cornerSize)
        case .radiusBottom:
            maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: cornerSize)
        case .radiusRight:
            maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: cornerSize)
        case .radiusTopleft:
            maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .topLeft, cornerRadii: cornerSize)
        case .radiusTopright:
            maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .topRight, cornerRadii: cornerSize)
        case .radiusBottomleft:
            maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .bottomLeft, cornerRadii: cornerSize)
        case .radiusBottomright:
            maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .bottomRight, cornerRadii: cornerSize)
        default:
            maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: cornerSize)
        }
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        
        self.layer.mask = maskLayer
        
        self.layer.masksToBounds = true
        
    }
}

