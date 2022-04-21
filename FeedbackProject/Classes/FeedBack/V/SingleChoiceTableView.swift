//
//  LabelTableViewCell.swift
//  FeedbackProject
//
//  Created by 梁诗鹏 on 2022/3/17.
//

import UIKit


class SingleChoiceTableView: UIView {
    
    var selected: SelectedBlock?;
    
    var unselectedBlock: UnselectedBlock?;
    
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
            make.height.equalTo(90 * (dataSource?.count ?? 2) / 2)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(20)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(20)
        }
        
        var i = 0
        for data in dataSource ?? [] {
            if (data.count > 0) {
                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.text = data
                
                let selectedButton = UIButton(type: .custom)
                self.addSubviews([label, selectedButton])
                
               
                let topConstraint = i * 60 + 20
                
                label.snp.makeConstraints { make in
                    make.top.equalTo(titleLabel.snp.bottom).offset(topConstraint)
                    make.leading.equalTo(self).offset(60)
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
                selectedButton.tag = 10000+i
                selectedButton.setImage(UIImage(named: "feedback_form_ic_checkbox"), for: .normal)
                i += 1
            }
        }
        
        self.snp.makeConstraints { make in
            make.height.equalTo(60 * i  + 20)
        }
    }
    
    
    @objc func toggleTheBackground(sender: UIButton) {
        print(sender.tag);
        sender.backgroundColor = UIColor.red
        let targetTag = 10000 + (dataSource ?? []).count
        let currentTag = sender.tag
        for tag in 10000...targetTag {
            self.viewWithTag(tag)
            let currentButton = self.viewWithTag(tag) as? UIButton
            if (currentTag != tag) {
                currentButton?.setImage(UIImage(named: "feedback_form_ic_checkbox"), for: .normal)
//                currentView?.backgroundColor = UIColor.white
            } else {
                currentButton?.setImage(UIImage(named: "feedback_form_ic_checkbox_selected"), for: .normal)
                self.selected!("\(dataSource![(sender.tag - 10000)])")
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

