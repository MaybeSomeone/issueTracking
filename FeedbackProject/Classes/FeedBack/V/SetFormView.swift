//
//  SetFormView.swift
//  FeedbackProject
//
//  Created by peter.wang61235 on 2022/3/9.
//

import UIKit

typealias tapBlock = ()->Void

class SetFormView: UIView {

    
    private lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.shadeViewColor
        bgView.alpha = 0.5
        return bgView
    }()
    
    private lazy var TabelViewbgView: UIView = {
        let TabelViewbgView = UIView()
        TabelViewbgView.backgroundColor = .white
        return TabelViewbgView
    }()
    
     lazy var setFromTabelView: UITableView = {
         let setFromTabelView = UITableView(frame:CGRect(x: 0, y: 0, width: CGFloat.screenWidth, height: CGFloat.screenWidth - AppConfig.mWindowSafebottom()), style: .plain)
        setFromTabelView.separatorStyle = .none
        setFromTabelView.rowHeight = UITableView.automaticDimension
        setFromTabelView.estimatedRowHeight = 300
         if #available(iOS 15.0, *) {
             setFromTabelView.sectionHeaderTopPadding = 0
         }
        return setFromTabelView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(funTap))
        self.bgView.addGestureRecognizer(tapGesture)

    }
    var block : tapBlock?
    
    @objc func funTap(sender: UITapGestureRecognizer){
        
        self.block?()
    }
    

    func addSubviews() {
       addSubviews([bgView,TabelViewbgView,setFromTabelView])
        self.addSubview(bgView);
        self.addSubview(TabelViewbgView);
        self.TabelViewbgView.addSubview(setFromTabelView);

        bgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }
        TabelViewbgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(200)
        }
        setFromTabelView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
   
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.TabelViewbgView.addCorner(conrners:[.topRight,.topLeft], radius: 10)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
