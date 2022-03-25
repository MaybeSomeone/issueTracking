//
//  FormReportViewController.swift
//  FeedbackProject
//
//  Created by peter.wang61235 on 2022/3/17.
//

import UIKit
import SwiftUI
import Photos

class FormReportViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource{
    
    private var dataModel = FromTypeModel()

    private lazy var table : UITableView = {
        
        let table:UITableView = UITableView(frame: CGRect(x: 0, y: 0, width: CGFloat.screenWidth, height: CGFloat.screenHeight - AppConfig.mWindowSafebottom() - AppConfig.mWindowSafetop()), style:.plain)
         table.register(FormReportCell.self, forCellReuseIdentifier: "FormReportCell")

        return table
        
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "Edit Form"
        setupUI()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 324
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "FormReportCell", for: indexPath) as! FormReportCell
        cell.backgroundColor = .clear
        return cell

    }

    func setupUI()  {
        self.view!.addSubview(table)
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = UIColor(hex: "#F5F6FA")
        table.register(EditTypeTabelViewCell.self, forCellReuseIdentifier: "EditTypeTabelViewCell")
    }


}
