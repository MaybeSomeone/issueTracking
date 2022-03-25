//
//  FeedbackTableViewCell.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/3/8.
//

import UIKit

class FeedbackTableViewCell: UITableViewCell {
    
    var model: FeedbackModel? {
        didSet {
            if model != nil {
                
                titleLabel.text = model?.title
                descripLabel.text = model?.descriptio
                
                let date = model?.createDate
                let dfmatter = DateFormatter()
                dfmatter.dateFormat = "yyyy-MM-dd"
                let dateStr = dfmatter.string(from: date!)
                dateLabel.text = "Create date:\(dateStr)"
                
                authorLabel.text = "Author:\(model?.author ?? "")"
                if model?.status == "0" {
                    statusLabel.text = "All"
                }else if model?.status == "1" {
                    statusLabel.text = "Testing"
                }else if model?.status == "2" {
                    statusLabel.text = "Save"
                }else if model?.status == "3" {
                    statusLabel.text = "Publish"
                }
            }
        }
    }
    ///标题
    private lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 16)
        lab.text = "Feedback title"
        lab.textAlignment = .left
        return lab
    }()
    ///描述
    private lazy var descripLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = UIFont.font_commonViewTitle
        lab.text = "feedback description feedback description"
        lab.textAlignment = .left
        lab.numberOfLines = 0
        return lab
    }()
    ///日期
    private lazy var dateLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = UIFont.font_commonCellTitle
        lab.text = "Create date: 2022-03"
        lab.textAlignment = .left
        return lab
    }()
    ///状态
    private lazy var statusLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.init(hex: "#007CC2")
        lab.font = UIFont.font_commonViewTitle
        lab.text = "Publish"
        lab.textAlignment = .right
        return lab
    }()
    ///发布者
    private lazy var authorLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = UIFont.font_commonViewTitle
        lab.text = "Author:xxx"
        lab.textAlignment = .right
        return lab
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .default
        self.accessoryType = .none
        addSubviews()
    }
    
    func addSubviews() {
        
        addSubviews([titleLabel, descripLabel, dateLabel, statusLabel, authorLabel])
        
        statusLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(60)
            make.height.equalTo(20)
        }
        
        authorLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-15)
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(120)
            make.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.right.equalTo(statusLabel.snp.left).offset(10)
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(20)
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-15)
            make.right.equalTo(authorLabel.snp.left).offset(10)
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(20)
        }
        
        descripLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalTo(dateLabel.snp.top)
            make.right.equalTo(authorLabel.snp.left).offset(10)
            make.left.equalToSuperview().offset(15)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
