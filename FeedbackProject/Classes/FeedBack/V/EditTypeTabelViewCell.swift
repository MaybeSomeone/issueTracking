//
//  EditTypeTabelViewCell.swift
//  FeedbackProject
//
//  Created by peter.wang61235 on 2022/3/8.
//

import UIKit

class EditTypeTabelViewCell: UITableViewCell, UICollectionViewDelegate,UICollectionViewDataSource ,UITextFieldDelegate{
    
    var addImageblock : tapBlock?
    
    var checkTitle: (_ model: FromChildTypeModel) -> Void = {_ in}

    lazy var titleLabel: UITextField = {
        let titleLabel = UITextField ()
        titleLabel.isUserInteractionEnabled = false
        titleLabel.font = UIFont.font_commonViewTitle
        titleLabel.textAlignment = .left
        titleLabel.delegate = self
        return titleLabel
    }()
    func textFieldDidEndEditing(_ textField: UITextField) {
        model?.title = textField.text
    }
    
    private lazy var customField: UITextField = {
        let field = UITextField ()
        field.placeholder = "请输入"
        field.isUserInteractionEnabled = false
        field.font = UIFont.font_commonViewTitle
        field.textAlignment = .left
        return field
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView ()
        textView.font = UIFont.font_commonViewTitle
        textView.placeholderLabel.text = "请输入"
        textView.isUserInteractionEnabled = false
        textView.textAlignment = .left
        return textView
    }()
    
    private lazy var rightImageView: UIImageView = {
        let rightImageView = UIImageView()
        rightImageView.image = (UIImage(named: "feedback_form_ic_date"))
        return rightImageView
    }()
    
    private lazy var alertView : AlertView = {
        
        let alertView = AlertView()
        alertView.frame = CGRect(x: 0, y: 0, width: CGFloat.screenWidth, height: CGFloat.screenHeight)
        alertView.isHidden = true
        return alertView
        
    }()
    
