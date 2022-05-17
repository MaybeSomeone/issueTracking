//
//  LoginViewController.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/2/22.
//

import UIKit
import SnapKit
import SVProgressHUD

class LoginViewController: BaseViewController {

    private lazy var usernameField: UITextField = {
        let usernameField = UITextField()
//        usernameField.leftView = nil
//        usernameField.leftViewMode = .always
        usernameField.clearButtonMode = .whileEditing
        usernameField.isSecureTextEntry = false
        usernameField.keyboardType = .numbersAndPunctuation
        usernameField.textColor = UIColor.darkText
        usernameField.font = UIFont.systemFont(ofSize: 16.0)
        usernameField.placeholder = "Please enter a user name"
        usernameField.textAlignment = .center
        usernameField.layer.borderColor = UIColor.blue.cgColor
        usernameField.layer.borderWidth = 1
        return usernameField
    }()
    
    
    
    
    private lazy var passwordField: UITextField = {
        let passwordField = UITextField()
//        usernameField.leftView = nil
//        usernameField.leftViewMode = .always
        passwordField.clearButtonMode = .whileEditing
        passwordField.isSecureTextEntry = false
        passwordField.keyboardType = .numbersAndPunctuation
        passwordField.textColor = UIColor.darkText
        passwordField.font = UIFont.systemFont(ofSize: 16.0)
        passwordField.placeholder = "Please enter password"
        passwordField.textAlignment = .center
        passwordField.layer.borderColor = UIColor.blue.cgColor
        passwordField.layer.borderWidth = 1
        return passwordField
    }()
    
    private lazy var loginBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .mainColor
        btn.setTitle("Login", for: .normal)
        btn.setTitleColor(.textColor, for: .normal)
        btn.titleLabel?.font = UIFont.font_navigationTitle
        btn.addTarget(self, action: #selector(loginBtnAction(_:)), for: .touchUpInside)
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        btn.backgroundColor = .blue
        return btn
    }()
    
    
    
    private lazy var registerBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .mainColor
        btn.setTitle("Register", for: .normal)
        btn.setTitleColor(.textColor, for: .normal)
        btn.titleLabel?.font = UIFont.font_navigationTitle
        btn.addTarget(self, action: #selector(registerBtnBtnAction(_:)), for: .touchUpInside)
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        btn.backgroundColor = .blue
        return btn
    }()
    
    
    private lazy var forgetBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .mainColor
        btn.setTitle("Forgot password", for: .normal)
        btn.setTitleColor(.textColor, for: .normal)
        btn.titleLabel?.font = UIFont.font_navigationTitle
        btn.addTarget(self, action: #selector(forgetBtnAction(_:)), for: .touchUpInside)
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        btn.backgroundColor = .blue
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        view.backgroundColor = .white
        
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(loginBtn)
        view.addSubview(registerBtn)
        view.addSubview(forgetBtn)
        // Do any additional setup after loading the view.
        
        //自动登录
        guard let loginModel = RealmManagerTool.shareManager().queryObjects(objectClass: LoginModel.self,filter: "ID = 'login'",.login).first else { return }
        if (loginModel.username != nil) && (loginModel.password != nil) {
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate  {
                let rootvc = BaseTabBarController()
                appDelegate.window?.rootViewController = rootvc
            }
        }
    }
    
    @objc func loginBtnAction(_: UIButton) {
        //判空
        if usernameField.text?.count == 0 {
            CustomProgressHud.showError(withStatus: "User name cannot be empty!")
            return
        }
        
        if passwordField.text?.count == 0 {
            CustomProgressHud.showError(withStatus: "Password cannot be empty!")
            return
        }
        
        //验证用户是否存在
        let registerList = RealmManagerTool.shareManager().queryObjects(objectClass: RegisterModel.self,.register)
        
        
        if registerList.count > 0 {
            for model in registerList {
                //对比注册数据库
                if model.username == usernameField.text && model.password == passwordField.text {
                    //保存登录信息
                    if usernameField.text == "123" {
                        let loginModel = LoginModel()
                        loginModel.username = usernameField.text
                        loginModel.password = passwordField.text
                        loginModel.adminuser = "0"
                        RealmManagerTool.shareManager().addObject(object: loginModel, .login)
                    
                    }else{
                        let loginModel = LoginModel()
                        loginModel.username = usernameField.text
                        loginModel.password = passwordField.text
                        loginModel.adminuser = "1"
                        RealmManagerTool.shareManager().addObject(object: loginModel, .login)
                    }
                    //跳转首页
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate  {
                        let rootvc = BaseTabBarController()
                        appDelegate.window?.rootViewController = rootvc
                    }
                }
            }
        }else {//不存在
            CustomProgressHud.showError(withStatus: "The user does not exist or the password is incorrect！")
        }
    }
    
    @objc func registerBtnBtnAction(_: UIButton) {
        
        navigationController?.pushViewController(RegisterViewController(), animated: true)
        
    }
    
    
    @objc func forgetBtnAction(_: UIButton) {
        
        navigationController?.pushViewController(ForgotViewController(), animated: true)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        usernameField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.top.equalToSuperview().offset(80)
            make.height.equalTo(48)
        }
        
        passwordField.snp.makeConstraints { (make) in
            make.top.equalTo(usernameField.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(48)
        }
        
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(passwordField.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(40)
        }
        
        registerBtn.snp.makeConstraints { (make) in
            make.top.equalTo(loginBtn.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(40)
        }
        
        forgetBtn.snp.makeConstraints { (make) in
            make.top.equalTo(registerBtn.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(40)
        }
    }
}
