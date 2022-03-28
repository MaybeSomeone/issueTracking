//
//  TemplateManageVC.swift
//  FeedbackProject
//
//  Created by 梁诗鹏 on 2022/3/16.
//

import UIKit


struct TemplateMode {
    var title: String
    var des: String
    var lastUpdateDate: String
    var date: Date?
}

class TemplateManageVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var templateModeList: [TemplateMode] = []
    
    
    var feedBackModel: [FeedbackModel] = []
    
//    var dataSource: Array<TemplateMode> = [
//        TemplateMode(title: "Event", des: "description", lastUpdateDate: "03/15/22"),
//        TemplateMode(title: "Raffle", des: "description", lastUpdateDate: "03/15/22"),
//        TemplateMode(title: "Business", des: "description", lastUpdateDate: "03/15/22"),
//        TemplateMode(title: "Project", des: "description", lastUpdateDate: "03/15/22"),
//        TemplateMode(title: "Other", des: "description", lastUpdateDate: "03/15/22"),
//    ]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 75
        tableView.register(TemplateTableViewCell.self, forCellReuseIdentifier: "TemplateTableViewCell")
        tableView.register(AddTemplateTableViewCell.self, forCellReuseIdentifier: "AddTemplateTableViewCell")
        tableView.isScrollEnabled = true
        tableView.allowsMultipleSelectionDuringEditing = true
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Template Management"
        // Do any additional setup after loading the view.
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
        let data = RealmManagerTool.shareManager().queryObjects(objectClass: CreateByTemplateModel.self, filter: nil, .template)
        print("template mode = \(data)")
    }
    
    // MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (templateModeList.count ) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row != templateModeList.count) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TemplateTableViewCell", for: indexPath) as! TemplateTableViewCell
            cell.model = templateModeList[indexPath.row]
            return cell
        } else {
            let cell = AddTemplateTableViewCell()
            
            cell.clickAddTemplateBlock = { () -> Void in
                print("push to next viewcontroller")
                let editFormVC = EditFromViewController()
                self.navigationController?.pushViewController(editFormVC, animated: true)
            }
            return cell
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let data = RealmManagerTool.shareManager().queryObjects(objectClass: FeedbackModel.self, .feedback)
        var cacheList: Array<TemplateMode> = []
        if data.count > 0 {
            for model in data {
                let middleMode = TemplateMode(title: model.title ?? "", des: model.descriptio ?? "", lastUpdateDate: date2String(model.createDate ?? Date()), date: model.createDate)
                cacheList.append(middleMode)
            }
        }
        templateModeList = cacheList
        self.feedBackModel = data
        self.tableView.reloadData()
    }
    // MARK: - Date to string
    //日期 -> 字符串
    func date2String(_ date:Date, dateFormat:String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
          print("Deleted")
          let feedBackModelRow = self.feedBackModel.remove(at: indexPath.row)
          RealmManagerTool.shareManager().deleteObject(object: feedBackModelRow, .feedback)
          templateModeList.remove(at: indexPath.row)
          tableView.deleteRows(at: [indexPath], with: .automatic)
      }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feedback = feedBackModel[indexPath.row]
        let editForm = EditFromViewController()
        editForm.dataModel = feedback
        self.navigationController?.pushViewController(editForm, animated: true)
    }
}
