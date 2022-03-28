//
//  Edit.swift
//  FeedbackProject
//
//  Created by peter.wang61235 on 2022/3/8.
//

import UIKit
import SwiftUI
import Photos

class EditFromViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate & UINavigationControllerDelegate{

    var dataModel = FeedbackModel()
    private var editDataModel = FeedbackModel()
    private var templateModel = CreateByTemplateModel()
    private var takingPicture = UIImagePickerController()
    private var IsSaveTemplate = Bool()
    var Complete : () -> Void = {}

    private lazy var setFormView : SetFormView = {
        
        let setFormView = SetFormView()
        setFormView.frame = CGRect(x: 0, y: CGFloat.screenHeight, width: CGFloat.screenWidth, height: CGFloat.screenHeight)
        return setFormView
        
    }()
    
    private lazy var alertView : AlertView = {
        
        let alertView = AlertView()
        alertView.frame = self.view.bounds
        alertView.isHidden = true
        return alertView
        
    }()
    
    private lazy var editFormFootView : EditFormFootView = {
        
        let editFormFootView = EditFormFootView()
        editFormFootView.frame = CGRect(x: 0, y: CGFloat.screenHeight - 96 - AppConfig.mWindowSafebottom() - AppConfig.mWindowSafetop(), width: CGFloat.screenWidth, height: 96)
        editFormFootView.backgroundColor = .white
        return editFormFootView
        
    }()
    
