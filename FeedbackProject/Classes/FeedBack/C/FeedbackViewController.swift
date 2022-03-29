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
    private var dataArr: [FeedbackModel?] = {
        let dataArr: [FeedbackModel?] = []
        return dataArr
    }()
    private var isCopy = Bool()

    ///tabbleview
    private lazy var tableView: UITableView = {
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
    ///弹出菜单
    private lazy var menuView: MLMenuView = {
        let menuView = MLMenuView(frame: CGRect(x: CGFloat.screenWidth - 234 - 10, y: 0, width: 234, height: 44*4),
                                  withTitles: ["Create Blank Form",
                                               "Copy Existing Form",
                                               "Create by Template",
                                               "Template Management"],
                                  withImageNames: ["ic_blankForm",
                                                   "ic_copyForm",
                                                   "ic_byTemplate",
                                                   "ic_templateMgmt"],
                                  withMenuViewOffsetTop: CGFloat.naviHeight(),
                                  withTriangleOffsetLeft: 216)
        menuView?.setCoverBackgroundColor(UIColor.clear)
        menuView?.setMenuViewBackgroundColor(UIColor.navbarColor)
        menuView?.separatorColor = .white
        menuView?.font = UIFont.systemFont(ofSize: 17)
        menuView?.didSelectBlock = { [weak self] index in
            print("跳转相对应的页面\(index)")
            guard let weakself = self else { return }
            switch index {
            case 0 : //Create Blank Form
                let editVC = EditFromViewController ()
                editVC.hidesBottomBarWhenPushed = true
                editVC.Complete = {() in
                    let data = RealmManagerTool.shareManager().queryObjects(objectClass: FeedbackModel.self, .feedback)
                    var dataArray: [FeedbackModel] = []
                    for model in data.reversed() {
                        dataArray.append(model)
                    }
                    self?.dataArr = dataArray
                    self?.tableView.reloadData()
                }
               
                self?.navigationController?.pushViewController(editVC, animated: true)

            case 1 ://Copy Existing Form
                self?.isCopy = true
            case 2 ://Create by Template
                
                let names = ["Event","Raffle","Business","Project","Other","Event","Raffle","Business","Project","Other"]
                let templateView = CreateByTemplateView()
                let data = RealmManagerTool.shareManager().queryObjects(objectClass: FeedbackModel.self, .template)
                for model in data.reversed() {
                    templateView.dataArr.append(model)
                }
                
                templateView.createByTemplateViewComplete = { [weak self] templateModel in
                    guard let weakself = self else { return }
                    
                    print("跳转ByTemplateView=========================\(templateModel)")
                    
                    let templateManageVC = TemplateManageVC()
                    templateManageVC.hidesBottomBarWhenPushed = true
                    weakself.navigationController?.pushViewController(templateManageVC, animated: true)
                    
                   
                }
                templateView.show()
                templateView.tableView.reloadData()
            case 3 ://Template Management
                
                let templateManageVC = TemplateManageVC()
                templateManageVC.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(templateManageVC, animated: true)
                
            default:
                break
            }
            
        }
        return menuView!
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(tableView)
        
        configureNavigationItem()
        
        let data = RealmManagerTool.shareManager().queryObjects(objectClass: FeedbackModel.self, .feedback)
        for model in data.reversed() {
            dataArr.append(model)
        }
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isCopy = false
    }

    
    func configureNavigationItem() {
        let addButton = UIButton(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        addButton.setImage(UIImage(named: "ic_add"), for: .normal)
        addButton.addTarget(self, action: #selector(tapAddButton), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc func tapAddButton() {
        menuView.showMenuEnterAnimation(.none)
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
            let formDetailVC = FormDetailVC(feedbackObj: selectedData!)
            formDetailVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(formDetailVC, animated: true)
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
            RealmManagerTool.shareManager().addObject(object: newModel, .feedback)
            
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
