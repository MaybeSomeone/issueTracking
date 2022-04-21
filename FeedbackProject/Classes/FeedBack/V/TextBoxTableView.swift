//
//  LabelTableViewCell.swift
//  FeedbackProject
//
//  Created by 梁诗鹏 on 2022/3/17.
//

import UIKit

class TextBoxTableView: UIView {
    
    var clickAddTemplateBlock: (()->Void)!
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var content: String? {
        didSet {
            textview.text = content!
        }
    }
    
    var enableEdit: Bool? {
        didSet {
//            textview.isEditable = enableEdit ?? true
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "苹方-简 常规体", size: 34)
        label.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        return label
    }()
    
    var textview: UITextView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.font = UIFont(name: "苹方-简 常规体", size: 34)
        textview.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
        textview.placeholder = "XXXXXXX"
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubviews()
    }
    
    func addSubviews() {
        textview.translatesAutoresizingMaskIntoConstraints = false
        self.addSubviews([titleLabel, textview])
        let componentWidth = CGFloat.screenWidth - 40

        titleLabel.numberOfLines = 3
        titleLabel.backgroundColor = UIColor.blue
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(15)
            make.leading.equalTo(self).offset(20)
            make.width.equalTo(componentWidth)
            make.height.equalTo(50)
        }
        
        textview.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(self).offset(20)
            make.width.equalTo(componentWidth)
            make.height.equalTo(110)
        }
        textview.backgroundColor = UIColor.red
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

