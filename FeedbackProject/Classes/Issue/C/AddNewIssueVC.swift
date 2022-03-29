//
//  ViewController.swift
//  IssueTracking
//
//  Created by 梁诗鹏 on 2022/2/25.
//

import UIKit
import RealmSwift
import Photos
import SwiftUI

let scrollviewBackColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)

let lineColor = UIColor.rgb(234.0, G: 234.0, B: 234.0)
let normalBackColor = UIColor.rgb(230.0, G: 230.0, B: 230.0)
let issueBackColor = UIColor.rgb(230.0, G: 230.0, B: 230.0)

let labelFont = UIFont(name: "苹方-简 常规体", size: 34)
let labelColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)

let textfieldColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
let textfieldFont = UIFont(name: "苹方-简 常规体", size: 34)


let categoryDataSource = (type: "category", dataSource: ["Finance", "Sales", "Human resource"])
let priorityDataSource = (type: "priority", dataSource: ["Critical", "High", "Medium", "Low"])
let issueTypeDataSource = (type: "issueType", dataSource: ["Feature", "Task", "Bug"])
let statusDataSource = (type: "status", dataSource: ["Open", "Medium", "High", "Critical"])
let assigneeDataSource = (type: "assignee", dataSource: ["Low", "Medium", "High", "Critical"])

struct RequestMode {
    var issueId: String
    var title: String
    var category: String
    var priority: String
    var issueType: String
    var status: String
    var assignee: String
    var descript: String
    var snapImage: String
    var comments: String
    var reproStep: String
//    index
    var categoryIndex: String
    var priorityIndex: String
    var issueTypeIndex: String
    var statusIndex: String
    var assigneeIndex: String
}

