//
//  LabelTableViewCell.swift
//  FeedbackProject
//
//  Created by 梁诗鹏 on 2022/3/17.
//

import UIKit

class ImageTableView: UIView {
    
    var clickAddImageBlock: (()->Void)!
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    
    var imageView: UIImageView = UIImageView()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "苹方-简 常规体", size: 34)
        label.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubviews()
    }
    
    func addSubviews() {
        let button = UIButton(type: .custom)
        self.addSubviews([titleLabel, imageView, button])
      

        button.addTarget(self, action: #selector(addImage), for: .touchUpInside)
        self.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(self).offset(20)
            make.width.equalTo(100)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(titleLabel.snp.trailing).offset(20)
            make.height.width.equalTo(50)
        }
        
        imageView.image = UIImage(named: "ic_addImg64")
        button.snp.makeConstraints { make in
            make.edges.equalTo(imageView)
        }
        
    }
    
    @objc func addImage() {
        clickAddImageBlock()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

