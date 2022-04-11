//
//  AddTemplateCell.swift
//  FeedbackProject
//
//  Created by peter.wang61235 on 2022/3/30.
//

import UIKit

typealias AddTemplateTabeClick = ()->Void

class AddTemplateTabelViewCell: UITableViewCell {
    
    var block : CustomizeClick?
    
    private lazy var CustomizeBtn: UIButton = {
        let CustomizeBtn = UIButton()
        CustomizeBtn.setTitle("add to template", for:.normal )
        CustomizeBtn.setTitleColor(UIColor.rgba(25.0, G: 25.0, B: 25.0, A: 1.0), for: .normal)
        CustomizeBtn.titleLabel?.font = UIFont.font_commonBig18Title
        CustomizeBtn.layer.cornerRadius = 8
        CustomizeBtn.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
        CustomizeBtn.layer.masksToBounds = true
        CustomizeBtn.addTarget(self, action: #selector(customizeClick), for: .touchUpInside)
        return CustomizeBtn

    }()
    

    @objc func customizeClick() {
        
        self.block?()
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .none
        self.selectionStyle = .none
        addSubviews()
    }

    
    func addSubviews() {
        self.contentView.addSubview(CustomizeBtn)
        
        CustomizeBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(21)
            make.height.equalTo(44)
            make.right.equalToSuperview().offset(-20)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}