    private lazy var lineView : UIView = {
        
        let lineView = UIView()
        lineView.backgroundColor = .lineColor
        return lineView

    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .none
        self.selectionStyle = .none

        let delegate = UIApplication.shared.delegate as!AppDelegate
        delegate.window?.addSubview(alertView)
        
        alertView.cancelBlock = {() in
            self.alertView.isHidden = true
        }
        alertView.confirmBlock = {String in

          
            self.alertView.isHidden = true
            let chioceModel  = ChioceModel ()
            chioceModel.title = String
            self.model?.chioceList.insert(chioceModel, at: 0)
            self.model?.height = Int(self.collectView.contentSize.height + 40 >= 64 ? self.collectView.contentSize.height + 40 : 64)
            self.checkTitle(self.model!)
            self.layoutSubviews()

        }
      

        addSubviews()

    }
    var model: FromChildTypeModel? {
        didSet {
            titleLabel.text = model?.title
            collectView.reloadData()
        }
    }
    var editStatu: String? {
        didSet {

        }
    }
    func addSubviews() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(rightImageView)
        self.contentView.addSubview(customField)
        self.contentView.addSubview(textView)
        self.contentView.addSubview(collectView)
        self.contentView.addSubview(lineView)

    }
    
    
    
    lazy var collectView:UICollectionView = {
        let layout = EqualCellSpaceFlowLayout.init()
        layout.estimatedItemSize = CGSize(width: 64, height: 64)
        layout.minimumLineSpacing=1
        layout.minimumInteritemSpacing=1
        let collectView = UICollectionView.init(frame:.zero, collectionViewLayout: layout)
        collectView.delegate = self
        collectView.dataSource = self
        collectView.isScrollEnabled = false
        collectView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectView.showsVerticalScrollIndicator = true
        collectView.register(ChoiceColl.classForCoder(), forCellWithReuseIdentifier: "ChoiceColl")
        collectView.register(ImageChoiceColl.classForCoder(), forCellWithReuseIdentifier: "ImageChoiceColl")
        
        return collectView
    }()
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if model?.type == "5" {
            return model?.ImageList.count ?? 0
        }
        else{
            if self.editStatu == "1" {
                return model?.chioceList.count ?? 0

            }
            else{
                return  (model?.chioceList.count)! - 1

            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    
        if model?.type == "5" {
            let cellString = "ImageChoiceColl"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellString, for: indexPath) as! ImageChoiceColl
            cell.model = model?.ImageList[indexPath.row]
            return cell
            
        }
        else{
            let cellString = "ChoiceColl"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellString, for: indexPath) as! ChoiceColl
            cell.model = model?.chioceList[indexPath.row]
            return cell
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if model?.type == "5" && self.editStatu == "0"{
            self.addImageblock?()
        }
        else if model?.type != "5" && self.editStatu == "1"{
            if indexPath.row == indexPath.last && model?.chioceList[indexPath.last ?? 0].isEdit == true {
                alertView.isHidden = false
                self.alertView.updateContent(model: model!)
            }
            
            else{
                
            }
            
        }
    }
    override func layoutSubviews() {
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        rightImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(22)
            make.width.equalTo(22)
        }
        collectView.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().offset(140)
            make.centerY.equalToSuperview()
            make.right.equalTo(rightImageView.snp.left).offset(-20)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)

        }
        if self.editStatu == "0"{
            titleLabel.isUserInteractionEnabled = false
            customField.isUserInteractionEnabled = true
            textView.isUserInteractionEnabled = true

        }
        else if self.editStatu == "1"{
            customField.isUserInteractionEnabled = false
            textView.isUserInteractionEnabled = false
            titleLabel.isUserInteractionEnabled = true

            if model?.isSelet == true{
                
                rightImageView.image = (UIImage(named: "feedback_form_ic_checkbox_selected"))
            }
            else{
                
                rightImageView.image = (UIImage(named: "feedback_form_ic_checkbox"))
            }

        }
        else {
            rightImageView.image = (UIImage(named: "feedback_form_ic_date"))
            titleLabel.isUserInteractionEnabled = false
            customField.isUserInteractionEnabled = false
            textView.isUserInteractionEnabled = false

        }
      
        if model?.type == "0" || model?.type == "1"{
            self.customField.isHidden = false
            self.collectView.isHidden = true
            self.textView.isHidden = true
            customField.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(140)
                make.centerY.equalToSuperview()
                make.right.equalTo(rightImageView.snp.left).offset(-20).priority(99)
                make.height.equalTo(40)
            }
        }
        else if model?.type == "2" || model?.type == "3"{
            self.customField.isHidden = true
            self.textView.isHidden = true
            self.collectView.isHidden = false
        }
        else if model?.type == "4"{
            self.customField.isHidden = true
            self.collectView.isHidden = true
            self.textView.isHidden = false
            textView.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(140)
                make.right.equalTo(rightImageView.snp.left).offset(-20).priority(99)
                make.top.equalToSuperview().offset(20)
                make.bottom.equalToSuperview().offset(-20)
            }
        }
        else {
            self.customField.isHidden = true
            self.textView.isHidden = true
            self.collectView.isHidden = false

        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


enum AlignType  {
    case left
    case center
    case right
}

class EqualCellSpaceFlowLayout: UICollectionViewFlowLayout {
    
    //两个Cell之间的距离
    var betweenOfCell : CGFloat{
        didSet{
            self.minimumInteritemSpacing = betweenOfCell
        }
    }
    
    //cell对齐方式
    var cellType : AlignType = AlignType.left
    
    //在居中对齐的时候需要知道这行所有cell的宽度总和
    var sumCellWidth : CGFloat = 0.0
    
    override init() {
        betweenOfCell = 5.0
        super.init()
        scrollDirection = UICollectionView.ScrollDirection.vertical
        minimumLineSpacing = 5
        sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    convenience init(_ cellType:AlignType){
        self.init()
        self.cellType = cellType
    }
    
    convenience init(_ cellType: AlignType, _ betweenOfCell: CGFloat){
        self.init()
        self.cellType = cellType
        self.betweenOfCell = betweenOfCell
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let layoutAttributes_super : [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: rect) ?? [UICollectionViewLayoutAttributes]()
        let layoutAttributes:[UICollectionViewLayoutAttributes] = NSArray(array: layoutAttributes_super, copyItems:true)as! [UICollectionViewLayoutAttributes]
        var layoutAttributes_t : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
        for index in 0..<layoutAttributes.count{
            
            let currentAttr = layoutAttributes[index]
            let previousAttr = index == 0 ? nil : layoutAttributes[index-1]
            let nextAttr = index + 1 == layoutAttributes.count ?
            nil : layoutAttributes[index+1]
            
            layoutAttributes_t.append(currentAttr)
            sumCellWidth += currentAttr.frame.size.width
            
            let previousY :CGFloat = previousAttr == nil ? 0 : previousAttr!.frame.maxY
            let currentY :CGFloat = currentAttr.frame.maxY
            let nextY:CGFloat = nextAttr == nil ? 0 : nextAttr!.frame.maxY
            
            if currentY != previousY && currentY != nextY {
                if currentAttr.representedElementKind == UICollectionView.elementKindSectionHeader {
                    layoutAttributes_t.removeAll()
                    sumCellWidth = 0.0
                } else if currentAttr.representedElementKind == UICollectionView.elementKindSectionFooter {
                    layoutAttributes_t.removeAll()
                    sumCellWidth = 0.0
                } else {
                    self.setCellFrame(with: layoutAttributes_t)
                    layoutAttributes_t.removeAll()
                    sumCellWidth = 0.0
                }
            } else if currentY != nextY {
                self.setCellFrame(with: layoutAttributes_t)
                layoutAttributes_t.removeAll()
                sumCellWidth = 0.0
            }
        }
        return layoutAttributes
    }
    
    /// 调整Cell的Frame
    ///
    /// - Parameter layoutAttributes: layoutAttribute 数组
    func setCellFrame(with layoutAttributes : [UICollectionViewLayoutAttributes]){
        var nowWidth : CGFloat = 0.0
        switch cellType {
        case AlignType.left:
            nowWidth = self.sectionInset.left
            for attributes in layoutAttributes{
                var nowFrame = attributes.frame
                nowFrame.origin.x = nowWidth
                attributes.frame = nowFrame
                nowWidth += nowFrame.size.width + self.betweenOfCell
            }
        case AlignType.center:
            nowWidth = (self.collectionView!.frame.size.width - sumCellWidth - (CGFloat(layoutAttributes.count - 1) * betweenOfCell)) / 2
            for attributes in layoutAttributes{
                var nowFrame = attributes.frame
                nowFrame.origin.x = nowWidth
                attributes.frame = nowFrame
                nowWidth += nowFrame.size.width + self.betweenOfCell
            }
        case AlignType.right:
            nowWidth = self.collectionView!.frame.size.width - self.sectionInset.right
            for var index in 0 ..< layoutAttributes.count{
                index = layoutAttributes.count - 1 - index
                let attributes = layoutAttributes[index]
                var nowFrame = attributes.frame
                nowFrame.origin.x = nowWidth - nowFrame.size.width
                attributes.frame = nowFrame
                nowWidth = nowWidth - nowFrame.size.width - betweenOfCell
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UITextView {
    private struct RuntimeKey {
        static let hw_placeholderLabelKey = UnsafeRawPointer.init(bitPattern: "hw_placeholderLabelKey".hashValue)
        /// ...其他Key声明
    }

    /// 占位文字
    @IBInspectable public var placeholder: String {
        get {
            return self.placeholderLabel.text ?? ""
        }
        set {
            self.placeholderLabel.text = newValue
        }
    }

    /// 占位文字颜色
    @IBInspectable public var placeholderColor: UIColor {
        get {
            return self.placeholderLabel.textColor
        }
        set {
            self.placeholderLabel.textColor = newValue
        }
    }

     var placeholderLabel: UILabel {
        get {
            var label = objc_getAssociatedObject(self, UITextView.RuntimeKey.hw_placeholderLabelKey!) as? UILabel
            if label == nil {
                if (self.font == nil) {
                    self.font = UIFont.systemFont(ofSize: 14)
                }
                label = UILabel.init(frame: self.bounds)
                label?.numberOfLines = 0
                label?.font = self.font
                label?.textColor = UIColor.lightGray
                self.addSubview(label!)
                self.setValue(label!, forKey: "_placeholderLabel")
                objc_setAssociatedObject(self, UITextView.RuntimeKey.hw_placeholderLabelKey!, label!, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.sendSubviewToBack(label!)
            }
            return label!
        }
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.hw_placeholderLabelKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}


