//
//  ImageChoiceColl.swift
//  FeedbackProject
//
//  Created by peter.wang61235 on 2022/3/13.
//

class ImageChoiceColl: UICollectionViewCell {
    
    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.imageView.frame = self.bounds
        self.contentView.addSubview(imageView)

    }
  
    
    var model: ImageChioceModel? {
        didSet {
            
            imageView.image = UIImage(named: "feedback_formCustomized_ic_addImg64")

//            if model?.imageUrl != nil{
//                let url = URL(string: model?.imageUrl ?? "")//输入图片地址
//                // 从网络中获取数据流
//                let data = try! Data(contentsOf: url!)
//                // 通过数据流初始化图片
//                let urlImage = UIImage(data: data)
//                imageView.image = urlImage
//            }
//            else{
//                imageView.image = UIImage(named: "feedback_formCustomized_ic_addImg64")
//
//            }

        }
    }
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
            setNeedsLayout()
            layoutIfNeeded()
            let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
            var newFrame = layoutAttributes.frame
            //限制宽度最大为100
            newFrame.size.width = size.width > 100 ? 100 : ceil(size.width)
            newFrame.size.height = ceil(size.height)
            layoutAttributes.frame = newFrame
            return layoutAttributes
        }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
