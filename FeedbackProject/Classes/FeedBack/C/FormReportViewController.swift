//
//  FormReportViewController.swift
//  FeedbackProject
//
//  Created by peter.wang61235 on 2022/3/17.
//

import UIKit
import SwiftUI
import Photos


struct ReporModel {
    var type: String
    var title: String
    var vArray = [String]()
    var xArray = [String]()
}

class FormReportViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource{
    
    var dataArr: [ReporModel?] = {
        let dataArr: [ReporModel?] = []
        return dataArr
    }()
    
    private var dataModel = FeedbackModel()
    private var single:[String] = []
    private var multit : [String] = []
    private var singleseled : [String] = []
    private var multitseled : [String] = []

    private lazy var table : UITableView = {
        
        let table:UITableView = UITableView(frame: CGRect(x: 0, y: 0, width: CGFloat.screenWidth, height: CGFloat.screenHeight - AppConfig.mWindowSafebottom() - AppConfig.mWindowSafetop()), style:.plain)
         table.register(FormReportCell.self, forCellReuseIdentifier: "FormReportCell")

        return table
        
    }()
    
    var model: FeedbackModel? {
        didSet {
            
            let data = RealmManagerTool.shareManager().queryObjects(objectClass: CollectDataModel.self,filter: "FormId = '\(model!.ID ?? "")'",.publish)
            print(model as Any)
            print(data)

            for dataModel in data.reversed() {
                for str in dataModel.singleSelected{
                    singleseled.append(str)
                }
                for str in dataModel.multitedSelected{
                    multitseled.append(str)
                }
            }
            
            for childTypeModel in model!.Child{
                if childTypeModel.type == "2"{
                    for chioceModel in childTypeModel.chioceList{
                        if chioceModel.title != nil{
                            single.append(chioceModel.title!)
                        }
                    }
                    let model = ReporModel.init(type: "1", title: childTypeModel.title!, vArray:single, xArray: singleseled)
                    self.dataArr.append(model)
                }
                if childTypeModel.type == "3"{
                    for chioceModel in childTypeModel.chioceList{
                        if chioceModel.title != nil{
                            multit.append(chioceModel.title!)
                        }
                    }
                    let model = ReporModel.init(type: "2", title: childTypeModel.title!, vArray:multit, xArray: multitseled)
                    self.dataArr.append(model)

                }
            }


        }
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "Report"
        setupUI()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.dataArr.count + 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row==0{
            return 60
        }
        return 324
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FormReportCell", for: indexPath) as! FormReportCell
        cell.backgroundColor = .clear
        if indexPath.row == 0{
            cell.labelTitle = String(indexPath.row);
        }
        else{
            let model = dataArr[indexPath.row - 1]
            
            if model?.type == "1"{
                cell.setDataCount(model!.vArray, model!.xArray ,_title:model!.title)
            }
            if model?.type == "2"{
                cell.setBarChartViewData(model!.vArray, model!.xArray,_title:model!.title)

            }
        }
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
