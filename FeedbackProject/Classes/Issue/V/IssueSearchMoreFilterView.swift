//
//  IssueSearchMoreFilterView.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/3/2.
//

import UIKit
import Foundation

class IssueSearchMoreFilterView: UIView {

    var searchBackComplete: (([String: Any])->Void)?
    
    /// 背景图
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .lightGray
        bgView.isUserInteractionEnabled = true
        bgView.layer.cornerRadius = 10
        bgView.clipsToBounds = true
        return bgView
    }()

    private lazy var titles: [String] = {
        let titles: [String] = ["None","Werner","Tracy","Taylor","Willie"]
        return titles
    }()
    
    private lazy var closeBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.backgroundColor = .navbarColor
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(closeBtn(_:)), for: .touchUpInside)
        return button
    }()
    

    private lazy var assigneeLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = UIFont.font_commonBig18Title
        lab.text = "Assignee"
        lab.textAlignment = .center
        return lab
    }()
    
    private lazy var dropDownMenu: LMJDropdownMenu = {
        let dropDownMenu = LMJDropdownMenu()
        dropDownMenu.dataSource = self
        dropDownMenu.delegate   = self
        dropDownMenu.layer.borderColor  = UIColor.blue.cgColor
        dropDownMenu.layer.borderWidth  = 1;
        dropDownMenu.layer.cornerRadius = 3;
        dropDownMenu.title           = "None";
        dropDownMenu.titleFont       = UIFont.systemFont(ofSize: 14)
        dropDownMenu.titleColor      = .black
        dropDownMenu.rotateIcon      = UIImage(named: "arrowIcon1")!
        dropDownMenu.rotateIconSize  = CGSize(width: 15, height: 15)
        dropDownMenu.titleAlignment  = .center;
        dropDownMenu.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0);
        dropDownMenu.optionFont          = UIFont.systemFont(ofSize: 14)
        dropDownMenu.optionTextColor     = UIColor.black
        dropDownMenu.optionBgColor       = UIColor.white
        dropDownMenu.optionLineColor = UIColor.blue
        dropDownMenu.optionTextAlignment = .center
        dropDownMenu.optionNumberOfLines = 0;
        dropDownMenu.optionsList.backgroundColor = .white
        return dropDownMenu
    }()
    
    var filterDict = [String: Any]()
    

    private lazy var startDateLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = UIFont.font_commonBig18Title
        lab.text = "Start date"
        lab.textAlignment = .center
        return lab
    }()
    
    private lazy var startDateField: UITextField = {
        let startDateField = UITextField()
        startDateField.clearButtonMode = .whileEditing
        startDateField.isSecureTextEntry = false
        startDateField.keyboardType = .numbersAndPunctuation
        startDateField.textColor = UIColor.darkText
        startDateField.font = UIFont.systemFont(ofSize: 14.0)
        startDateField.placeholder = "Please select a start date"
        startDateField.textAlignment = .center
        startDateField.layer.borderColor = UIColor.blue.cgColor
        startDateField.layer.borderWidth = 1
        startDateField.tag = 1001
        startDateField.inputView = datePicker
        startDateField.addCancelDoneOnKeyboardWithTarget(self, cancelAction: #selector(datePickerCancled(_:)), doneAction: #selector(datePickerSelected(_:)), shouldShowPlaceholder: true)
        return startDateField
    }()
    
    
    private lazy var endDateLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = UIFont.font_commonBig18Title
        lab.text = "End date"
        lab.textAlignment = .center
        return lab
    }()
    
    private lazy var endDateField: UITextField = {
        let endDateField = UITextField()
        endDateField.clearButtonMode = .whileEditing
        endDateField.isSecureTextEntry = false
        endDateField.keyboardType = .numbersAndPunctuation
        endDateField.textColor = UIColor.darkText
        endDateField.font = UIFont.systemFont(ofSize: 14.0)
        endDateField.placeholder = "Please select an end date"
        endDateField.textAlignment = .center
        endDateField.layer.borderColor = UIColor.blue.cgColor
        endDateField.layer.borderWidth = 1
        endDateField.tag = 1002
        endDateField.inputView = datePicker
        endDateField.addCancelDoneOnKeyboardWithTarget(self, cancelAction: #selector(datePickerCancled(_:)), doneAction: #selector(datePickerSelected(_:)), shouldShowPlaceholder: true)
        return endDateField
    }()
    
    private lazy var datePicker: PGDatePicker = {
        let datePicker = PGDatePicker()
        datePicker.frame = CGRect(x: 0, y: 0, width: CGFloat.screenWidth, height: 216)
        datePicker.delegate = self
        //设置线条的颜色
        datePicker.lineBackgroundColor = .blue
        //设置选中行的字体颜色
        datePicker.textColorOfSelectedRow = .black
        //设置未选中行的字体颜色
        datePicker.textColorOfOtherRow = UIColor.darkGray
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = UIColor.white
        datePicker.language = "en"
        datePicker.autoSelected = true
        
        return datePicker
    }()
    
    /// 接收事件选择器的时间
    private var startDate: Date = Date()
    private var endDate: Date = Date()
    
    private lazy var searchBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Search", for: .normal)
        button.backgroundColor = .navbarColor
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(searchBtn(_:)), for: .touchUpInside)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: AppConfig.mWindow()!.bounds)
        self.backgroundColor = .clear
        addSubviews()
    }
    
    func addSubviews() {
        
        addSubview(bgView)
        
        bgView.addSubviews([closeBtn, assigneeLabel, dropDownMenu, startDateLabel, startDateField, endDateLabel, endDateField, searchBtn])
        
    }
    
    @objc func searchBtn(_ sender: UIButton) {
        filterDict["startDate"] = startDate
        filterDict["endDate"] = endDate
        dismiss()
        
        searchBackComplete?(filterDict)
    }
    
    @objc func closeBtn(_ sender: UIButton) {
      dismiss()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-80 - CGFloat.bottomHeight() - CGFloat.naviHeight())
        }
        
        closeBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(60)
            make.height.equalTo(35)
        }
        
        startDateLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }

        startDateField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.left.equalTo(startDateLabel.snp.right).offset(20)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(40)
        }

        endDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(startDateLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }

        endDateField.snp.makeConstraints { (make) in
            make.top.equalTo(startDateField.snp.bottom).offset(20)
            make.left.equalTo(startDateField.snp.left)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(40)
        }
        
        assigneeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(endDateLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
        
        dropDownMenu.frame = CGRect.init(x: 15 + 120 + 20,  y: 100 + 40 + 20 + 40 + 20, width: CGFloat.screenWidth - 170 - 40,  height: 40)
        bringSubviewToFront(dropDownMenu)
        
        searchBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(bgView.snp.bottom).offset(-40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
    }

    func show(form: UIView) {
        UIView.animate(withDuration: 0.24, animations: {
            form.addSubview(self)
            form.bringSubviewToFront(self)
        }, completion: nil)
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.24, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
        }) { (Bool) -> Void in
            self.alpha = 0.0
            self.removeFromSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension IssueSearchMoreFilterView: PGDatePickerDelegate {
    
    @objc private func datePickerSelected(_ item: IQBarButtonItem) {
        
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd"
        if startDateField.isEditing {
            startDateField.text = dformatter.string(from: startDate)
        }
        if endDateField.isEditing {
            endDateField.text = dformatter.string(from: endDate)
        }
        startDateField.resignFirstResponder()
        endDateField.resignFirstResponder()
    }
    @objc private func datePickerCancled(_ item: IQBarButtonItem) {
        startDateField.resignFirstResponder()
        endDateField.resignFirstResponder()
    }
    
    func datePicker(_ datePicker: PGDatePicker!, didSelectDate dateComponents: DateComponents!) {
        if let _date = Calendar.current.date(from: dateComponents) {
            if startDateField.isEditing {
                startDate = _date
            }
            if endDateField.isEditing {
                endDate = _date
            }
        }
    }
}

// MARK: -  LMJDropdownMenuDelegate, LMJDropdownMenuDataSource
extension IssueSearchMoreFilterView: LMJDropdownMenuDelegate, LMJDropdownMenuDataSource {
    
    func numberOfOptions(in menu: LMJDropdownMenu) -> UInt {
        return UInt(titles.count)
    }
    func dropdownMenu(_ menu: LMJDropdownMenu, heightForOptionAt index: UInt) -> CGFloat {
        return 35
    }
    func dropdownMenu(_ menu: LMJDropdownMenu, titleForOptionAt index: UInt) -> String {
        return titles[Int(index)]
    }
    func dropdownMenu(_ menu: LMJDropdownMenu, didSelectOptionAt index: UInt, optionTitle title: String) {
        filterDict["assignee"] = title
    }

}
