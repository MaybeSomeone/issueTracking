//
//  EditConfirmTabelViewCell.swift
//  FeedbackProject
//
//  Created by peter.wang61235 on 2022/3/9.
//

import UIKit

typealias CustomizeClick = ()->Void


class EditConfirmTabelViewCell: UITableViewCell {
    
    var block : CustomizeClick?

    var SaveTemplateblock: (_ isSelected: Bool) -> Void = {_ in}

     lazy var seletBtn: UIButton = {
        let seletBtn = UIButton()
        seletBtn.setImage(UIImage(named: "feedback_form_ic_checkbox"), for: .normal)
        seletBtn.setImage(UIImage(named: "feedback_form_ic_checkbox_selected"), for: .selected)
        seletBtn.imageView?.contentMode = .scaleAspectFill
        seletBtn.addTarget(self, action: #selector(seletBtnClick(_:)), for: .touchUpInside)
        return seletBtn

    }()
    
    @objc func seletBtnClick(_: UIButton) {
        seletBtn.isSelected = !(seletBtn.isSelected)
        self.SaveTemplateblock(seletBtn.isSelected)
    }
     lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .textTitleNormalColor
        lab.font = UIFont.font_commonBig18Title
        lab.text = "Save as template"
        lab.textAlignment = .center
        return lab
    }()

    private lazy var CustomizeBtn: UIButton = {
        let CustomizeBtn = UIButton()
        CustomizeBtn.setTitle("Customized Form", for:.normal )
        CustomizeBtn.setTitleColor(UIColor.rgba(25.0, G: 25.0, B: 25.0, A: 1.0), for: .normal)
        CustomizeBtn.titleLabel?.font = UIFont.font_commonBig18Title
        CustomizeBtn.layer.cornerRadius = 8
        CustomizeBtn.layer.masksToBounds = true
        CustomizeBtn.addTarget(self, action: #selector(customizeClick), for: .touchUpInside)
        return CustomizeBtn

    }()
    

    @objc func customizeClick() {
        
        self.block?()
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .none
        self.selectionStyle = .none
        addSubviews()
    }

    
    func addSubviews() {
        self.contentView.addSubview(seletBtn)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(CustomizeBtn)
        seletBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(22)
            make.width.equalTo(22)

        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(seletBtn.snp.right).offset(12)
            make.centerY.equalTo(seletBtn.snp.centerY)
        }
        CustomizeBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(seletBtn.snp.bottom).offset(21)
            make.bottom.equalToSuperview().offset(-20)
            make.right.equalToSuperview().offset(-20)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}
