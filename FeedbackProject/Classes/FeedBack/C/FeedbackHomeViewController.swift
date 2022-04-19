//
//  FeedbackHomeViewController.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/4/18.
//

import UIKit
import WMPageController

class FeedbackHomeViewController: WMPageController {

    let feedbackVC = FeedbackViewController()
    
    ///弹出菜单
    lazy var mlmenuView: MLMenuView = {
        let menuView = MLMenuView(frame: CGRect(x: CGFloat.screenWidth - 234 - 10, y: 0, width: 234, height: 44*4),
                                  withTitles: ["Create Blank Form",
//                                               "Copy Existing Form",
                                               "Create by Template",
                                               "Template Management"],
                                  withImageNames: ["ic_blankForm",
//                                                   "ic_copyForm",
                                                   "ic_byTemplate",
                                                   "ic_templateMgmt"],
                                  withMenuViewOffsetTop: CGFloat.naviHeight(),
                                  withTriangleOffsetLeft: 216)
        menuView?.setCoverBackgroundColor(UIColor.clear)
        menuView?.setMenuViewBackgroundColor(UIColor.navbarColor)
        menuView?.separatorColor = .white
        menuView?.font = UIFont.systemFont(ofSize: 17)
        menuView?.didSelectBlock = { [weak self] index in
            print("跳转相对应的页面\(index)")
            guard let weakself = self else { return }
            switch index {
            case 0 : //Create Blank Form
                let editVC = EditFromViewController ()
                editVC.hidesBottomBarWhenPushed = true
                editVC.Complete = {() in
                    let data = RealmManagerTool.shareManager().queryObjects(objectClass: FeedbackModel.self, .feedback)
                    var dataArray: [FeedbackModel] = []
                    for model in data.reversed() {
                        dataArray.append(model)
                    }
                    self?.feedbackVC.dataArr = dataArray
                    self?.feedbackVC.tableView.reloadData()
                }
                editVC.titleLabel = "Create Form"
                self?.navigationController?.pushViewController(editVC, animated: true)
                
//            case 1 ://Copy Existing Form
//                self?.isCopy = true
            case 1 ://Create by Template
                
                let names = ["Event","Raffle","Business","Project","Other","Event","Raffle","Business","Project","Other"]
                let templateView = CreateByTemplateView()
                let data = RealmManagerTool.shareManager().queryObjects(objectClass: FeedbackModel.self, .template)
                
                
                if data.count > 0 {
                    for model in data.reversed() {
                        templateView.dataArr.append(model)
                    }
                }else{
                    //添加假数据 添加数据库
                    for i in 0...names.count - 1 {
                        let  model = FeedbackModel()
                        model.ID = "\(i + 1)"
                        model.title = names[i]
                        model.descriptio = "This is a requirement"
                        model.createDate = Calendar.current.startOfDay(for: Date())
                        templateView.dataArr.append(model)
                        //添加到本地数据库 后期可换成接口
                        RealmManagerTool.shareManager().addObject(object: model, .template)
                    }
                }
                
                templateView.createByTemplateViewComplete = { [weak self] templateModel in
                    guard let weakself = self else { return }
                    
                    print("跳转ByTemplateView=========================\(templateModel)")
                    
                    let templateManageVC = TemplateManageVC()
                    templateManageVC.hidesBottomBarWhenPushed = true
                    weakself.navigationController?.pushViewController(templateManageVC, animated: true)
                    
                }
                templateView.show()
                templateView.tableView.reloadData()
            case 2 ://Template Management
                
                let templateManageVC = TemplateManageVC()
                templateManageVC.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(templateManageVC, animated: true)
                
            default:
                break
            }
            
        }
        return menuView!
    }()
    
    
    
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
        
        configureNavigationItem()
    }
    
    func configureNavigationItem() {
    
        let addButton = UIButton(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        addButton.setImage(UIImage(named: "ic_add"), for: .normal)
        addButton.addTarget(self, action: #selector(tapAddButton), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc func tapAddButton() {
        mlmenuView.showMenuEnterAnimation(.none)
    }
    
    
}

extension FeedbackHomeViewController {
    
    override func menuView(_ menu: WMMenuView!, widthForItemAt index: Int) -> CGFloat {
        let width = super.menuView(menu, widthForItemAt: index)
        return width + 20
    }
    
    override func numbersOfChildControllers(in inpageController: WMPageController) -> Int {
        return 2
    }
    
    override func pageController(_ pageController: WMPageController, titleAt index: Int) -> String {
        return ["Feedback","Report"][index]
    }
    
    override func pageController(_ pageController: WMPageController, viewControllerAt index: Int) -> UIViewController {
        switch index {
        case 0 :
            return feedbackVC
        case 1 :
            
           let reportListVC = ReportListViewController()
            reportListVC.loadFeedbackModelData()
            return reportListVC
        default:
            return FeedbackViewController()
        }
    }
    
    override func pageController(_ pageController: WMPageController, preferredFrameFor menuView: WMMenuView) -> CGRect {
        return CGRect(x: 50, y: 0, width: CGFloat.screenWidth - 100, height: 44)
    }
    
    override func pageController(_ pageController: WMPageController, preferredFrameForContentView contentView: WMScrollView) -> CGRect {
        return CGRect(x: 0, y: 0, width: CGFloat.screenWidth, height: CGFloat.screenHeight - CGFloat.naviHeight() - CGFloat.bottomHeight() - 44)
    }

}
