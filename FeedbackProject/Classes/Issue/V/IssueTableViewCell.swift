//
//  IssueTableViewCell.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/2/23.
//

import UIKit

class IssueTableViewCell: UITableViewCell {

    var model: IssueModel? {
        didSet {
            
            idLabel.text = model?.ID
            titleLabel.text = model?.title
            assginLabel.text = model?.assignee
            statusLabel.text = model?.status
        }
    }
    
    private lazy var idLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = UIFont.font_commonViewTitle
//        lab.text = "123456"
        lab.textAlignment = .center
        return lab
    }()
    
    private lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = UIFont.font_commonViewTitle
//        lab.text = "tititiiitiittitititit"
        lab.textAlignment = .center
        lab.numberOfLines = 0
        return lab
    }()
    
    private lazy var assginLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = UIFont.font_commonViewTitle
//        lab.text = "nnnnnn"
        lab.numberOfLines = 0
        lab.textAlignment = .center
        return lab
    }()
    
    private lazy var statusLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = UIFont.font_commonViewTitle
//        lab.text = "Status"
        lab.numberOfLines = 0
        lab.textAlignment = .center
        return lab
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .default
        self.accessoryType = .disclosureIndicator
        addSubviews()
    }
    
    func addSubviews() {
        
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
