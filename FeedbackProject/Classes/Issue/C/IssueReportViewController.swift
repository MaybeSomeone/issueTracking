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
    var menuArr = [["Category","Finance","Sales","Human Resources"],
                   ["Priority","Critical","High","Medium","Low"],
                   ["Issue type","Feature","Task","Bug"],
                   ["Statu","Open","In Progress","Resolved","Closed"],
                   ["More"]]
    
    var categaryDictionary = [String:[IssueModel?]]()
    var typeDictionary = [String:[IssueModel?]]()
    var assigneeDictionary = [String:[IssueModel?]]()
    
    var timeDict = [String: Any]()
    private lazy var dropDownMenu: CustomDropDownMenu = {
        let dropDownMenu = CustomDropDownMenu(origin: .zero, height: 54, width: CGFloat.screenWidth)
        dropDownMenu.datasource = self
        dropDownMenu.delegate = self
        return dropDownMenu
    }()
    
    private var filterView = IssueSearchMoreFilterView()
    
    ///筛选条件字典
    private var filterDict: [String: Any] = ["category": "0",
                                             "priority": "0",
                                             "type": "0",
                                             "status": "0",
                                             "assignee": "None",
                                             "startDate": Date(),
                                             "endDate": Date()]

    var dataArr: [IssueModel?] = {
        let dataArr: [IssueModel?] = []
        return dataArr
    }()


    
    /// 滚动视图
    lazy var scrollView: UIScrollView = {
        let scr = UIScrollView()
        scr.contentSize = CGSize(width: CGFloat.screenWidth, height: CGFloat.screenHeight)
        scr.contentInsetAdjustmentBehavior = .never
        scr.showsVerticalScrollIndicator = false
        scr.bounces = false
        return scr
    }()
    
//    let parties = ["Figure legend 1", "Figure legend 2", "Figure legend 3", "Figure legend 4", "Figure legend 5"]
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
//        caregorePieChartView.parties = categaryParties
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
//        typechartView.parties = typeParties
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
//        barChartView.parties = assigneeParties
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
//        linechartView.parties = stutaParties
        return linechartView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        let data = RealmManagerTool.shareManager().queryObjects(objectClass: IssueModel.self, .issue)
        for model in data.reversed() {
            print(model)
            dataArr.append(model)
        }
        
        categaryDictionary = Dictionary(grouping: dataArr, by: { ($0?.category)!})
        typeDictionary = Dictionary(grouping: dataArr, by: { ($0?.type)!})
        assigneeDictionary = Dictionary(grouping: dataArr, by: { ($0?.assignee)!})

        updateChartData()

    }
    ///添加视图
    func setupSubviews() {
        view.addSubview(dropDownMenu)
        dropDownMenu.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(54)
        }
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(54)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()

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
        
        caregorePieChartView.setDataCount(self.categaryDictionary , type: "caregore")
    
        typechartView.setDataCount(self.typeDictionary , type: "type")

        barChartView.setDataCount(self.assigneeDictionary)
        
        linechartView.setDataCount(self.dataArr,self.timeDict)
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



extension IssueReportViewController: CustomDropDownMenuDelegate, CustomDropDownMenuDataSource {
    func numberOfColumns(in menu: CustomDropDownMenu) -> NSInteger {
        return menuArr.count
    }
    
    func numberOfRows(in column: NSInteger, for forMenu: CustomDropDownMenu) -> Int {
        return menuArr[column].count
    }
    
    func titleForRow(at indexPath: CustomIndexPath, for forMenu: CustomDropDownMenu) -> String {
        return menuArr[indexPath.column][indexPath.row]
    }
    
