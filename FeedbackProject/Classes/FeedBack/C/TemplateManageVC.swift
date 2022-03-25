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
}

class TemplateManageVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dataSource: Array<TemplateMode> = [
        TemplateMode(title: "Event", des: "description", lastUpdateDate: "03/15/22"),
        TemplateMode(title: "Raffle", des: "description", lastUpdateDate: "03/15/22"),
        TemplateMode(title: "Business", des: "description", lastUpdateDate: "03/15/22"),
        TemplateMode(title: "Project", des: "description", lastUpdateDate: "03/15/22"),
        TemplateMode(title: "Other", des: "description", lastUpdateDate: "03/15/22"),
    ]
    
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
    }
    
    // MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row != dataSource.count) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TemplateTableViewCell", for: indexPath) as! TemplateTableViewCell
            cell.model = dataSource[indexPath.row]
            return cell
        } else {
            let cell = AddTemplateTableViewCell()
            
            cell.clickAddTemplateBlock = { () -> Void in
                print("push to next viewcontroller")
//                weakSelf.navigationController?.pushViewController("", animated: true)
            }
            return cell
        }
        
        
    }
}
