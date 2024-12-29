import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func registerButtonClicked(_ sender: Any) {
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            // 防止usernameTextField.text或passwordTextField.text为nil
            let alert = UIAlertController(title: "提示", message: "用户名/密码为空", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        if username.isEmpty || password.isEmpty {
            let alert = UIAlertController(title: "提示", message: "用户名/密码为空", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            DataManager.shared.accountList.append([username, password])
            
            let alert = UIAlertController(title: "提示", message: "注册成功！", preferredStyle: .alert)
            
            // 创建“立刻登录”按钮，并在点击时返回上一页面
            let loginNowAction = UIAlertAction(title: "立刻登录", style: .default) { [weak self] _ in
                DataManager.shared.isLoginIn = true;
                DataManager.shared.currentUsername = username;
                if let navigationController = self?.navigationController {
                    navigationController.popViewController(animated: true)
                } else {
                    self?.dismiss(animated: true, completion: nil)
                }
            }
            
            let laterAction = UIAlertAction(title: "稍后", style: .default, handler: nil)
            
            alert.addAction(loginNowAction)
            alert.addAction(laterAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        if username.isEmpty || password.isEmpty {
            let alert = UIAlertController(title: "提示", message: "用户名/密码为空", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        // 验证用户名和密码
        if DataManager.shared.accountList.contains(where: { $0[0] == username && $0[1] == password }) {
            // 登录成功，执行相应操作，例如跳转到主界面
            let alert = UIAlertController(title: "成功", message: "登录成功！", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
                // 返回或跳转到主界面
                if let navigationController = self.navigationController {
                    DataManager.shared.isLoginIn = true;
                    DataManager.shared.currentUsername = username;
                    navigationController.popViewController(animated: true);
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }))
            present(alert, animated: true, completion: nil)
        } else {
            // 登录失败，提示用户
            let alert = UIAlertController(title: "失败", message: "用户名或密码不正确", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    // 退出键盘函数
    @objc func dismissKeyboard() {
        usernameTextField.resignFirstResponder();
        passwordTextField.resignFirstResponder();
    }
    
    
}

