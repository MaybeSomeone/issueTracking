//
//  TemplateTableViewCell.swift
//  FeedbackProject
//
//  Created by 梁诗鹏 on 2022/3/16.
//

import UIKit

class TemplateTableViewCell: UITableViewCell {

    var model: TemplateMode? {
        didSet {
            capitalLable.text = String(model!.title.prefix(1))
            titleLabel.text = model?.title
            desLabel.text = model?.des
            dateLabel.text = model?.lastUpdateDate
        }
    }
    
    private lazy var capitalLable: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.textColor = UIColor.white
        lab.layer.cornerRadius = 5
        lab.clipsToBounds = true
        lab.font = UIFont(name: "苹方-简 中黑体", size: 40)
        lab.backgroundColor = UIColor(red: 0, green: 0.52, blue: 1, alpha: 1)
        lab.textAlignment = .center
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    private lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 20)
        lab.textAlignment = .center
        lab.numberOfLines = 0
        return lab
    }()
    
    private lazy var desLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
        lab.font = UIFont.systemFont(ofSize: 18)
//        lab.text = "nnnnnn"
        lab.numberOfLines = 0
        lab.textAlignment = .center
        return lab
    }()
    
    private lazy var dateLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
        lab.font = UIFont.font_commonViewTitle
//        lab.text = "Status"
        lab.numberOfLines = 0
        lab.textAlignment = .center
        return lab
    }()
    
    private lazy var arrowImage: UIImageView = {
        let lab = UIImageView(image: UIImage(named: "ic_arrowRight"))
        return lab
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .default
        self.accessoryType = .disclosureIndicator
        addSubviews()
    }
    
    func addSubviews() {
        addSubviews([capitalLable, titleLabel, desLabel, dateLabel, arrowImage])
        capitalLable.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.width.height.equalTo(50)
            make.centerY.equalTo(self)
        }
         
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(capitalLable.snp.trailing).offset(10)
            make.centerY.equalTo(capitalLable).offset(-12)
        }
         
        desLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.centerY.equalTo(capitalLable).offset(12)
        }
         
        arrowImage.snp.makeConstraints { (make) in
            make.trailing.equalTo(self).offset(20)
            make.centerY.equalTo(self)
            make.height.width.equalTo(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.trailing.equalTo(arrowImage.snp.leading).offset(-40)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

