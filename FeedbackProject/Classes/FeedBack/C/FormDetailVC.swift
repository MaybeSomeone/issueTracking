//
//  TemplateManageVC.swift
//  FeedbackProject
//
//  Created by 梁诗鹏 on 2022/3/16.
//

import UIKit

struct ComponentMode {
    var type: String
    var title: String
    var dropDownList: Array<String>?
    var singleChoiceList: Array<String>?
    var multipleChoiceList: Array<String>?
}

var dataSource: Array<ComponentMode> = [
    ComponentMode(type: "Label", title: "Title"),
    ComponentMode(type: "Textbox", title: "Comments"),
    ComponentMode(type: "DropDown", title: "Projects", dropDownList: ["Infosys", "HSBC", "HK Jocky", "HuaWei"]),
    ComponentMode(type: "Single", title: "Sex", singleChoiceList: ["Male", "Female", "Medum", "Test"]),
    ComponentMode(type: "Multi", title: "Preference", multipleChoiceList: ["Dark", "Light", "Dust", "Normal"]),
    ComponentMode(type: "RichText", title: "Advice"),
    ComponentMode(type: "Image", title: "Pic"),
]

class FormDetailVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
        let dataOriginal = dataSource[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: "tableViewCell")
        cell.selectionStyle = .none
        
        switch dataOriginal.type {
            case "Label":
            let labelComponent = LabelTableView()
            labelComponent.title = "Title"
            cell.contentView.addSubview(labelComponent)
            labelComponent.snp.makeConstraints { make in
                make.height.equalTo(100)
                make.edges.equalToSuperview()
            }
            
            case "Textbox":
            let textBox = TextBoxTableView()
            textBox.title = "Description"
            cell.contentView.addSubview(textBox)
            textBox.snp.makeConstraints { make in
                make.height.equalTo(100)
                make.edges.equalToSuperview()
            }
            case "DropDown":
            let dropDown = DropDownTableView()
            dropDown.title = "Projects"
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
            let single = SingleChoiceTableView()
            single.dataSource = dataOriginal.singleChoiceList
            single.title = "Sex"
            cell.contentView.addSubview(single)
            single.snp.makeConstraints { make in
                make.height.equalTo(100)
                make.edges.equalToSuperview()
            }
            case "Multi":
            let multi = MultipleChoiceTableView()
            multi.title = "Advice"
            multi.dataSource = dataOriginal.multipleChoiceList
            cell.contentView.addSubview(multi)
            multi.snp.makeConstraints { make in
                make.height.equalTo(100)
                make.edges.equalToSuperview()
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
        return (dataSource[2].dropDownList ?? []).count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (dataSource[2].dropDownList ?? [])[row]
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
           selectedShowLabel!.text = (dataSource[2].dropDownList ?? [])[0]
       } else {
           selectedShowLabel?.text = selectedRowString
       }
       
       hidePickerView()
       selectedRowString = ""
   }
}
