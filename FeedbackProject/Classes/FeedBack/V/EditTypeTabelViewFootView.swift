//
//  EditTypeTabelViewFootViewl.swift
//  FeedbackProject
//
//  Created by peter.wang61235 on 2022/3/8.
//

class EditTypeTabelViewFootView: UIView {

    private lazy var seletBtn: UIButton = {
        let seletBtn = UIButton()
        seletBtn.setImage(UIImage(named: "feedback_form_ic_preview"), for: .normal)
        seletBtn.imageView?.contentMode = .scaleAspectFill
        seletBtn.addTarget(self, action: #selector(seletBtn(_:)), for: .touchUpInside)
        return seletBtn

    }()
    
    @objc func seletBtn(_: UIButton) {
        print("seletbtn")
    }
    private lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .textTitleNormalColor
        lab.font = UIFont.font_commonBig18Title
        lab.text = "Save as template"
        lab.textAlignment = .center
        return lab
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    func addSubviews() {
       addSubviews([seletBtn,titleLabel])
                
        seletBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(seletBtn.snp.right).offset(12)
            make.centerY.equalTo(seletBtn.snp.centerY)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
