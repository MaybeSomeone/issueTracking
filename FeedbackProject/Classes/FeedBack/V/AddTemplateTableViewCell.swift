//
//  TemplateTableViewCell.swift
//  FeedbackProject
//
//  Created by 梁诗鹏 on 2022/3/16.
//

import UIKit

class AddTemplateTableViewCell: UITableViewCell{
    
    var clickAddTemplateBlock: (()->Void)!
    
    private lazy var addNewButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Template", for: .normal)
        button.backgroundColor = UIColor.blue
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.accessoryType = .none
        self.separatorInset = UIEdgeInsets(top: 0, left: .screenWidth, bottom: 0, right: 0)
        addSubviews()
    }
    
    func addSubviews() {
        self.contentView.addSubview(addNewButton)
        addNewButton.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
        addNewButton.layer.cornerRadius = 5
        addNewButton.addTarget(self, action: #selector(addTemplateButtonClick), for: .touchDown)
        addNewButton.setTitleColor(UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1), for: .normal)
        addNewButton.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self)
            make.height.equalTo(50)
            make.leading.equalTo(self).offset(50)
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

