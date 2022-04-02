//
//  IssueViewController.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/2/22.
//

import UIKit
import RealmSwift
class IssueViewController: BaseViewController {
    
    var menuArr = [["Category","Finance","Sales","Human Resources"],
                   ["Priority","Critical","High","Medium","Low"],
                   ["Issue type","Feature","Task","Bug"],
                   ["Statu","Open","In Progress","Resolved","Closed"],
                   ["More"]]
    
    private lazy var dropDownMenu: CustomDropDownMenu = {
        let dropDownMenu = CustomDropDownMenu(origin: .zero, height: 54, width: CGFloat.screenWidth)
        dropDownMenu.datasource = self
        dropDownMenu.delegate = self
        return dropDownMenu
    }()
    
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
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 68
        tableView.register(IssueTableViewCell.self, forCellReuseIdentifier: "IssueTableViewCell")
        tableView.isScrollEnabled = true
        tableView.allowsMultipleSelectionDuringEditing = true
        return tableView
    }()
    
    private var filterView = IssueSearchMoreFilterView()
    
    private lazy var issueHeaderView : IssueHeaderView = {
        let headerView = IssueHeaderView()
        return headerView
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        filterView.dismiss()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(dropDownMenu)
        view.addSubview(issueHeaderView)
        view.addSubview(tableView)
       
        
        
        let data = RealmManagerTool.shareManager().queryObjects(objectClass: IssueModel.self, .issue)
        
        if data.count > 0 {
            for model in data.reversed() {
                print(model)
                dataArr.append(model)
            }
            tableView.reloadData()
        }else{
            //添加假数据 添加数据库
            for i in 0...4 { //status == 1
                let  model = IssueModel()
                let date = Date()
                model.ID = "\(i + 1)"
                model.title = "test"
                model.assgin = "INFO"
                model.status = "1"
                model.author = "Currie"
                model.resolveDate = date.addingTimeInterval(TimeInterval(i*10*24*60*60))
                model.closeDate = date.addingTimeInterval(TimeInterval(i*5*24*60*60))
                model.createDate =  Calendar.current.startOfDay(for: Date())
                model.descriptio = "This is a requirement"
                model.category = "0"
                model.priority = "0"
                model.type = "0"
                model.assignee = "assignee1"
                dataArr.append(model)
                
                //添加到本地数据库 后期可换成接口
                RealmManagerTool.shareManager().addObject(object: model, .issue)
            }
            
            for i in 5...10 {//全部
                let  model = IssueModel()
                let date = Date()
                model.ID = "\(i + 1)"
                model.title = "test"
                model.assgin = "INFO"
                model.status = "0"
                model.author = "Currie"
                model.resolveDate = date.addingTimeInterval(TimeInterval(i*10*24*60*60))
                model.closeDate = date.addingTimeInterval(TimeInterval(i*5*24*60*60))
                model.createDate =  Calendar.current.startOfDay(for: Date())
                model.descriptio = "This is a requirement"
                model.category = "0"
                model.priority = "0"
                model.type = "0"
                model.assignee = "assignee2"
                dataArr.append(model)
                
                //添加到本地数据库 后期可换成接口
                RealmManagerTool.shareManager().addObject(object: model, .issue)
            }
            
            for i in 11...15 { //type == 1
                let  model = IssueModel()
                let date = Date()
                model.ID = "\(i + 1)"
                model.title = "test"
                model.assgin = "INFO"
                model.status = "0"
                model.author = "Currie"
                model.resolveDate = date.addingTimeInterval(TimeInterval(i*10*24*60*60))
                model.closeDate = date.addingTimeInterval(TimeInterval(i*5*24*60*60))
                model.createDate =  Calendar.current.startOfDay(for: Date())
                model.descriptio = "This is a requirement"
                model.category = "0"
                model.priority = "0"
                model.type = "1"
                model.assignee = "assignee3"
                dataArr.append(model)
                
                //添加到本地数据库 后期可换成接口
                RealmManagerTool.shareManager().addObject(object: model, .issue)
            }
            
            for i in 16...20 { //category == 1
                let  model = IssueModel()
                let date = Date()
                model.ID = "\(i + 1)"
                model.title = "test"
                model.assgin = "INFO"
                model.status = "0"
                model.author = "Currie"
                model.resolveDate = date.addingTimeInterval(TimeInterval(i*10*24*60*60))
                model.closeDate = date.addingTimeInterval(TimeInterval(i*5*24*60*60))
                model.createDate =  Calendar.current.startOfDay(for: Date())
                model.descriptio = "This is a requirement"
                model.category = "0"
                model.priority = "0"
                model.type = "0"
                model.assignee = "None"
                dataArr.append(model)
                
                //添加到本地数据库 后期可换成接口
                RealmManagerTool.shareManager().addObject(object: model, .issue)
            }
            tableView.reloadData()
            
        }
    }
    


    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        dropDownMenu.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(54)
        }
        
        issueHeaderView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(54)
            make.left.right.equalToSuperview()
            make.height.equalTo(54)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(issueHeaderView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
}


// MARK: -  UITableViewDataSource, UITableViewDelegate
extension IssueViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IssueTableViewCell", for: indexPath) as! IssueTableViewCell
        cell.model = dataArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = AddNewIssueVC(isCreateNew: false)
        let model = dataArr[indexPath.row]
        detailVC.hidesBottomBarWhenPushed = true
        detailVC.issueMode = model
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { [weak self] _, _, complete in
            guard let `self` = self else { return }
            //            let datas = RealmManagerTool.shareManager().queryObjects(objectClass: IssueModel.self, .issue)
            guard let model = self.dataArr[indexPath.row] else { return }
            //删除本地数据 后期可换成接口
            RealmManagerTool.shareManager().deleteObject(object: model, .issue)
            //删除数据
            self.dataArr.remove(at: indexPath.row)
            
            tableView.reloadData()
        }
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

}



// MARK: -  CustomDropDownMenuDelegate, CustomDropDownMenuDataSource
extension IssueViewController: CustomDropDownMenuDelegate, CustomDropDownMenuDataSource {
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
                    ///时间筛选
                    let defaultRealm = RealmManagerTool.shareManager().getDB(.issue)
                    
                    let datas = defaultRealm!.objects(IssueModel.self).filter("createDate BETWEEN %@ AND category = '\(dict["category"] ?? "0")' AND priority = '\(dict["priority"] ?? "0")' AND type = '\(dict["type"] ?? "0")' AND status = '\(dict["status"] ?? "0")' AND assignee = '\(dict["assignee"] ?? "None")'",[dict["startDate"], dict["endDate"]])

                    guard datas.count > 0 else { return }
                    
                    for model in datas.reversed() {
                        weakself.dataArr.append(model)
                    }
                    weakself.tableView.reloadData()
                  
                }else{
                    let data = RealmManagerTool.shareManager().queryObjects(objectClass: IssueModel.self, filter: "category = '\(dict["category"] ?? "0")' AND priority = '\(dict["priority"] ?? "0")' AND type = '\(dict["type"] ?? "0")' AND status = '\(dict["status"] ?? "0")' AND assignee = '\(dict["assignee"] ?? "None")'", .issue)
                    for model in data.reversed() {
                        weakself.dataArr.append(model)
                    }
                    weakself.tableView.reloadData()
                }
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
        for model in data.reversed() {
            dataArr.append(model)
        }
        tableView.reloadData()
        
    }
}
