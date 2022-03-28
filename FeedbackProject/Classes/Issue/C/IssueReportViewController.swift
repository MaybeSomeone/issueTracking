//
//  IssueReportViewController.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/3/8.
//

#if canImport(UIKit)
import UIKit
#endif
import Charts
import SwiftUI

class IssueReportViewController: BaseViewController ,ChartViewDelegate{
    
    /// 滚动视图
    lazy var scrollView: UIScrollView = {
        let scr = UIScrollView()
        scr.contentSize = CGSize(width: CGFloat.screenWidth, height: CGFloat.screenHeight)
        scr.contentInsetAdjustmentBehavior = .never
        scr.showsVerticalScrollIndicator = false
        scr.bounces = false
        return scr
    }()
    
    let parties = ["Figure legend 1", "Figure legend 2", "Figure legend 3", "Figure legend 4", "Figure legend 5"]
    /// Categary
    private lazy var caregoreBtn: UIButton = {
        let caregoreBtn = UIButton()
        caregoreBtn.setTitle("By Categary", for: .normal)
        caregoreBtn.setTitleColor(.black, for: .normal)
        caregoreBtn.setTitleColor(UIColor.navbarColor, for: .selected)
        caregoreBtn.isSelected = true
        caregoreBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        caregoreBtn.addTarget(self, action: #selector(caregoreBtnClicked(_:)), for: .touchUpInside)
        return caregoreBtn
    }()
    /// Categary饼图
    private lazy var caregorePieChartView: IssueReportPieChartView = {
        let caregorePieChartView = IssueReportPieChartView()
        caregorePieChartView.backgroundColor = .clear
        caregorePieChartView.parties = parties
        caregorePieChartView.isHidden = false
        return caregorePieChartView
    }()
    /// Type
    private lazy var typeBtn: UIButton = {
        let typeBtn = UIButton()
        typeBtn.setTitle("By Type", for: .normal)
        typeBtn.setTitleColor(.black, for: .normal)
        typeBtn.setTitleColor(UIColor.navbarColor, for: .selected)
        typeBtn.isSelected = false
        typeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        typeBtn.addTarget(self, action: #selector(typeBtnClicked(_:)), for: .touchUpInside)
        return typeBtn
    }()
    
    /// Type饼图
    private lazy var typechartView: IssueReportPieChartView = {
        let typechartView = IssueReportPieChartView()
        typechartView.backgroundColor = .clear
        typechartView.parties = parties
        typechartView.isHidden = true
        return typechartView
    }()
    /// Assignee
    private lazy var barTitleLabel: UILabel = {
        let barTitleLabel = UILabel()
        barTitleLabel.text = "By Assignee"
        barTitleLabel.textColor = (.black)
        barTitleLabel.font = .systemFont(ofSize: 12, weight: .bold)
        return barTitleLabel
    }()
    /// Assignee柱状图
    private lazy var barChartView: IssueReportBarChartView = {
        let barChartView = IssueReportBarChartView()
        barChartView.backgroundColor = .clear
        barChartView.parties = parties
        return barChartView
    }()
    /// Week Income/Resolve/Close Issue Count
    private lazy var lineTitleLabel: UILabel = {
        let lineTitleLabel = UILabel()
        lineTitleLabel.text = "Week Income/Resolve/Close Issue Count"
        lineTitleLabel.textColor = (.black)
        lineTitleLabel.font = .systemFont(ofSize: 12, weight: .bold)
        return lineTitleLabel
    }()
    /// Week Income/Resolve/Close Issue Count折线图
    private lazy var linechartView: IssueReportLineChartView = {
        let linechartView = IssueReportLineChartView()
        linechartView.backgroundColor = .clear
        linechartView.parties = parties
        return linechartView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        updateChartData()
        
    }
    ///添加视图
    func setupSubviews() {
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(caregoreBtn)
        caregoreBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(20)
            make.width.equalTo(82)
        }
        scrollView.addSubview(typeBtn)
        typeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(caregoreBtn.snp.right).offset(20)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(20)
            make.width.equalTo(82)
        }

        scrollView.addSubview(caregorePieChartView)
        caregorePieChartView.snp.makeConstraints { (make) in
            make.top.equalTo(caregoreBtn.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(300)
            make.width.equalTo(CGFloat.screenWidth - 40)
        }
        
        scrollView.addSubview(typechartView)
        typechartView.snp.makeConstraints { (make) in
            make.top.equalTo(caregoreBtn.snp.bottom).offset(20)
            make.height.equalTo(300)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(CGFloat.screenWidth - 40)
        }
        
        scrollView.addSubview(barTitleLabel)
        barTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(typechartView.snp.bottom).offset(20)
            make.height.equalTo(20)
        }
        
        scrollView.addSubview(barChartView)
        barChartView.snp.makeConstraints { (make) in
            make.top.equalTo(barTitleLabel.snp.bottom)
            make.height.equalTo(240)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(CGFloat.screenWidth - 40)
        }
        
        scrollView.addSubview(lineTitleLabel)
        lineTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(barChartView.snp.bottom).offset(10)
            make.height.equalTo(20)
        }
        
        scrollView.addSubview(linechartView)
        linechartView.snp.makeConstraints { (make) in
            make.top.equalTo(lineTitleLabel.snp.bottom)
            make.height.equalTo(231)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(CGFloat.screenWidth - 40)
            make.bottom.equalTo(scrollView.snp.bottom).offset(-30 - CGFloat.naviHeight() - CGFloat.bottomHeight())
        }
    }
    
    ///更新数据
    func updateChartData() {
        
        caregorePieChartView.setDataCount(Int(4), range: UInt32(100))
    
        typechartView.setDataCount(Int(3), range: UInt32(100))
        
        barChartView.setDataBarCount(Int(12), range:UInt32(12))
        
        linechartView.setDataLineCount(Int(5), range: UInt32(100))
    }
    
    ///caregoreBtnClicked
    @objc func caregoreBtnClicked(_ sender: UIButton) {
        sender.isSelected = true
        typeBtn.isSelected = false
        caregorePieChartView.isHidden = false
        typechartView.isHidden = true
    }
    
    ///typeBtnClicked
    @objc func typeBtnClicked(_ sender: UIButton) {
        sender.isSelected = true
        caregoreBtn.isSelected = false
        caregorePieChartView.isHidden = true
        typechartView.isHidden = false
    }
    
}
