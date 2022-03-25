//
//  AlertView.swift
//  FeedbackProject
//
//  Created by peter.wang61235 on 2022/3/15.
//

import UIKit


class AlertView: UIView {

    var cancelBlock : () -> Void = {}
    var confirmBlock: (_ title: String) -> Void = {_ in}

    
    private lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.shadeViewColor
        bgView.alpha = 0.5
        return bgView
    }()
    
    private lazy var alertView: UIView = {
        let alertView = UIView()
        alertView.layer.masksToBounds = true
        alertView.backgroundColor = .white
        alertView.layer.cornerRadius = 16
        alertView.layer.masksToBounds = true
        return alertView
    }()
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Template Name"
        titleLabel.font = UIFont.font_commonBig18Title
        titleLabel.textColor = UIColor.cancelbtnColor
        titleLabel.textAlignment = .left
        return titleLabel
    }()

    private lazy var  lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .lineColor
        return lineView
    }()

    lazy var textField: UITextField = {
       let textField = UITextField()
        textField.textColor = UIColor.darkText
        textField.font = UIFont.systemFont(ofSize: 16.0)
        textField.placeholder = "Template Description"
        textField.textAlignment = .left
        return textField
   }()
    func updateContent(model:FromChildTypeModel){
        if model.type == "2" {
            titleLabel.text = "Single choice"
            textField.placeholder = "Single"

        }
        else if model.type == "3" {
            titleLabel.text = "Multi choice"
            textField.placeholder = "Multi"
        }
        else{
            titleLabel.text = "Template Name"
            textField.placeholder = "Template Description"
        }
        
    }
    private lazy var cancelBtn: UIButton = {
       let cancelBtn = UIButton()
        cancelBtn.setTitle("cancel", for: .normal)
        cancelBtn.setTitleColor(.cancelbtnColor, for: .normal)
        cancelBtn.backgroundColor  = UIColor(hex: "#F5F6FA")
        cancelBtn.titleLabel?.font = UIFont.font_navigationTitle
        cancelBtn.addTarget(self, action: #selector(cancelBtnAction(_:)), for: .touchUpInside)
       return cancelBtn
   }()
    private  lazy var confirmBtn: UIButton = {
       let confirmBtn = UIButton()
        confirmBtn.setTitle("confirm", for: .normal)
        confirmBtn.setTitleColor(.tabbarColor, for: .normal)
        confirmBtn.backgroundColor  = UIColor(hex: "#F5F6FA")
        confirmBtn.titleLabel?.font = UIFont.font_navigationTitle
        confirmBtn.addTarget(self, action: #selector(confirmBtnAction(_:)), for: .touchUpInside)
       return confirmBtn
   }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    @objc func cancelBtnAction(_: UIButton) {
        self.cancelBlock()
    }
    @objc func confirmBtnAction(_: UIButton) {
        if textField.text?.count == 0 {
            CustomProgressHud.showError(withStatus: "Content cannot be empty!")
            return
        }
        self.confirmBlock(textField.text ?? "")
        textField.text = nil
    }
    

    func addSubviews() {
        addSubviews([bgView,alertView])
        alertView.addSubviews([titleLabel,lineView,textField,cancelBtn,confirmBtn])
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        alertView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(210)
            make.left.equalToSuperview().offset(28)
            make.right.equalToSuperview().offset(-28)
            make.height.equalTo(240)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(18)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(titleLabel.snp.bottom).offset(18)
            make.height.equalTo(0.5)

        }
        textField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(lineView.snp.bottom).offset(20)
            make.height.equalTo(30)
        }
        cancelBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(48)
            make.width.equalTo((CGFloat.screenWidth - 2*28)/2)
        }
        confirmBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(48)
            make.width.equalTo((CGFloat.screenWidth - 2*28)/2)
        }
        
    }
    
   
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
