//
//  EditTypeTabelViewCell.swift
//  FeedbackProject
//
//  Created by peter.wang61235 on 2022/3/8.
//

import UIKit

typealias heightBlock = ()->Void

class EditTypeTabelViewCell: UITableViewCell, UICollectionViewDelegate,UICollectionViewDataSource ,UITextFieldDelegate, UITextViewDelegate{
    
    var addImageblock : tapBlock?
    
    var upddateheight : heightBlock?

    var checkTitle: (_ model: FromChildTypeModel) -> Void = {_ in}

    lazy var titleLabel: UITextView = {
        let titleLabel = UITextView ()
        titleLabel.isUserInteractionEnabled = true
        titleLabel.placeholder = "请输入"
        titleLabel.font = UIFont.font_commonViewTitle
        titleLabel.textAlignment = .left
        titleLabel.isScrollEnabled = false
        titleLabel.delegate = self
        return titleLabel
    }()
    
        func textViewDidChange(_ textView: UITextView) {
            
            if textView == titleLabel{
                model?.title = textView.text
            }
            else{
                model?.content = textView.text
            }
            // 储存原textView的大小
            let oldSize = textView.frame.size
    
            // 预设textView的大小，宽度设为固定宽度，高度设为CGFloat的最大值
            let presetSize = CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
    
            // 重新计算textView的实际大小
            let newSize = textView.sizeThatFits(presetSize)
    
            // 更新textView的大小
            textView.frame = CGRect(origin: CGPoint(x: textView.frame.origin.x, y: textView.frame.origin.y), size: CGSize(width: textView.frame.size.width, height: newSize.height))
    
            // 当高度变化时，刷新tableview（beginUpdates和endUpdates必须成对使用）
            if newSize.height != oldSize.height {
                self.upddateheight?()
            }
        }
     lazy var customField: UITextView = {
        let field = UITextView ()
        field.placeholder = "请输入"
        field.isUserInteractionEnabled = true
        field.font = UIFont.font_commonViewTitle
        field.textAlignment = .left
        field.isScrollEnabled = false
        field.delegate = self

        return field
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView ()
        textView.font = UIFont.font_commonViewTitle
        textView.placeholderLabel.text = "请输入"
        textView.isUserInteractionEnabled = true
        textView.textAlignment = .left
        textView.delegate = self
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
            self.model?.chioceList.insert(chioceModel, at: (self.model?.chioceList.count)! - 1)
            self.model?.height = Int(self.collectView.contentSize.height + 22 >=  44 ? self.collectView.contentSize.height + 22: 44)
            self.checkTitle(self.model!)
            self.layoutSubviews()

        }
      

        addSubviews()

    }
    var model: FromChildTypeModel? {
        didSet {
            titleLabel.text = model?.title
            textView.text = model?.content
            customField.text = model?.content
            
            collectView.reloadData()
            titleLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-62)
                make.top.equalToSuperview().offset(20)
            }
            
            rightImageView.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-16)
                make.height.equalTo(22)
                make.width.equalTo(22)
            }
            lineView.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
                make.bottom.equalToSuperview()
                make.height.equalTo(0.5)

            }
        
            if self.editStatu == "0"{
                rightImageView.image = (UIImage(named: "feedback_form_ic_date"))
            }
            else if self.editStatu == "1"{
                if model?.isSelet == true{
                    rightImageView.image = (UIImage(named: "feedback_form_ic_checkbox_selected"))
                }
                else{
                    
                    rightImageView.image = (UIImage(named: "feedback_form_ic_checkbox"))
                }

            }
            else {
                rightImageView.image = (UIImage(named: "feedback_form_ic_date"))
            }

          
            if model?.type == "0" || model?.type == "1"{
                self.customField.isHidden = false
                self.collectView.isHidden = true
                self.textView.isHidden = true
                customField.snp.remakeConstraints { (make) in
                    make.left.equalToSuperview().offset(140)
                    make.top.equalToSuperview().offset(20)
                    make.right.equalTo(rightImageView.snp.left).offset(-20)
                    make.bottom.equalToSuperview().offset(-20)
                }
                collectView.snp.remakeConstraints { (make) in
                }
                textView.snp.remakeConstraints { (make) in
                }
            }
            else if model?.type == "2" || model?.type == "3"{
                self.customField.isHidden = true
                self.textView.isHidden = true
                self.collectView.isHidden = false
                collectView.snp.remakeConstraints{ (make) in
                    make.left.equalToSuperview().offset(20)
                    make.right.equalToSuperview().offset(-62)
                    make.top.equalTo(titleLabel.snp.bottom)
                    make.height.equalTo(Int(self.model!.height))
                    make.bottom.equalToSuperview().offset(-20)
                }
                customField.snp.remakeConstraints { (make) in
                }
                textView.snp.remakeConstraints { (make) in
                }
            }
            else if model?.type == "4"{
                self.customField.isHidden = true
                self.collectView.isHidden = true
                self.textView.isHidden = false
                textView.snp.remakeConstraints { (make) in
                    make.left.equalToSuperview().offset(20)
                    make.right.equalTo(rightImageView.snp.left).offset(-20)
                    make.top.equalTo(titleLabel.snp.bottom)
                    make.height.equalTo(100)
                    make.bottom.equalToSuperview().offset(-20)
                }
                customField.snp.remakeConstraints { (make) in
                }
                collectView.snp.remakeConstraints { (make) in
                }
            }
            else if model?.type == "5" {
                
                self.customField.isHidden = true
                self.textView.isHidden = true
                self.collectView.isHidden = false
                collectView.snp.remakeConstraints{ (make) in
                    make.left.equalToSuperview().offset(20)
                    make.right.equalToSuperview().offset(-62)
                    make.top.equalTo(titleLabel.snp.bottom)
                    make.height.equalTo(Int(self.model!.height))
                    make.bottom.equalToSuperview().offset(-20)
                }
                customField.snp.remakeConstraints { (make) in
                }
                textView.snp.remakeConstraints { (make) in
                }

            }

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
            return model?.chioceList.count ?? 0

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
        else if model?.type != "5"{
            
            if indexPath.row == (model?.chioceList.count)! - 1 {
                
                alertView.isHidden = false
                self.alertView.updateContent(model: model!)
            }
            
            else{
                
            }
            
        }
    }
    override func layoutSubviews() {
        if self.editStatu == "0"{
            rightImageView.image = (UIImage(named: "feedback_form_ic_date"))
        }
        else if self.editStatu == "1"{
            if model?.isSelet == true{
                rightImageView.image = (UIImage(named: "feedback_form_ic_checkbox_selected"))
            }
            else{
                
                rightImageView.image = (UIImage(named: "feedback_form_ic_checkbox"))
            }

        }
        else {
            rightImageView.image = (UIImage(named: "feedback_form_ic_date"))
        }
        collectView.snp.updateConstraints { (make) in
            make.height.equalTo(Int(self.model!.height))
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


    
