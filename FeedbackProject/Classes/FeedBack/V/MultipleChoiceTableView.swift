//
//  LabelTableViewCell.swift
//  FeedbackProject
//
//  Created by 梁诗鹏 on 2022/3/17.
//

import UIKit

class MultipleChoiceTableView: UIView {
    
    var dataSource: Array<String>? {
        didSet {
            addSubviews()
        }
    }
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addSubviews() {
        self.addSubviews([titleLabel])
        self.snp.makeConstraints { make in
            make.height.equalTo(70 * (dataSource?.count ?? 2) / 2)        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(self).offset(20)
            make.width.equalTo(100)
        }
        
        var i = 0
        for data in dataSource ?? [] {
            if (data.count > 0) {
                print("\(i)")

                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.text = data
                
                let selectedButton = UIButton(type: .custom)
                self.addSubviews([label, selectedButton])

                let topConstraint = (i / 2) * 70 + 35 - 10
                
                let leadingOffSet = (i % 2) * 120 + 10
                label.snp.makeConstraints { make in
                    make.top.equalTo(self).offset(topConstraint)
                    make.leading.equalTo(titleLabel.snp.trailing).offset(leadingOffSet)
                    make.width.equalTo(60)
                }
                
                selectedButton.snp.makeConstraints { make in
                    make.leading.equalTo(label.snp.trailing).offset(10)
                    make.centerY.equalTo(label)
                    make.width.height.equalTo(20)
                }
                
//                selectedButton.layer.cornerRadius = 10
//                selectedButton.layer.borderWidth = 2
//                selectedButton.layer.borderColor = UIColor.red.cgColor
                selectedButton.addTarget(self, action: #selector(toggleTheBackground), for: .touchUpInside)
                selectedButton.setImage(UIImage(named: "feedback_form_ic_checkbox"), for: .normal)
                selectedButton.tag = 0
                i += 1
            }
        }
    }
    
    
    @objc func toggleTheBackground(sender: UIButton) {
        print(sender.tag);
        if (sender.tag == 0) {
            sender.setImage(UIImage(named: "feedback_form_ic_checkbox_selected"), for: .normal)
            sender.tag = 1
        } else {
            sender.tag = 0
            sender.setImage(UIImage(named: "feedback_form_ic_checkbox"), for: .normal)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

