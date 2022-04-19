//
//  ReportListViewController.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/4/18.
//

import UIKit

class ReportListViewController: BaseViewController {

    ///数据源
    var dataArr: [FeedbackModel?] = {
        let dataArr: [FeedbackModel?] = []
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
        tableView.register(FeedbackTableViewCell.self, forCellReuseIdentifier: "FeedbackTableViewCell")
        tableView.isScrollEnabled = true
        tableView.allowsMultipleSelectionDuringEditing = true
        return tableView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(tableView)
        
        loadFeedbackModelData()
    }
    
    func loadFeedbackModelData () {
        
        let data = RealmManagerTool.shareManager().queryObjects(objectClass: FeedbackModel.self, .feedback)
        if data.count > 0 {
            for model in data.reversed() {
                if model.status == "2" { ///Publish状态刷选出来
                    dataArr.append(model)
                }
            }
            tableView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}



// MARK: -  UITableViewDataSource, UITableViewDelegate
extension ReportListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackTableViewCell", for: indexPath) as! FeedbackTableViewCell
        cell.model = dataArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedData = dataArr[indexPath.row]
        let formReportVC = FormReportViewController()
        navigationController?.pushViewController(formReportVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { [weak self] _, _, complete in
            guard let `self` = self else { return }
            guard let model = self.dataArr[indexPath.row] else { return }
            //删除本地数据 后期可换成接口
            RealmManagerTool.shareManager().deleteObject(object: model, .feedback)
            //删除数据
            self.dataArr.remove(at: indexPath.row)
            
            tableView.reloadData()
        }

        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
}