    func willSelectClickedRow(at index: Int, for menu: CustomDropDownMenu) {
        if index == menuArr.count - 1 {
            dropDownMenu.tableView.isHidden = true
            dropDownMenu.backGroundView.isHidden = true
            ///more 在这里弹出更多条件
            let filterView = IssueSearchMoreFilterView()
            filterView.filterDict = filterDict
            filterView.show(form: self.view)
            filterView.searchBackComplete = {[weak self] dict in
                guard let weakself = self else { return }
                weakself.dataArr.removeAll()
                ///NSPredicate 筛选查询匹配
                if ((dict["startDate"] as! Date != Date()) && (dict["endDate"] as! Date != Date())) {
                    self!.timeDict = dict;
                    ///时间筛选
                    let defaultRealm = RealmManagerTool.shareManager().getDB(.issue)
                    
                    let datas = defaultRealm!.objects(IssueModel.self).filter("createDate BETWEEN %@ AND category = '\(dict["category"] ?? "0")' AND priority = '\(dict["priority"] ?? "0")' AND type = '\(dict["type"] ?? "0")' AND status = '\(dict["status"] ?? "0")' AND assignee = '\(dict["assignee"] ?? "None")'",[dict["startDate"], dict["endDate"]])

                    guard datas.count > 0 else {
                        self!.categaryDictionary = Dictionary(grouping: self!.dataArr, by: { ($0?.category)!})
                        self!.typeDictionary = Dictionary(grouping: self!.dataArr, by: { ($0?.type)!})
                        self!.assigneeDictionary = Dictionary(grouping: self!.dataArr, by: { ($0?.assignee)!})
                        self!.updateChartData()
                        return
                    }
                    
                    for model in datas.reversed() {
                        
    
                        _ = self!.dataArr.reduce([String:[IssueModel]]()) { (res, box) -> [String:[IssueModel]] in
                            var res = res
                            res[(box?.category)!] = (res[box!.category!] ?? [])
                            return res
                        }
                        weakself.dataArr.append(model)
                    }
                  
                }else{
                    let data = RealmManagerTool.shareManager().queryObjects(objectClass: IssueModel.self, filter: "category = '\(dict["category"] ?? "0")' AND priority = '\(dict["priority"] ?? "0")' AND type = '\(dict["type"] ?? "0")' AND status = '\(dict["status"] ?? "0")' AND assignee = '\(dict["assignee"] ?? "None")'", .issue)
                    for model in data.reversed() {
                        weakself.dataArr.append(model)
                    }
                    _ = self!.dataArr.reduce([String:[IssueModel]]()) { (res, box) -> [String:[IssueModel]] in
                        var res = res
                        res[(box?.category)!] = (res[box!.category!] ?? [])
                        return res
                    }

                }
                weakself.categaryDictionary = Dictionary(grouping: weakself.dataArr, by: { ($0?.category)!})
                weakself.typeDictionary = Dictionary(grouping: weakself.dataArr, by: { ($0?.type)!})
                weakself.assigneeDictionary = Dictionary(grouping: weakself.dataArr, by: { ($0?.assignee)!})
                weakself.updateChartData()

            }
            
            self.filterView = filterView
        }else{
            dropDownMenu.tableView.isHidden = false
            dropDownMenu.backGroundView.isHidden = false
        }
    }
    
    func didSelectRow(at indexPath: CustomIndexPath, for forMenu: CustomDropDownMenu) {
        
        dataArr.removeAll()
        switch indexPath.column { ///筛选条件，筛选数据
        case 0:
            filterDict["category"] = "\(indexPath.row)"
        case 1:
            filterDict["priority"] = "\(indexPath.row)"
        case 2:
            filterDict["type"] = "\(indexPath.row)"
        case 3:
            filterDict["status"] = "\(indexPath.row)"
        default:
            break
        }
        
        ///NSPredicate 筛选查询匹配
        let data = RealmManagerTool.shareManager().queryObjects(objectClass: IssueModel.self, filter: "category = '\(filterDict["category"] ?? "0")' AND priority = '\(filterDict["priority"] ?? "0")' AND type = '\(filterDict["type"] ?? "0")' AND status = '\(filterDict["status"] ?? "0")'", .issue)
        print(data)

        for model in data.reversed() {
            dataArr.append(model)
        }
        print(dataArr)
        categaryDictionary = Dictionary(grouping: dataArr, by: { ($0?.category)!})
        typeDictionary = Dictionary(grouping: dataArr, by: { ($0?.type)!})
        assigneeDictionary = Dictionary(grouping: dataArr, by: { ($0?.assignee)!})
        updateChartData()

    }
}

