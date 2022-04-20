//
//  FeedbackViewController.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/2/22.
//

import UIKit
import SnapKit

class FeedbackViewController: BaseViewController {
    ///数据源
    var dataArr: [FeedbackModel?] = {
        let dataArr: [FeedbackModel?] = []
        return dataArr
    }()
    private var isCopy = Bool()
    
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
        
        let data = RealmManagerTool.shareManager().queryObjects(objectClass: FeedbackModel.self, .feedback)
        if data.count > 0 {
            for model in data.reversed() {
                dataArr.append(model)
            }
            tableView.reloadData()
        }else{
            let titles = ["Event Feedback","Raffle Feedback","Business Feedback","Project Feedback","Other Feedback"]
            //            添加假数据 添加数据库
            for i in 0...titles.count - 1  {
                let  model = FeedbackModel()
                model.ID = "\(i + 1)"
                model.title = titles[i]
                model.status = "1"
                model.author = "Currie"
                model.createDate = Calendar.current.startOfDay(for: Date())
                model.descriptio = "feedback description"
                dataArr.append(model)
                //添加到本地数据库 后期可换成接口
                RealmManagerTool.shareManager().addObject(object: model, .feedback)
            }
            
            tableView.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isCopy = false
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}


// MARK: -  UITableViewDataSource, UITableViewDelegate
extension FeedbackViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        if isCopy == true{
            let selectedData = dataArr[indexPath.row]
            let editForm = EditFromViewController()
            editForm.hidesBottomBarWhenPushed = true
            editForm.model = selectedData ?? FeedbackModel()
            editForm.Complete = {() in
                let data = RealmManagerTool.shareManager().queryObjects(objectClass: FeedbackModel.self, .feedback)
                var dataArray: [FeedbackModel] = []
                for model in data.reversed() {
                    dataArray.append(model)
                }
                self.dataArr = dataArray
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(editForm, animated: true)
            
        }
        else{
            let selectedData = dataArr[indexPath.row]
//            let formDetailVC = FormDetailVC(feedbackObj: selectedData!)
//            formDetailVC.hidesBottomBarWhenPushed = true
//            navigationController?.pushViewController(formDetailVC, animated: true)
            let editVC = EditFromViewController()
            editVC.model = selectedData
            editVC.titleLabel = "Edit Form"
            editVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(editVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let copyAction = UIContextualAction(style: .normal, title: "Copy") { [weak self] _, _, complete in
            guard let `self` = self else { return }
            
            guard let model = self.dataArr[indexPath.row] else { return }
            let newModel = FeedbackModel()
            newModel.title = model.title
            newModel.status = model.status
            newModel.createDate = model.createDate
            newModel.richtext = model.richtext
            newModel.author = model.author
            newModel.ID = "000\(model.ID ?? "000")\(indexPath.row)"
            newModel.Child = model.Child
            let editForm = EditFromViewController()
            editForm.hidesBottomBarWhenPushed = true
            editForm.model = newModel
            self.navigationController?.pushViewController(editForm, animated: true)
//            RealmManagerTool.shareManager().addObject(object: newModel, .feedback)
            
            self.dataArr.append(newModel)
            tableView.reloadData()
        }
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { [weak self] _, _, complete in
            guard let `self` = self else { return }
            guard let model = self.dataArr[indexPath.row] else { return }
            //删除本地数据 后期可换成接口
            RealmManagerTool.shareManager().deleteObject(object: model, .feedback)
            //删除数据
            self.dataArr.remove(at: indexPath.row)
            
            tableView.reloadData()
        }
        
        copyAction.backgroundColor = .blue
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, copyAction])
        return configuration
    }
    
}
