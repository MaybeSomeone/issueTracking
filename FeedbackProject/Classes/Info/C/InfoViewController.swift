//
//  InfoViewController.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/2/22.
//

#if canImport(UIKit)
    import UIKit
#endif
import Charts
import SwiftUI

class InfoViewController: BaseViewController ,ChartViewDelegate{

    ///数据源
    var dataArr: [String] = ["Contact Us","Share App","Rate Us","Privacy Policy","User Agreement","Login out"]
    
    ///tabbleview
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 68
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.isScrollEnabled = true
        tableView.allowsMultipleSelectionDuringEditing = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
   
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        loginOut()
    }

    func loginOut() {
        guard let loginModel = RealmManagerTool.shareManager().queryObjects(objectClass: LoginModel.self,filter: "ID = 'login'",.login).first else { return }
        RealmManagerTool.shareManager().deleteObject(object: loginModel, .login)
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate  {
            let vc: BaseNaviController = BaseNaviController(rootViewController: LoginViewController())
            appDelegate.window?.rootViewController = vc
        }
        
    }
    
}



// MARK: -  UITableViewDataSource, UITableViewDelegate
extension InfoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ID : String = "UITableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: ID)
        }
              
        cell?.textLabel?.text = dataArr[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == dataArr.count-1 {
            loginOut()
        }
    }
}
