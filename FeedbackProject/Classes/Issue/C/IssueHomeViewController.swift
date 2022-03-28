//
//  IssueHomeViewController.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/3/8.
//

import UIKit
import WMPageController

class IssueHomeViewController: WMPageController {
    
    let issueVC = IssueViewController()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.selectIndex = 0
        self.showOnNavigationBar = true
        self.titleSizeNormal = 16;
        self.progressColor = UIColor.init(hex: "#C0DEFF")
        self.titleColorNormal = UIColor.init(hex: "#C0DEFF")
        self.titleColorSelected = UIColor.init(hex: "#FFFFFF")
        self.automaticallyCalculatesItemWidths = true
        self.menuViewLayoutMode = .center
        self.menuViewStyle = .line
        self.scrollEnable = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 16))
        imageView.image = UIImage(named: "logo_infosys")
        let barButtonItem = UIBarButtonItem(customView: imageView)
        navigationItem.leftBarButtonItem = barButtonItem
        
        configureAddNewIssueButton()
    }
    
    func configureAddNewIssueButton() {
        let addButton = UIButton(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        addButton.setImage(UIImage(named: "ic_add"), for: .normal)
        addButton.addTarget(self, action: #selector(tapAddButton), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc func tapAddButton() {
        
        let addNewIssueVC = AddNewIssueVC(isCreateNew: true)
        addNewIssueVC.hidesBottomBarWhenPushed = true
        addNewIssueVC.addNewIssueComplete = {[weak self] newModel in
            guard let weakself = self else { return }
            print(newModel)
            
            weakself.issueVC.dataArr.removeAll()
            let data = RealmManagerTool.shareManager().queryObjects(objectClass: IssueModel.self, .issue)
            for model in data.reversed() {
                weakself.issueVC.dataArr.append(model)
            }
            weakself.issueVC.tableView.reloadData()
        }
        navigationController?.pushViewController(addNewIssueVC, animated: true)
    }
}

extension IssueHomeViewController {
    
    override func menuView(_ menu: WMMenuView!, widthForItemAt index: Int) -> CGFloat {
        let width = super.menuView(menu, widthForItemAt: index)
        return width + 20
    }
    
    override func numbersOfChildControllers(in inpageController: WMPageController) -> Int {
        return 2
    }
    
    override func pageController(_ pageController: WMPageController, titleAt index: Int) -> String {
        return ["Issue traking","Report"][index]
    }
    
    override func pageController(_ pageController: WMPageController, viewControllerAt index: Int) -> UIViewController {
        switch index {
        case 0 :
            return issueVC
        case 1 :
            return IssueReportViewController()
        default:
            return IssueViewController()
        }
    }
    
    override func pageController(_ pageController: WMPageController, preferredFrameFor menuView: WMMenuView) -> CGRect {
        return CGRect(x: 50, y: 0, width: CGFloat.screenWidth - 100, height: 44)
    }
    
    override func pageController(_ pageController: WMPageController, preferredFrameForContentView contentView: WMScrollView) -> CGRect {
        return CGRect(x: 0, y: 0, width: CGFloat.screenWidth, height: CGFloat.screenHeight)
    }
}
