//
//  IssueHeaderView.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/2/23.
//

import UIKit

class IssueHeaderView: UIView {

    private lazy var idLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = UIFont.font_commonBig18Title
        lab.text = "ID"
        lab.textAlignment = .center
        return lab
    }()
    
    private lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = UIFont.font_commonBig18Title
        lab.text = "Title"
        lab.textAlignment = .center
        return lab
    }()
    
    private lazy var assginLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = UIFont.font_commonBig18Title
        lab.text = "Assign"
        lab.textAlignment = .center
        return lab
    }()
    
    private lazy var statusLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = UIFont.font_commonBig18Title
        lab.text = "Status"
        lab.textAlignment = .center
        return lab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    func addSubviews() {
        backgroundColor = UIColor.init(hex: "#F4F6FA")
       addSubviews([idLabel,titleLabel,assginLabel,statusLabel])
        
        let labelWidth = (CGFloat.screenWidth - 20)/4
        
        idLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(labelWidth)
            make.centerY.equalTo(self)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(idLabel.snp.right)
            make.width.equalTo(labelWidth)
            make.centerY.equalTo(self)
        }
        
        assginLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right)
            make.width.equalTo(labelWidth)
            make.centerY.equalTo(self)
        }
        
        statusLabel.snp.makeConstraints { (make) in
            make.left.equalTo(assginLabel.snp.right)
            make.width.equalTo(labelWidth)
            make.centerY.equalTo(self)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
