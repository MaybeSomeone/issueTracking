//
//  CreateByTemplateView.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/3/9.
//

import UIKit

class CreateByTemplateView: UIView {
    
    var createByTemplateViewComplete: ((CreateByTemplateModel)->Void)?
    
    /// 背景
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        bgView.isUserInteractionEnabled = true
        return bgView
    }()
    /// 头
    lazy var lineView: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 3
        btn.addTarget(self, action: #selector(headerViewBtnClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    /// 关闭按钮
    lazy var closeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "ic_close"), for: .normal)
        btn.addTarget(self, action: #selector(headerViewBtnClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    ///数据源
     var dataArr: [CreateByTemplateModel?] = {
        let dataArr: [CreateByTemplateModel?] = []
        return dataArr
    }()
    
    ///tabbleview
     lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 68
        tableView.register(CreateByTemplateViewCell.self, forCellReuseIdentifier: "CreateByTemplateViewCell")
        tableView.isScrollEnabled = true
        tableView.allowsMultipleSelectionDuringEditing = true
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: AppConfig.mWindow()!.bounds)
        self.backgroundColor = .black.withAlphaComponent(0.3)
        addSubviews()
    }

    
    func addSubviews() {
        
        addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.right.left.bottom.equalToSuperview()
            make.height.equalTo(CGFloat.screenHeight*0.6)
        }
        
        bgView.addSubviews([lineView, closeBtn, tableView])
        
        lineView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalTo(bgView.snp.centerX)
            make.height.equalTo(6)
            make.width.equalTo(48)
        }
        
        closeBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.width.equalTo(24)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom).offset(30)
            make.left.right.bottom.equalTo(bgView)
        }
        
        self.bgView.frame.origin.y = self.frame.height
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgView.layoutCornerRadiusType(sideType: .radiusTop, cornerRadius: 20)
    }
    
    @objc func headerViewBtnClick(sender: UIButton) {
        dismiss()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var point = touches.first?.location(in: self)
        point = bgView.layer.convert(point ?? CGPoint.zero, from: self.layer)
        let result = bgView.layer.contains(point!)
        if !result {
            dismiss()
        }
    }
    
    func show() {
        UIView.animate(withDuration: 0.24, animations: {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!
            window.addSubview(self)
            window.bringSubviewToFront(self)
            self.bgView.frame.origin.y = CGFloat.screenHeight*0.6
        }, completion: nil)
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.24, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
            self.bgView.frame.origin.y = self.frame.height
        }) { (Bool) -> Void in
            self.alpha = 0.0
            self.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



// MARK: -  UITableViewDataSource, UITableViewDelegate
extension CreateByTemplateView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreateByTemplateViewCell", for: indexPath) as! CreateByTemplateViewCell
        cell.model = dataArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = dataArr[indexPath.row] else { return }
        
        createByTemplateViewComplete?(model)
        
        dismiss()
    }
    
}
