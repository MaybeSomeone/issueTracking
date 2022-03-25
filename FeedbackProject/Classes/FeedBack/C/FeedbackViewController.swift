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
                break
            case 1 ://Copy Existing Form
                break
            case 2 ://Create by Template
                
                let names = ["Event","Raffle","Business","Project","Other","Event","Raffle","Business","Project","Other"]
                let templateView = CreateByTemplateView()
                //添加假数据 添加数据库
                for i in 0...names.count - 1 {
                    let  model = CreateByTemplateModel()
                    model.ID = "\(i + 1)"
                    model.title = names[i]
                    model.descriptio = "This is a requirement"
                    model.createDate = Calendar.current.startOfDay(for: Date())
                    templateView.dataArr.append(model)
                    //添加到本地数据库 后期可换成接口
                    RealmManagerTool.shareManager().addObject(object: model, .template)
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
        
        
        let titles = ["Event Feedback","Raffle Feedback","Business Feedback","Project Feedback","Other Feedback"]
        //添加假数据 添加数据库
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
        
        let formDetailVC = FormDetailVC()
        formDetailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(formDetailVC, animated: true)
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