class AddNewIssueVC: BaseViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    var issueMode: IssueModel? {
        didSet {
            let localRequestMode = RequestMode(
                                            issueId: issueMode?.ID ?? "",
                                            title: issueMode?.title ?? "",
                                            category: issueMode?.category ?? "",
                                            priority: issueMode?.priority ?? "",
                                            issueType: issueMode?.type ?? "",
                                            status: issueMode?.status ?? "",
                                            assignee: issueMode?.assignee ?? "",
                                            descript: issueMode?.descriptio ?? "",
                                            snapImage: issueMode?.snpImage ?? "",
                                            comments: issueMode?.comments ?? "",
                                            reproStep: issueMode?.repro ?? "",
                                            categoryIndex: issueMode?.category ?? "",
                                            priorityIndex: issueMode?.priority ?? "",
                                            issueTypeIndex: "0",
                                            statusIndex: "0",
                                            assigneeIndex: "0")
            fillAndDefineRequestMode(requestModeOut: localRequestMode)
        }
    }
    var isAddNewRecord: Bool = false
    var showPicker = false
    let scrollviewContent = UIScrollView()
    let takingPicture = UIImagePickerController()
    let snapShotImage = UIImageView()

    var requestMode: RequestMode = RequestMode(
                                                issueId: "",
                                                title: "",
                                                category: "",
                                                priority: "",
                                                issueType: "",
                                                status: "",
                                                assignee: "",
                                                descript: "",
                                                snapImage: "",
                                                comments: "",
                                                reproStep: "",
                                                categoryIndex: "",
                                                priorityIndex: "",
                                                issueTypeIndex: "",
                                                statusIndex: "",
                                                assigneeIndex: "")
    var data = categoryDataSource
    var currentType = "category"
    
    lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    var selectedRowString = ""
    var picker: UIPickerView = UIPickerView()
    
    lazy var issueIdShowLabel: UILabel = {
       let label = UILabel()
        return label
    }()
    
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    lazy var categoryShowLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var priorityShowLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var issueTypeShowLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var statusShowLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var assigneeShowLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var desTextView: UITextView = {
        let textView = UITextView()
        return textView
    }()
    
    lazy var reproTextView:
    UITextView = {
        let textView = UITextView()
        return textView
    } ()
    
    lazy var commentsTextView: UITextView = {
        let textView = UITextView()
        return textView
    } ()
    
    var addNewIssueComplete: ((IssueModel)->Void)?
    
    // MARK:  -  initialize method

    required init?(coder: NSCoder) {
        fatalError("error")
    }
    
    init(isCreateNew: Bool) {
        super.init(nibName: nil, bundle: nil)
        isAddNewRecord = isCreateNew
        configureScrollview()
        constructThePciker()
//       configureUI()
    }
    
    func fillAndDefineRequestMode(requestModeOut: RequestMode) {
        requestMode = requestModeOut
        titleTextField.text = requestMode.title
        issueIdShowLabel.text = requestMode.issueId
        
         
        categoryShowLabel.text = categoryDataSource.dataSource[Int(requestMode.status) ?? 0]
        
        
        categoryShowLabel.text = categoryDataSource.dataSource[Int(requestMode.category) ?? 0]
        priorityShowLabel.text = priorityDataSource.dataSource[Int(requestMode.priority) ?? 0]
        issueTypeShowLabel.text = issueTypeDataSource.dataSource[Int(requestMode.issueType) ?? 0]
        assigneeShowLabel.text = assigneeDataSource.dataSource[Int(requestMode.assignee) ?? 0]
        statusShowLabel.text = statusDataSource.dataSource[Int(requestMode.status) ?? 0]
        
        desTextView.text = requestMode.descript
        //            snapShotImage.image = UIImage(data: Data(contentsOf: URL(fileURLWithPath: requestMode.snapImage)))
        reproTextView.text = requestMode.reproStep
        commentsTextView.text = requestMode.comments
        let imageUrl = NSHomeDirectory() + "/Documents/\(requestMode.issueId).png"
        let getImg = UIImage(contentsOfFile: imageUrl)
        if (getImg != nil) {
            snapShotImage.image = getImg
        }
        
    }

    // MARK:  -  Lifecycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the scrollviewContent.
        if (isAddNewRecord) {
            navigationItem.title = "Create"
        } else {
            navigationItem.title = "Detail\\Update"
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false

    }
    
    // MARK: - Configure UI method
    func configureScrollview() {
        view.addSubview(scrollviewContent)
        scrollviewContent.delegate = self
        scrollviewContent.backgroundColor = scrollviewBackColor
        scrollviewContent.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height * 2)
        scrollviewContent.isScrollEnabled = true
        scrollviewContent.bounces = true
        scrollviewContent.alwaysBounceVertical = true
        scrollviewContent.showsVerticalScrollIndicator = false
        scrollviewContent.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        configureUI()
    }
    
    func configureUI() {
        let issueView = UIView()
        let titleView = UIView()
        let categoryView = UIView()
        let priorityView = UIView()
        let issueTypeView = UIView()
        let statusView = UIView()
        let assigneeView = UIView()
        let descriptionView = UIView()
        let snpImageView = UIView()
        let reproStepView = UIView()
        let commnetView = UIView()
        
        titleView.backgroundColor = UIColor.white
        categoryView.backgroundColor = UIColor.white
        priorityView.backgroundColor = UIColor.white
        issueTypeView.backgroundColor = UIColor.white
        statusView.backgroundColor = UIColor.white
        assigneeView.backgroundColor = UIColor.white
        descriptionView.backgroundColor = UIColor.white
        snpImageView.backgroundColor = UIColor.white
        reproStepView.backgroundColor = UIColor.white
        commnetView.backgroundColor = UIColor.white
        
        issueView.translatesAutoresizingMaskIntoConstraints = false
        titleView.translatesAutoresizingMaskIntoConstraints =  false
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        priorityView.translatesAutoresizingMaskIntoConstraints =  false
        issueTypeView.translatesAutoresizingMaskIntoConstraints =  false
        statusView.translatesAutoresizingMaskIntoConstraints =  false
        assigneeView.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        snpImageView.translatesAutoresizingMaskIntoConstraints =  false
        reproStepView.translatesAutoresizingMaskIntoConstraints = false
        commnetView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollviewContent.addSubviews([issueView,
                                       titleView,
                                       categoryView,
                                       priorityView,
                                       issueTypeView,
                                       statusView,
                                       assigneeView,
                                       descriptionView,
                                       snpImageView,
                                       reproStepView,
                                       commnetView])
        
        issueView.snp.makeConstraints { make in
            make.top.equalTo(scrollviewContent)
            make.leading.trailing.equalTo(self.view)
            make.height.equalTo(40)
        }
        
        titleView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(issueView.snp.bottom)
            make.height.equalTo(60)
        }

        categoryView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(titleView.snp.bottom)
            make.height.equalTo(60)
        }
        
        priorityView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(categoryView.snp.bottom)
            make.height.equalTo(60)
        }

        issueTypeView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(priorityView.snp.bottom)
            make.height.equalTo(60)
        }
        
        statusView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(issueTypeView.snp.bottom)
            make.height.equalTo(60)
        }

        assigneeView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(statusView.snp.bottom)
            make.height.equalTo(60)
        }

        descriptionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(assigneeView.snp.bottom)
            make.height.equalTo(100)
        }
        
        snpImageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(descriptionView.snp.bottom)
            make.height.equalTo(80)
        }
        
        reproStepView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(snpImageView.snp.bottom)
            make.height.equalTo(100)
        }
        
        commnetView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(reproStepView.snp.bottom)
            make.height.equalTo(100)
        }
       
        //MARK: - Issue view label
        constructIssueIdView(superView: issueView)
        //MARK: - Title view label
        constructTitleTextfield(superView: titleView, selectMethod: "clickTheTitleButton", labelText: "Title")
        // MARK: - Categoty view label
        constructTextfield(superView: categoryView, selectMethod: "clickTheCategoryButton", labelText: "Category", showLabel: categoryShowLabel)
        // MARK: - Priority view label
        constructTextfield(superView: priorityView, selectMethod: "clickThePriorityButton", labelText: "Priority", showLabel: priorityShowLabel)
        // MARK: - Issue Type view label
        constructTextfield(superView: issueTypeView, selectMethod: "clickTheIssueTypeButton", labelText: "Issue Type", showLabel: issueTypeShowLabel)
        // MARK: - Status view label
        constructTextfield(superView: statusView, selectMethod: "clickTheStatusButton", labelText: "Status", showLabel: statusShowLabel)
        // MARK: - Assignee view label
        constructTextfield(superView: assigneeView, selectMethod: "clickTheAssigneeButton", labelText: "Assignee", showLabel: assigneeShowLabel)
        // MARK: - Descriiption Text View
        constructTextview(superView: descriptionView, labelText: "Description", textView:  desTextView)
        // MARK: - Snpimage view
        constructSnpImage(superView: snpImageView)
        // MARK: - Repro step view
        constructTextview(superView: reproStepView, labelText: "Repro Step", textView: reproTextView)
        // MARK: - Comments view
        constructTextview(superView: commnetView, labelText: "Comments", textView: commentsTextView)
        // MARK: - Add the Create / Update Button
        
        let creatButton = UIButton(type: .custom)
        scrollviewContent.addSubview(creatButton)
        creatButton.translatesAutoresizingMaskIntoConstraints = false
        if (isAddNewRecord) {
            creatButton.setTitle("Create", for: .normal)
        } else {
            creatButton.setTitle("Update", for: .normal)
        }
        
        creatButton.titleLabel?.font = (UIFont(name: "苹方-简 常规体", size: 34))
        creatButton.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        creatButton.backgroundColor = UIColor(red: 0, green: 0.43, blue: 0.89, alpha: 1)
        creatButton.addTarget(self, action: #selector(clickCreatButton), for: .touchUpInside)
        creatButton.layer.cornerRadius = 5
        creatButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalTo(commnetView.snp.bottom).offset(20)
            make.width.equalTo(280)
            make.height.equalTo(60)
            make.bottom.equalTo(scrollviewContent.snp.bottom).offset(-100)
        }
        
    }

    func constructIssueIdView(superView: UIView) {
        let issueIdLable = UILabel()
        let issueLine = UIView()
        
        issueIdLable.translatesAutoresizingMaskIntoConstraints = false
        issueIdShowLabel.translatesAutoresizingMaskIntoConstraints = false
        issueLine.translatesAutoresizingMaskIntoConstraints = false

        issueIdLable.text = "issue ID:"
        let issueIdString = "100\(arc4random_uniform(100) + 1)"
        issueIdShowLabel.text = issueIdString
        requestMode.issueId = issueIdString
        
        issueIdLable.font = UIFont.init(name: "Helvetica", size: 16)
        issueIdShowLabel.font = UIFont.init(name: "Helvetica", size: 16)

        superView.addSubviews([issueIdShowLabel, issueIdLable, issueLine])

        superView.backgroundColor = UIColor.rgb(230, G: 230, B: 230)
        issueLine.backgroundColor = lineColor

        issueIdLable.snp.makeConstraints { make in
            make.centerY.equalTo(superView)
            make.leading.equalTo(superView).offset(20)
        }

        issueIdShowLabel.snp.makeConstraints { make in
            make.leading.equalTo(issueIdLable.snp.trailing)
            make.centerY.equalTo(issueIdLable)
        }

        issueLine.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalTo(superView)
            make.bottom.equalTo(superView)
        }
    }
    
    func constructTitleTextfield(superView: UIView, selectMethod: String, labelText: String) {
        let label = UILabel()
        label.text = labelText
        label.font = labelFont
        label.textColor = labelColor
        
        titleTextField.delegate = self
        titleTextField.borderStyle = .none
        titleTextField.font = textfieldFont
        titleTextField.textColor = textfieldColor
        
        let line = UIView()
        line.backgroundColor = lineColor
        
        superView.addSubviews([label, titleTextField, line])
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(superView).offset(20)
            make.centerY.equalTo(superView)
            make.width.equalTo(90)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.leading.equalTo(label.snp.trailing).offset(1)
            make.height.equalTo(superView)
            make.centerY.equalTo(superView)
            make.trailing.equalTo(self.view.snp.trailing).offset(-10)
        }
        
        line.snp.makeConstraints { make in
            make.leading.equalTo(self.view).offset(40)
            make.bottom.equalTo(superView.snp.bottom)
            make.trailing.equalTo(superView)
            make.height.equalTo(1)
        }
    }
    
    func constructTextfield(superView: UIView, selectMethod: String, labelText: String, showLabel: UILabel) {
        let label = UILabel()
        label.text = labelText
        label.font = labelFont
        label.textColor = labelColor
        
        showLabel.font = textfieldFont
        showLabel.textColor = textfieldColor
        
        let line = UIView()
        line.backgroundColor = lineColor
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow_down"), for: .normal)
        button.contentMode = .center
        button.addTarget(self, action: Selector(selectMethod), for: .touchUpInside)
        
        superView.addSubviews([label, showLabel, button, line])
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(superView).offset(20)
            make.centerY.equalTo(superView)
            make.width.equalTo(90)
        }
        
        showLabel.snp.makeConstraints { make in
            make.leading.equalTo(label.snp.trailing).offset(1)
            make.height.equalTo(superView)
            make.centerY.equalTo(superView)
            make.trailing.equalTo(button.snp.leading).offset(-10)
        }
        
        button.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(40)
            make.trailing.equalTo(self.view).offset(-20)
            make.centerY.equalTo(superView)
        }
        
        line.snp.makeConstraints { make in
            make.leading.equalTo(self.view).offset(40)
            make.bottom.equalTo(superView.snp.bottom)
            make.trailing.equalTo(superView)
            make.height.equalTo(1)
        }
    }
    
    func constructTextview(superView: UIView, labelText: String, textView: UITextView) {
        let label = UILabel()
        label.text = labelText
        label.font = labelFont
        
        textView.font = labelFont
        textView.textColor = labelColor
        textView.delegate = self
        
        let line = UIView()
        line.backgroundColor = lineColor
        
        
        superView.addSubviews([label, textView, line])
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(superView).offset(20)
            make.top.equalTo(superView).offset(10)
            make.width.equalTo(90)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(label).offset(-5)
            make.leading.equalTo(label.snp.trailing).offset(20)
            make.trailing.equalTo(self.view).offset(-20)
            make.bottom.equalTo(superView.snp.bottom).offset(-5)
        }
        
        line.snp.makeConstraints { make in
            make.leading.equalTo(self.view).offset(40)
            make.bottom.equalTo(superView.snp.bottom)
            make.trailing.equalTo(superView)
            make.height.equalTo(1)
        }
    }
    
    
    func constructSnpImage(superView: UIView) {
        let label = UILabel()
        label.font = labelFont
        label.textColor = labelColor
        label.text = "Snapshot/File"
        
        snapShotImage.contentMode = .scaleAspectFit
        
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(clickAddImageButton), for: .touchUpInside)
        
        let line = UIView()
        line.backgroundColor = lineColor
        
        superView.addSubviews([label, snapShotImage, button, line])
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(superView).offset(20)
            make.centerY.equalTo(superView)
        }
        
        snapShotImage.image = UIImage(named: "ic_addImg64")
        
        snapShotImage.snp.makeConstraints { make in
            make.centerY.equalTo(superView)
            make.leading.equalTo(label.snp.trailing).offset(20)
            make.height.width.equalTo(50)
        }
        
        line.snp.makeConstraints { make in
            make.leading.equalTo(self.view).offset(40)
            make.bottom.equalTo(superView.snp.bottom)
            make.trailing.equalTo(superView)
            make.height.equalTo(1)
        }
        
        button.snp.makeConstraints { make in
            make.edges.equalTo(snapShotImage)
        }
    }
    
    // MARK: - Button click method set
    @objc func clickTheTitleButton() {
        showPicker = !showPicker
//        dataSource =
//        if (showPicker) {
//            showPickerView()
//        } else {
//            hidePickerView()
//        }
    }
    
    @objc func clickTheCategoryButton() {
        showPicker = !showPicker
        data = categoryDataSource
        picker.reloadAllComponents()
        if (showPicker) {
            showPickerView()
        } else {
            hidePickerView()
        }
    }
    
    @objc func clickThePriorityButton() {
        showPicker = !showPicker
        data = priorityDataSource
        picker.reloadAllComponents()
        if (showPicker) {
            showPickerView()
        } else {
            hidePickerView()
        }
    }
    
    @objc func clickTheIssueTypeButton() {
        showPicker = !showPicker
        data = issueTypeDataSource
        picker.reloadAllComponents()
        if (showPicker) {
            showPickerView()
        } else {
            hidePickerView()
        }
    }
    
    @objc func clickTheStatusButton() {
        showPicker = !showPicker
        data = statusDataSource
        picker.reloadAllComponents()
        if (showPicker) {
            showPickerView()
        } else {
            hidePickerView()
        }
    }
    
    @objc func clickTheAssigneeButton() {
        showPicker = !showPicker
        data = assigneeDataSource
        picker.reloadAllComponents()
        if (showPicker) {
            showPickerView()
        } else {
            hidePickerView()
        }
    }
    
    @objc func clickAddImageButton() {
        takingPicture.allowsEditing = false
        takingPicture.delegate = self
        present(takingPicture, animated: true, completion: nil)
    }
    
    @objc func clickCreatButton() {
        
        if (requestMode.title.count == 0) {
            return CustomProgressHud.showError(withStatus: "title cannot be empty!")
        }
        
        if (requestMode.categoryIndex.count == 0) {
            return CustomProgressHud.showError(withStatus: "category cannot be empty!")
        }
        
        if (requestMode.priorityIndex.count == 0) {
            return CustomProgressHud.showError(withStatus: "priority cannot be empty!")
        }
        
        if (requestMode.issueTypeIndex.count == 0) {
            return CustomProgressHud.showError(withStatus: "issue type cannot be empty!")
        }
        
        if (requestMode.statusIndex.count == 0) {
            return CustomProgressHud.showError(withStatus: "status cannot be empty!")
        }
        
        if (requestMode.assigneeIndex.count == 0) {
            return CustomProgressHud.showError(withStatus: "assignee cannot be empty!")
        }
        
        if (desTextView.text.count == 0) {
            return CustomProgressHud.showError(withStatus: "description cannot be empty!")
        }
        
        if (reproTextView.text.count == 0) {
            return CustomProgressHud.showError(withStatus: "repro step cannot be empty!")
        }
        
        if (commentsTextView.text.count == 0) {
            return CustomProgressHud.showError(withStatus: "comments cannot be empty!")
        }
        let loginModel = RealmManagerTool.shareManager().queryObjects(objectClass: LoginModel.self, .login).first
        
        let model = IssueModel()
        model.ID = requestMode.issueId
        model.title = requestMode.title
        model.category = requestMode.categoryIndex
        model.priority = requestMode.priorityIndex
        model.type = requestMode.issueTypeIndex
        model.status = requestMode.statusIndex
        model.assignee = requestMode.assigneeIndex
        model.comments = commentsTextView.text
        model.repro = reproTextView.text
        model.descriptio = desTextView.text
        model.createDate = Date()
        model.author = loginModel?.username
        model.snpImage = requestMode.snapImage
        
        if (isAddNewRecord) {
            RealmManagerTool.shareManager().addObject(object: model, .issue)
            addNewIssueComplete?(model)
        } else {
//            Update the history record
            RealmManagerTool.shareManager().updateObject(object: model, .issue)
        }
        
        
        self.navigationController?.popViewController(animated: true)
    }

    
