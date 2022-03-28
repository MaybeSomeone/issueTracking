//
//  EditFormFootView.swift
//  FeedbackProject
//
//  Created by peter.wang61235 on 2022/3/15.
//

import UIKit

typealias testingBtnBlock = ()->Void

typealias saveBtnBlock = ()->Void

typealias publishBtnBlock = ()->Void

class EditFormFootView: UIView {

    var testingBtnBlock : testingBtnBlock?
    
    var saveBtnBlock : saveBtnBlock?
    
    var publishBtnBlock : publishBtnBlock?

    
    private  lazy var TestingBtn: UIButton = {
       let TestingBtn = UIButton()
        TestingBtn.setTitle("Testing", for: .normal)
        TestingBtn.setTitleColor(.cancelbtnColor, for: .normal)
        TestingBtn.backgroundColor  = UIColor(hex: "#FCFCFC")
        TestingBtn.layer.masksToBounds = true
        TestingBtn.layer.cornerRadius = 4
        TestingBtn.layer.borderWidth = 0.5
        TestingBtn.layer.borderColor = UIColor(hex: "#D9D9D9").cgColor
        TestingBtn.titleLabel?.font = UIFont.font_navigationTitle
        TestingBtn.addTarget(self, action: #selector(TestingBtnAction(_:)), for: .touchUpInside)
       return TestingBtn
   }()
    private  lazy var SaveBtn: UIButton = {
       let SaveBtn = UIButton()
        SaveBtn.setTitle("Save", for: .normal)
        SaveBtn.setTitleColor(.white, for: .normal)
        SaveBtn.backgroundColor  = UIColor(hex: "#007CC2")
        SaveBtn.layer.masksToBounds = true
        SaveBtn.layer.cornerRadius = 4
        SaveBtn.layer.borderWidth = 0.5
        SaveBtn.layer.borderColor = UIColor(hex: "#006DE4").cgColor
        SaveBtn.titleLabel?.font = UIFont.font_navigationTitle
        SaveBtn.addTarget(self, action: #selector(SaveBtnAction(_:)), for: .touchUpInside)
       return SaveBtn
   }()
    private  lazy var PublishBtn: UIButton = {
       let PublishBtn = UIButton()
        PublishBtn.setTitle("Publish", for: .normal)
        PublishBtn.setTitleColor(.cancelbtnColor, for: .normal)
        PublishBtn.backgroundColor  = UIColor(hex: "#FCFCFC")
        PublishBtn.layer.masksToBounds = true
        PublishBtn.layer.cornerRadius = 4
        PublishBtn.layer.borderWidth = 0.5
        PublishBtn.layer.borderColor = UIColor(hex: "#D9D9D9").cgColor
        PublishBtn.titleLabel?.font = UIFont.font_navigationTitle
        PublishBtn.addTarget(self, action: #selector(PublishBtnAction(_:)), for: .touchUpInside)
       return PublishBtn
   }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(hex: "#F0F0F0").withAlphaComponent(0.2)
        addSubviews()
    }
    func addSubviews() {
       addSubviews([SaveBtn,TestingBtn,PublishBtn])
        SaveBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(17)
            make.centerX.equalToSuperview()
            make.width.equalTo(104)
            make.height.equalTo(44)

        }
        TestingBtn.snp.makeConstraints { (make) in

            make.right.equalTo(SaveBtn.snp.left).offset(-((CGFloat.screenWidth - 104*3)/4))
            make.centerY.equalTo(SaveBtn.snp.centerY)
            make.width.equalTo(104)
            make.height.equalTo(44)
            
        }
        PublishBtn.snp.makeConstraints { (make) in
            make.left.equalTo(SaveBtn.snp.right).offset(((CGFloat.screenWidth - 104*3)/4))
            make.centerY.equalTo(SaveBtn.snp.centerY)
            make.width.equalTo(104)
            make.height.equalTo(44)

        }
        
        
    }
    @objc func TestingBtnAction(_: UIButton) {
        self.testingBtnBlock?()
    }

    @objc func SaveBtnAction(_: UIButton) {
        self.saveBtnBlock?()

    }

    @objc func PublishBtnAction(_: UIButton) {
        self.publishBtnBlock?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