    private lazy var table : UITableView = {
        
        let table:UITableView = UITableView(frame: CGRect(x: 0, y:0, width: CGFloat.screenWidth, height: CGFloat.screenHeight - AppConfig.mWindowSafebottom() - AppConfig.mWindowSafetop()), style:.plain)
            table.separatorStyle = .none
       
         if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = 0
         }
         return table
        
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "Edit Form"
        configureAddNewIssueButton()
        creatdata()
        setupUI()
        
    }
    
    @objc func tapAddButton() {
        
    }
    
    func configureAddNewIssueButton() {
        let addButton = UIButton(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        addButton.setImage(UIImage(named: "ic_preview"), for: .normal)
        addButton.imageView?.contentMode = .scaleAspectFill
        addButton.addTarget(self, action: #selector(tapAddButton), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    func setupUI()  {
        
        let delegate = UIApplication.shared.delegate as!AppDelegate
        delegate.window?.addSubview(setFormView)
        delegate.window?.addSubview(alertView)
        self.view!.addSubview(table)
        self.view!.addSubview(editFormFootView)
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = .white
        setFormView.setFromTabelView.delegate = self
        setFormView.setFromTabelView.dataSource = self
        table.register(EditTypeTabelViewCell.self, forCellReuseIdentifier: "EditTypeTabelViewCell")
        table.register(EditConfirmTabelViewCell.self, forCellReuseIdentifier: "EditConfirmTabelViewCell")
        setFormView.setFromTabelView.register(EditTypeTabelViewCell.self, forCellReuseIdentifier: "EditTypeTabelViewCell")
        
        setFormView.block = {() in
            self.hideshadeView()
        }
        alertView.cancelBlock = {() in
            self.hideshadeView()
        }

        alertView.confirmBlock = {String in
            self.hideshadeView()
            self.savedataModel()
            self.templateModel.title = String
            self.templateModel.ID = "100\(arc4random_uniform(100) + 1)"
            RealmManagerTool.shareManager().addObject(object: self.dataModel, .feedback)
            RealmManagerTool.shareManager().addObject(object: self.templateModel, .template)
            self.Complete()
            self.navigationController?.popViewController(animated: true)


        }
        editFormFootView.publishBtnBlock = {() in
            if self.dataModel.Child.count > 0{
                self.dataModel.status = "3"
                if self.IsSaveTemplate == true{
                    self.alertView.isHidden = false
                    
                }
                else{
                    self.savedataModel()
                    RealmManagerTool.shareManager().addObject(object: self.dataModel, .feedback)
                    self.Complete()
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else{
                CustomProgressHud.showError(withStatus: "Option cannot be empty!")

            }
        }
        editFormFootView.saveBtnBlock = {() in
            if self.dataModel.Child.count > 0{
                self.dataModel.status = "2"
                if self.IsSaveTemplate == true{
                    self.alertView.isHidden = false
                }
                else{
                    self.savedataModel()
                    RealmManagerTool.shareManager().addObject(object: self.dataModel, .feedback)
                    self.Complete()
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else{
                CustomProgressHud.showError(withStatus: "Option cannot be empty!")

            }
           
          

        }
        editFormFootView.testingBtnBlock = {() in
            if self.dataModel.Child.count > 0{
                self.dataModel.status = "1"
                if self.IsSaveTemplate == true{
                    self.alertView.isHidden = false
                }
                else{
                    self.savedataModel()
                    RealmManagerTool.shareManager().addObject(object: self.dataModel, .feedback)
                    self.Complete()
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else{
                CustomProgressHud.showError(withStatus: "Option cannot be empty!")

            }
        }

    }
    
    func savedataModel(){
        let loginModel = RealmManagerTool.shareManager().queryObjects(objectClass: LoginModel.self, .login).first
        self.dataModel.author = loginModel?.username
        self.dataModel.createDate = Calendar.current.startOfDay(for: Date())
        self.dataModel.ID = "100\(arc4random_uniform(100) + 1)"
        self.dataModel.title = self.dataModel.Child[0].title
        self.dataModel.descriptio = self.dataModel.Child[1].title
    }
    func creatdata(){
        for i in 0 ..< 6{
        editDataModel.Child.append(self.creatModel(i: i))
        }
    }
    
    func creatModel( i : Int) -> FromChildTypeModel{
        let model = FromChildTypeModel()
        switch i {
        case 0:
            model.title = "Lable"
            model.type = "0"
            model.ID = "0"
            model.editStatu = "1"
            model.isSelet = true
            model.height = 64
        case 1:
            model.title = "Textbox"
            model.type = "1"
            model.ID = "1"
            model.height = 64
            model.isSelet = true
        case 2:
            model.title = "Single choice"
            model.type = "2"
            model.ID = "2"
            model.height = 64
            model.isSelet = false
            let SingleModel = ChioceModel()
            SingleModel.isEdit = true
            model.chioceList.append(SingleModel)

        case 3:
            model.title = "Multi choice"
            model.type = "3"
            model.ID = "3"
            model.height = 64
            model.isSelet = false
            let multiModel = ChioceModel()
            multiModel.isEdit = true
            model.chioceList.append(multiModel)
            
          case 4:
            model.title = "Rich Text"
            model.type = "4"
            model.ID = "4"
            model.isSelet = false
            model.height = 128

        default:
            model.title = "Image"
            model.type = "5"
            model.ID = "5"
            model .isSelet = false
            model.height = 104
            let ImageModel = ImageChioceModel()
            model.ImageList.append(ImageModel)
                        
        }
        return model
    
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        var model = FromChildTypeModel()
        model = self.editDataModel.Child[5]
        if(takingPicture.allowsEditing == false){
    
            let imageModel = ImageChioceModel()
//            imageModel.imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? String
            model.ImageList.insert(imageModel, at: 0)
            self.setFormView.setFromTabelView.reloadData()
        }
        takingPicture.dismiss(animated: true, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView == table{
            return dataModel.Child.count + 1
        }
        else{
            return editDataModel.Child.count
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row != dataModel.Child.count || tableView != table{
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTypeTabelViewCell", for: indexPath) as! EditTypeTabelViewCell
            
            if tableView == table{
                
                let curModel = dataModel.Child[indexPath.row]
                cell.model = curModel
                cell.editStatu = "2"
            }
            
            else{

                let curModel = editDataModel.Child[indexPath.row]
                cell.model = curModel
                cell.editStatu = "1"

            }
            cell.addImageblock = {() in
                
                self.takingPicture.allowsEditing = false
                self.takingPicture.delegate = self
                self.present(self.takingPicture, animated: true, completion: nil)

            }
            cell.checkTitle = {model in
                
                self.setFormView.setFromTabelView.reloadData()
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditConfirmTabelViewCell", for: indexPath) as! EditConfirmTabelViewCell
        if dataModel.Child.count == 0{
            
            cell.seletBtn.isHidden = true;
            cell.titleLabel.isHidden = true;
        }
        else{
            
            cell.seletBtn.isHidden = false;
            cell.titleLabel.isHidden = false;

        }
        
        cell.backgroundColor = .clear
        cell.block = {() in
            
            self.showshadeView()
            
        }
        cell.SaveTemplateblock = {isSelected in
            self.IsSaveTemplate = isSelected
        }
        
        return cell

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == setFormView.setFromTabelView && indexPath.row != 0 && indexPath.row != 1{
            
            let model = self.editDataModel.Child[indexPath.row]
            if model.chioceList.count == 1{
                CustomProgressHud.showError(withStatus: "Option cannot be empty!")
                return
            }
            model.isSelet = !(model.isSelet)
        }
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView == table
        {
            if indexPath.row == dataModel.Child.count || indexPath.row == 0 || indexPath.row == 1{
                return false
            }
                return true
        }
        else{
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        if tableView == table
        {
            return .delete
        }
        else{
            return .none

        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView != table{
            return 74
        }
        return 0.1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView != table{
            return 60
        }
        return 0.1

    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView != table{
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: CGFloat.screenWidth, height: 60)
            view.backgroundColor = .white
        
            let icon = UIImageView()
            icon.image = (UIImage(named: "feedback_formEdit_ic_layerSlider"))
            icon.frame = CGRect(x: (CGFloat.screenWidth-48)/2, y: 27, width: 48, height: 4)
            view.addSubview(icon)
            
            let closeBtn = UIButton()
            closeBtn.frame = CGRect(x:CGFloat.screenWidth - 24 - 15, y: 15, width: 24, height: 24)
            closeBtn.setImage(UIImage(named: "feedback_formCustomized_ic_close"), for: .normal)
            closeBtn.imageView?.contentMode = .scaleAspectFill
            closeBtn.addTarget(self, action: #selector(closeBtn(_:)), for: .touchUpInside)
            view.addSubview(closeBtn)
            
            return view
        }
        return nil
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if tableView != table{
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: CGFloat.screenWidth, height: 74)
            view.backgroundColor = .white
            let nextBtn = UIButton()
            nextBtn.frame = CGRect(x:42, y: 15, width: CGFloat.screenWidth - 84, height: 44)
            nextBtn.setTitle("Next", for: .normal)
            nextBtn.setTitleColor(.mLightBlack, for: .normal)
            nextBtn.backgroundColor = .white
            nextBtn.titleLabel?.font = UIFont.font_navigationTitle
            nextBtn.layer.cornerRadius = 4
            nextBtn.layer.masksToBounds = true
            nextBtn.layer.borderWidth = 1
            nextBtn.layer.borderColor = UIColor.mLightBlack.cgColor
            nextBtn.layer.shadowOffset = CGSize(width: 0,height: 5);
            nextBtn.layer.shadowOpacity = 1;
            nextBtn.layer.shadowRadius = 10;
            nextBtn.addTarget(self, action: #selector(nextBtn(_:)), for: .touchUpInside)
            view.addSubview(nextBtn)
            return view
        }
        return nil
    }
    @objc func closeBtn(_: UIButton) {
//            cancel()
//            self.SaveEditdataModel.Child.removeAll()
        self.hideshadeView()
    }
    @objc func nextBtn(_: UIButton) {
        self.hideshadeView()
    }
    
    func cancel (){
        for curmodel :FromChildTypeModel in self.editDataModel.Child {
            curmodel.isSelet = false
        }
        self.setFormView.setFromTabelView.reloadData()
    }
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if tableView == table
        {
            if indexPath.row == dataModel.Child.count{
                return 108
            }
            else {
            let editTypeModel = dataModel.Child[indexPath.row]
                return CGFloat(editTypeModel.height)
                 }
            
        }
        else{
            let editTypeModel = editDataModel.Child[indexPath.row]
            return CGFloat(editTypeModel.height)


        }
        

    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
            return "Delete"
        }
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
            if editingStyle == .delete {
                self.update(model: dataModel.Child[indexPath.row])
                dataModel.Child.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.bottom)
                self.setFormView.setFromTabelView.reloadData()

            }
           
        }

    
    func update(model:FromChildTypeModel){

        editDataModel.Child[Int(model.type ?? "") ?? 0] = self.creatModel( i : Int(model.type ?? "") ?? 0 )

    }
    func reloadtable(){
        self.dataModel.Child.removeAll()
        for curmodel in self.editDataModel.Child  where curmodel.isSelet==true{
            self.dataModel.Child.append(curmodel)
            self.templateModel.Child.append(curmodel.copy() as! FromChildTypeModel)
        }
        self.setFormView.setFromTabelView.reloadData()

    }
    func hideshadeView(){
        self.alertView.isHidden = true
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .transitionCurlDown, animations: {
            _ = UIApplication.shared.delegate as!AppDelegate
            self.setFormView.frame = CGRect(x: 0, y: CGFloat.screenHeight, width: CGFloat.screenWidth, height: CGFloat.screenHeight)
        }, completion: nil)
        reloadtable()
//            self.dataModel = self.SaveEditdataModel
        
        self.table.reloadData()
    }
    
    func showshadeView(){
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .transitionCurlDown, animations: {
            let delegate = UIApplication.shared.delegate as!AppDelegate
            self.setFormView.frame = delegate.window!.bounds

        }, completion: nil)
    }

}




