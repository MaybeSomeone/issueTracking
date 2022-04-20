//
//  TemplateManageVC.swift
//  FeedbackProject
//
//  Created by 梁诗鹏 on 2022/3/16.
//

import UIKit
import RealmSwift

struct ComponentMode {
    var type: String
    var title: String
    var content: String
    var dropDownList: Array<String>?
    var singleChoiceList: Array<String>?
    var multipleChoiceList: Array<String>?
}

class FormDetailVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var feedBackMode:FeedbackModel
    
    var publish: Bool
    
    let collection = CollectDataModel()
    
    var existSingle: Bool = false
    
    var existMult: Bool = false
    
    var dataSource: Array<ComponentMode> = [
//        ComponentMode(type: "Label", title: "Title"),
//        ComponentMode(type: "Textbox", title: "Comments"),
//        ComponentMode(type: "DropDown", title: "Projects", dropDownList: ["Infosys", "HSBC", "HK Jocky", "HuaWei"]),
//        ComponentMode(type: "Single", title: "Sex", singleChoiceList: ["Male", "Female", "Medum", "Test"]),
//        ComponentMode(type: "Multi", title: "Preference", multipleChoiceList: ["Dark", "Light", "Dust", "Normal"]),
//        ComponentMode(type: "RichText", title: "Advice"),
//        ComponentMode(type: "Image", title: "Pic"),
    ]
    
    let takingPicture = UIImagePickerController()
    var picker: UIPickerView = UIPickerView()
    var showPicker: Bool = false
    var selectedShowLabel: UILabel?
    var selectedRowString = ""
    
    lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    var imageView = UIImageView(image: UIImage(named: "ic_addImg64"))

    required init?(coder: NSCoder) {
        fatalError("error")
    }
    
    init(feedbackObj: FeedbackModel, publish: Bool) {
        self.feedBackMode = feedbackObj
        self.publish = publish;
        super.init(nibName: nil, bundle: nil)
        for child in feedBackMode.Child {
            var content = ""
            if (child.content != nil) {
                content = child.content!
            }
            switch child.type {
                case "0":
                let labelComponent = ComponentMode(type: "Label", title: child.title ?? "Label", content: content, dropDownList: nil, singleChoiceList: nil, multipleChoiceList: nil)
                    dataSource.append(labelComponent)
                print("labelComponent=======", labelComponent)
                break
                case "1":
                let textboxComponent = ComponentMode(type: "Textbox", title: child.title ?? "Textbox", content: content, dropDownList: nil, singleChoiceList: nil, multipleChoiceList: nil)
                    dataSource.append(textboxComponent)
                break
                case "2":
                    var singleChoiceList:[String] = []
                    for childModel in child.chioceList {
                        singleChoiceList.append(childModel.title ?? "")
                    }
                let singleComponent = ComponentMode(type: "Single", title: child.title ?? "SingleChoice", content: content, dropDownList: nil, singleChoiceList: singleChoiceList, multipleChoiceList: nil)
                    dataSource.append(singleComponent)
                    existSingle = true
                break
                case "3":
                    var multiChoiceList:[String] = []
                    for childModel in child.chioceList {
                        if (childModel.title == nil ||  childModel.title!.count > 0) {
                            multiChoiceList.append(childModel.title ?? "")
                        }
                    }
                let multiComponent = ComponentMode(type: "Multi", title: child.title ?? "Multi", content: content, dropDownList: nil, singleChoiceList: nil, multipleChoiceList: multiChoiceList)
                
                    dataSource.append(multiComponent)
                    existMult = true
                break
                case "4":
                let richTextComponent = ComponentMode(type: "RichText", title: child.title ?? "RichText", content: content, dropDownList: nil, singleChoiceList: nil, multipleChoiceList: nil)
                    dataSource.append(richTextComponent)
                break
                case "5":
                let imageComponent = ComponentMode(type: "Image", title: child.title ?? "Image", content: content, dropDownList: nil, singleChoiceList: nil, multipleChoiceList: nil)
                    dataSource.append(imageComponent)
                break
                default :
                break
            }
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableViewCell")
        tableView.allowsMultipleSelectionDuringEditing = true
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        constructThePciker()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Form Detail"
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == dataSource.count) {
            return 100
        }
        let dataOriginal = dataSource[indexPath.row]

        switch dataOriginal.type {
        case "Label":
            return 70
        case "Textbox":
            return 120
        case "DropDown":
            return 70
        case "Single":
            return CGFloat(dataOriginal.singleChoiceList!.count / 2 * 70)
        case "Multi":
            return CGFloat(dataOriginal.multipleChoiceList!.count / 2 * 70)
        case "RichText":
            return 140
        case "Image":
            return 70
        default:
            return 100
        }
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "tableViewCell")
        cell.selectionStyle = .none
        
        if (indexPath.row == dataSource.count) {
            let btn = UIButton()
            let cell = UITableViewCell()
            btn.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(btn)
            cell.separatorInset = UIEdgeInsets(top: 0,left: cell.bounds.size.width * 2,bottom: 0,right: 0 )
            btn.addTarget(self, action: #selector(submitBtnClick), for: .touchUpInside)
            btn.setTitle("Submit", for: .normal)
            btn.snp.makeConstraints { make in
                make.height.equalTo(50);
                make.width.equalTo(200);
                make.center.equalToSuperview()
            }
            btn.layer.cornerRadius = 5
            btn.backgroundColor = UIColor.navbarColor
            return cell
        }
        let dataOriginal = dataSource[indexPath.row]
        
        switch dataOriginal.type {
            case "Label":
            print("Label content value is == \(dataOriginal.content)")
            let labelComponent = LabelTableView()
            labelComponent.title = dataOriginal.title
            labelComponent.content = dataOriginal.content
            cell.contentView.addSubview(labelComponent)
            labelComponent.snp.makeConstraints { make in
                make.height.equalTo(100)
                make.edges.equalToSuperview()
            }
            if (indexPath.row == 0) {
                labelComponent.enableEdit = false
            }
            case "Textbox":
            print("Textbox content value is == \(dataOriginal.content)")
            let textBox = TextBoxTableView()
            textBox.title = dataOriginal.title
            textBox.content = dataOriginal.content
            cell.contentView.addSubview(textBox)
            textBox.snp.makeConstraints { make in
                make.height.equalTo(100)
                make.edges.equalToSuperview()
            }
            case "DropDown":
            print("DropDown content value is == \(dataOriginal.content)")
            let dropDown = DropDownTableView()
            dropDown.title = dataOriginal.title
            self.selectedShowLabel = dropDown.selectedShowLabel
            dropDown.clickShowPickButton = { () in
                self.showPickerView()
            }
            
            cell.contentView.addSubview(dropDown)
            dropDown.snp.makeConstraints { make in
                make.height.equalTo(100)
                make.edges.equalToSuperview()
            }
            case "Single":
            print("Single content value is == \(dataOriginal.content)")
            let single = SingleChoiceTableView()
            single.dataSource = dataOriginal.singleChoiceList
            single.title = "Sex"
            cell.contentView.addSubview(single)
            single.snp.makeConstraints { make in
                make.height.equalTo(100)
                make.edges.equalToSuperview()
            }
            single.selected = {(selectedItem: String) -> Void in
                self.collection.singleSelected.removeAll()
                self.collection.singleSelected.append(selectedItem)
            }
            case "Multi":
            print("Multi content value is == \(dataOriginal.content)")
            let multi = MultipleChoiceTableView()
            multi.title = "Advice"
            multi.dataSource = dataOriginal.multipleChoiceList
            cell.contentView.addSubview(multi)
            multi.snp.makeConstraints { make in
                make.height.equalTo(100)
                make.edges.equalToSuperview()
            }
            multi.selected = {(selectedItem: String) -> Void in
                self.collection.multitedSelected.append(selectedItem)
            }
            multi.unselectedBlock = {(unselectedItem: String) -> Void in
                self.collection.multitedSelected.remove(at: self.collection.multitedSelected.firstIndex(of: unselectedItem)!)
                print(self.collection.multitedSelected);
            }
            case "Image":
            let imageComponent = ImageTableView()
            self.imageView = imageComponent.imageView
            imageComponent.clickAddImageBlock = { () in
                self.takingPicture.allowsEditing = false
                self.takingPicture.delegate = self
                self.present(self.takingPicture, animated: true, completion: nil)
            }
            imageComponent.title = "Image"
            cell.contentView.addSubview(imageComponent)
            imageComponent.snp.makeConstraints { make in
                make.height.equalTo(100)
                make.edges.equalToSuperview()
            }
            case "RichText":
            let richText = RichTextTableView()
            richText.title = dataOriginal.title
            cell.contentView.addSubview(richText)
            richText.snp.makeConstraints { make in
                make.height.equalTo(100)
                make.edges.equalToSuperview()
            }
            default:
                print("it doesn't belong to any type")
        }
        
        
        return cell
    }
    
    @objc func submitBtnClick() {
        if (publish) {
            collection.ID = "100\(arc4random_uniform(100) + 1)"
            collection.FormId = feedBackMode.ID
            if (collection.singleSelected.count == 0 && existSingle) {
                return CustomProgressHud.showError(withStatus: "single selected cannot be empty!")
            }
            if (collection.multitedSelected.count == 0 && existMult) {
                return CustomProgressHud.showError(withStatus: "multiple selected cannot be empty!")
            }
            
            print(collection)
            RealmManagerTool.shareManager().addObject(object: self.collection, .publish)
        } else {
            self.showAlter(title: "Warning", message: "Current testig mode cannot submit any data", sureTit: "Publish", cancelTit: "OK") {
                self.showAlter(title: "Publish Action", message: "If set current form to publish mode, cannot edit anymore, sure??", sureTit: "Publish", cancelTit: "NO") {
                    self.saveFormModel(status: "3")
                } cancelBlock: {
                    print("do nothing");
                }
            } cancelBlock: {
                print("cancel block")
            }
        }
    }
    
    func saveFormModel(status : String){
        if self.feedBackMode.Child.count > 0{
            self.feedBackMode.status = status
            let loginModel = RealmManagerTool.shareManager().queryObjects(objectClass: LoginModel.self, .login).first
            self.feedBackMode.author = loginModel?.username
            self.feedBackMode.createDate = Calendar.current.startOfDay(for: Date())
            self.feedBackMode.ID = "100\(arc4random_uniform(100) + 1)"
            self.feedBackMode.title = self.feedBackMode.Child[0].title
            self.feedBackMode.descriptio = self.feedBackMode.Child[1].title
            RealmManagerTool.shareManager().addObject(object: self.feedBackMode, .feedback)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    // MARK: - Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            //原图
//        let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as! NSURL
//        let imageUrlString = imageUrl.absoluteString
        self.imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        takingPicture.dismiss(animated: true, completion: nil)
        
    }
    
    // MARk: - UIPicker Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return (dataSource[2].dropDownList ?? []).count
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return (dataSource[2].dropDownList ?? [])[row]
        return "test"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let text = (dataSource[2].dropDownList ?? [])[row]
        selectedRowString = text
        selectedShowLabel!.text = text
    }
    
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
    
    @objc func hidePickerView() {
       showPicker = false
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
//       UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) {
//           self.containerView.frame.origin = CGPoint(x:0, y:0)
//       } completion: { isFinish in
//           if isFinish {
//               print("show animation is finish")
//           }
//       }
   }
   
   
   @objc func confirmButtonClick() {
       showPicker = false
       picker.selectRow(0, inComponent: 0, animated: false)
       if (selectedRowString.count == 0) {
           selectedShowLabel!.text = (dataSource[2].dropDownList ?? [])[0]
       } else {
           selectedShowLabel?.text = selectedRowString
       }
       
       hidePickerView()
       selectedRowString = ""
   }
}
