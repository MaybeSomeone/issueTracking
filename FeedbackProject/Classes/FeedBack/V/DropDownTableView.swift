//
//  LabelTableViewCell.swift
//  FeedbackProject
//
//  Created by 梁诗鹏 on 2022/3/17.
//

import UIKit

class DropDownTableView: UIView {
    
    var clickShowPickButton: (()->Void)!
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "苹方-简 常规体", size: 34)
        label.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        return label
    }()
    
  lazy var selectedShowLabel: UILabel = {
        let selectedShowLabel = UILabel()
        selectedShowLabel.font = UIFont(name: "苹方-简 常规体", size: 34)
        selectedShowLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
        return selectedShowLabel
    }()
    
    private lazy var menuDownButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "drop_down_ic_down44"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(clickMenuDownButton), for: .touchUpInside)
        return button
    }()
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubviews()
    }
    
    func addSubviews() {
        self.addSubviews([titleLabel, selectedShowLabel, menuDownButton])
        
        self.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(self).offset(20)
            make.width.equalTo(100)
        }
        
        menuDownButton.snp.makeConstraints { make in
            make.trailing.equalTo(self).offset(-20)
            make.centerY.equalTo(self)
            make.width.height.equalTo(50)
        }
        
        selectedShowLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(titleLabel.snp.trailing).offset(20)
        }
    }
    
    @objc func clickMenuDownButton() {
        clickShowPickButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

   
}

