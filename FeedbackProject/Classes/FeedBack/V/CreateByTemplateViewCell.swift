//
//  CreateByTemplateViewCell.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/3/9.
//

import UIKit

class CreateByTemplateViewCell: UITableViewCell {

    var model: CreateByTemplateModel? {
        didSet {
            if (model != nil) {
                titleLabel.text = model?.title
                descripLabel.text = model?.descriptio
                let str = model?.title
                imageLabel.text = "\(str![str!.startIndex])"
            }
        }
    }
    /// 背景图
    private lazy var headImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.randomColor
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        return imageView
    }()
    ///
    private lazy var imageLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .white
        lab.font = UIFont.systemFont(ofSize: 18)
//        lab.text = "F"
        lab.textAlignment = .center
        return lab
    }()
    
    ///标题
    private lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 16)
//        lab.text = "Feedback"
        lab.textAlignment = .left
        return lab
    }()
    ///描述
    private lazy var descripLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .init(hex: "#BFBFBF")
        lab.font = UIFont.font_commonViewTitle
//        lab.text = "feedback description"
        lab.textAlignment = .left
        lab.numberOfLines = 0
        return lab
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .default
        self.accessoryType = .disclosureIndicator
        addSubviews()
    }
    
    func addSubviews() {

        addSubviews([headImageView, titleLabel, descripLabel])
        
        headImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headImageView.snp.right).offset(15)
            make.top.equalToSuperview().offset(9)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(24)
        }

        descripLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headImageView.snp.right).offset(15)
            make.top.equalTo(titleLabel.snp.bottom).offset(1)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(21)
        }

        headImageView.addSubview(imageLabel)
        imageLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
