//
//  RegisterViewController.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/2/22.
//

import UIKit

class RegisterViewController: BaseViewController {

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
    
    private lazy var passwordAgainField: UITextField = {
        let passwordField = UITextField()
//        usernameField.leftView = nil
//        usernameField.leftViewMode = .always
        passwordField.clearButtonMode = .whileEditing
        passwordField.isSecureTextEntry = false
        passwordField.keyboardType = .numbersAndPunctuation
        passwordField.textColor = UIColor.darkText
        passwordField.font = UIFont.systemFont(ofSize: 16.0)
        passwordField.placeholder = "Enter your password again"
        passwordField.textAlignment = .center
        passwordField.layer.borderColor = UIColor.blue.cgColor
        passwordField.layer.borderWidth = 1
        return passwordField
    }()
    
    private lazy var registerBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .mainColor
        btn.setTitle("Register", for: .normal)
        btn.setTitleColor(.textColor, for: .normal)
        btn.titleLabel?.font = UIFont.font_navigationTitle
        btn.addTarget(self, action: #selector(registerBtnAction(_:)), for: .touchUpInside)
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        btn.backgroundColor = .blue
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register"
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(passwordAgainField)
        view.addSubview(registerBtn)
        
        // Do any additional setup after loading the view.
    }
    
    
    @objc func registerBtnAction(_: UIButton) {
        //判空
        if usernameField.text?.count == 0 {
            CustomProgressHud.showError(withStatus: "User name cannot be empty!")
            return
        }
        
        if passwordField.text?.count == 0 {
            CustomProgressHud.showError(withStatus: "Password cannot be empty!")
            return
        }
        
        if passwordAgainField.text?.count == 0 {
            CustomProgressHud.showError(withStatus: "Enter password again cannot be empty! ")
            return
        }
        
        if passwordField.text == passwordAgainField.text {
            let loginModel = RegisterModel()
            loginModel.username = usernameField.text
            loginModel.password = passwordField.text
//            RealmManagerTool.shareManager().addObject(object: loginModel, .register)
            RealmManagerTool.shareManager().addObjects(by: [loginModel], .register)
            navigationController?.popViewController(animated: true)
        }else{
            CustomProgressHud.showError(withStatus: "The passwords are not the same. Please reset them ！")
        }
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
        
        passwordAgainField.snp.makeConstraints { (make) in
            make.top.equalTo(passwordField.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(48)
        }
        
        registerBtn.snp.makeConstraints { (make) in
            make.top.equalTo(passwordAgainField.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(40)
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
