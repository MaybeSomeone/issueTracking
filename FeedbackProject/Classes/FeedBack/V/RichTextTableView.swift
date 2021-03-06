//
//  LabelTableViewCell.swift
//  FeedbackProject
//
//  Created by 梁诗鹏 on 2022/3/17.
//

import UIKit

class RichTextTableView: UIView {
    
    var clickAddTemplateBlock: (()->Void)!
    
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
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "苹方-简 常规体", size: 40)
        textView.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubviews()
    }
    
    func addSubviews() {
        self.addSubviews([titleLabel, textView])
        self.snp.makeConstraints { make in
            make.height.equalTo(150)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(self).offset(20)
            make.width.equalTo(100)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(5)
            make.leading.equalTo(titleLabel.snp.trailing).offset(5)
            make.trailing.equalTo(self).offset(-5)
            make.bottom.equalTo(self.snp.bottom).offset(-20)
        }
    }
    
    @objc func addTemplateButtonClick() {
        print("test1111")
        if let _ = clickAddTemplateBlock {
            clickAddTemplateBlock()
        }
        print("test1111")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

