//
//  LabelTableViewCell.swift
//  FeedbackProject
//
//  Created by 梁诗鹏 on 2022/3/17.
//

import UIKit

class LabelTableView: UIView {
    
    var clickAddTemplateBlock: (()->Void)!
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var content: String? {
        didSet {
            textfield.text = content ?? "";
        }
    }
    
    var enableEdit: Bool? {
        didSet {
            textfield.isEnabled = enableEdit ?? true
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "苹方-简 常规体", size: 34)
        label.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        return label
    }()
    
    private lazy var textfield: UITextField = {
        let textfield = UITextField()
        textfield.font = UIFont(name: "苹方-简 常规体", size: 34)
        textfield.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
        textfield.placeholder = "Title"
        return textfield
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubviews()
    }
    
    func addSubviews() {
        self.addSubviews([titleLabel, textfield])
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(self).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        textfield.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(titleLabel.snp.trailing).offset(20)
            make.height.equalTo(80)
        }
    }
    
    @objc func addTemplateButtonClick() {
        if let _ = clickAddTemplateBlock {
            clickAddTemplateBlock()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textHeight (text: String, fontSize: CGFloat, width: CGFloat) -> CGFloat {
        return text.boundingRect(with:CGSize(width: width, height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font:UIFont.systemFont(ofSize: fontSize)], context:nil).size.height+5
    }


}

