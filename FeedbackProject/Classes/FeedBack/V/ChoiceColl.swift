//
//  ChoiceColl.swift
//  FeedbackProject
//
//  Created by peter.wang61235 on 2022/3/11.
//

import UIKit

class ChoiceColl: UICollectionViewCell {
    
    let textLabel = UILabel()
    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textLabel.font = UIFont.font_commonNormalTitle
        textLabel.textColor = UIColor(red: 0.31, green: 0.31, blue: 0.31, alpha: 1)
        textLabel.textAlignment = .center
        self.contentView.addSubview(textLabel)
        
        self.contentView.addSubview(imageView)
        addSubviews()

    }
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//            setNeedsLayout()
//            layoutIfNeeded()
//            let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
//            var newFrame = layoutAttributes.frame
//            //限制宽度最大为100
//            newFrame.size.width = size.width > 200 ? 100 : ceil(size.width)
//            newFrame.size.height = ceil(size.height)
//            layoutAttributes.frame = newFrame
//            return layoutAttributes
//        }
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let size = self.textLabel.text?.size(withAttributes: [NSAttributedString.Key.font: UIFont.font_navigationTitle]) ?? CGSize.zero
        let att = super.preferredLayoutAttributesFitting(layoutAttributes);
        att.frame = CGRect(x: 0, y: 0, width: size.width+28, height: 22)
        self.textLabel.frame = CGRect(x: 0, y: 0, width: att.frame.size.width, height: 22)
        return att;
    }
    

    
    var model: ChioceModel? {
        didSet {
            textLabel.text = model?.title
            if model?.isEdit == true{
                imageView.image = UIImage(named: "feedback_formEdit_ic_radiobox")
            }
            else{
                imageView.image = UIImage(named: "feedback_formEdit_ic_radiobox")

            }
        }
    }

    func addSubviews() {
        
        imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalTo(22)
            make.width.equalTo(22)
            make.centerY .equalToSuperview()
        }
        
        textLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(10)
            make.centerY .equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