// MARK: - Common method
     @objc func hidePickerView() {
        showPicker = false
         selectedRowString=""
        picker.selectRow(0, inComponent: 0, animated: false)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) {
            self.containerView.frame.origin = CGPoint(x:0, y:self.view.frame.height)
        } completion: { isFinish in
            if isFinish {
                print("hide animation is finish")
            }
        }
    }
    
    @objc func showPickerView() {
        showPicker = true
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) {
            self.containerView.frame.origin = CGPoint(x:0, y:0)
        } completion: { isFinish in
            if isFinish {
                print("show animation is finish")
            }
        }
    }
    
    
    @objc func confirmButtonClick() {
        showPicker = false
        picker.selectRow(0, inComponent: 0, animated: false)
        if (selectedRowString.count == 0) {
            switch data.type {
                case "category":
                    requestMode.category = "Finance"
                    requestMode.categoryIndex = "0"
                    categoryShowLabel.text = "Finance"
                case "priority":
                    requestMode.priority = "Critical"
                    requestMode.priorityIndex = "0"
                    priorityShowLabel.text = "Critical"
                case "issueType":
                    requestMode.issueType = "Feature"
                    requestMode.issueTypeIndex = "0"
                    issueTypeShowLabel.text = "Feature"
                case "status":
                    requestMode.status = "Open"
                    requestMode.statusIndex = "0"
                    statusShowLabel.text = "Open"
                case "assignee":
                    requestMode.assignee = "Low"
                    requestMode.assigneeIndex = "0"
                    assigneeShowLabel.text = "Low"
                default:
                    print("nothing")
            }
        }
        selectedRowString=""
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) {
            self.containerView.frame.origin = CGPoint(x: 0, y: self.view.frame.height)
        } completion: { isFinish in
            if isFinish {
                print("animation is finish")
            }
        }
    }
    
    // MARK: - Contruct the picker
    func constructThePciker() {
//        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
//        containerView.snp.makeConstraints { make in
//            make.top.equalTo(view).offset(self.view.frame.height)
//            make.leading.equalTo(view.snp.leading)
//            make.width.equalTo(view)
//            make.height.equalTo(view)
//        }
        containerView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.size.width, height: view.frame.size.height)
        
        let containerButton = UIButton()
        containerView.addSubview(containerButton)
        containerButton.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalTo(containerView)
        }
        containerButton.addTarget(self, action: #selector(containerButtonClick), for: .touchUpInside)
        containerView.addSubview(containerButton)
        containerView.addSubview(picker)
        picker.dataSource = self
        picker.delegate = self
        picker.backgroundColor = UIColor.white
        picker.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self.containerView)
            make.height.equalTo(275)
        }
        
        let pickerTopView = UIView()
        containerView.addSubview(pickerTopView)
        pickerTopView.backgroundColor = UIColor.lightGray
        pickerTopView.translatesAutoresizingMaskIntoConstraints = false
        pickerTopView.snp.makeConstraints { make in
            make.bottom.equalTo(picker.snp.top)
            make.leading.equalTo(picker)
            make.height.equalTo(40)
            make.width.equalTo(picker)
        }
        
        let cancelButton = UIButton(type: .custom)
        let confirmButton = UIButton(type: .custom)
        confirmButton.frame.size = CGSize(width: 50, height: 50)
        cancelButton.frame.size = CGSize(width: 50, height: 50)
        pickerTopView.addSubview(cancelButton)
        pickerTopView.addSubview(confirmButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        cancelButton.setTitle("Cancel", for: .normal)
        confirmButton.setTitle("Confirm", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cancelButton.snp.makeConstraints { make in
            make.leading.equalTo(pickerTopView).offset(20)
            make.centerY.equalTo(pickerTopView)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.trailing.equalTo(pickerTopView).offset(-20)
            make.centerY.equalTo(pickerTopView)
        }
        
        cancelButton.addTarget(self, action: #selector(hidePickerView), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmButtonClick), for: .touchUpInside)
    }
    
    @objc func containerButtonClick() {
        hidePickerView()
    }
    
    
    // MARK: - Picker view delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let dataSource = data.dataSource
        return dataSource.count
    }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let dataSource = data.dataSource
        return dataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let dataSource = data.dataSource
        selectedRowString = dataSource[row]
        switch data.type {
            case "category":
                requestMode.category = selectedRowString
                requestMode.categoryIndex = "\(row)"
                categoryShowLabel.text = selectedRowString
            case "priority":
                requestMode.priority = selectedRowString
                requestMode.priorityIndex = "\(row)"
                priorityShowLabel.text = selectedRowString
            case "issueType":
                requestMode.issueType = selectedRowString
                requestMode.issueTypeIndex = "\(row)"
                issueTypeShowLabel.text = selectedRowString
            case "status":
                requestMode.status = selectedRowString
                requestMode.statusIndex = "\(row)"
                statusShowLabel.text = selectedRowString
            case "assignee":
                requestMode.assignee = selectedRowString
                requestMode.assigneeIndex = "\(row)"
                assigneeShowLabel.text = selectedRowString
            default:
                print("nothing")
        }
         
    }
    
    // MARK: - UITextView delegate
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView == desTextView) {
            requestMode.descript = textView.text
        }
        if (textView == reproTextView) {
            requestMode.reproStep = textView.text
        }
        if (textView == commentsTextView) {
            requestMode.comments = textView.text
        }
    }
    
    // MARK: - UITextField delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        requestMode.title = textField.text ?? ""
    }
    
    // MARK: - Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //原图
        print("selected image finish")
        snapShotImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        let path = NSHomeDirectory() + "/Documents/\(requestMode.issueId).png"
        requestMode.snapImage = path
        do {
            try snapShotImage.image?.pngData()?.write(to: URL(fileURLWithPath: path))
        }catch {
                    
        }
        takingPicture.dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: - ScrrollView delegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    // MARK: - Touch delegate
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
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
}
