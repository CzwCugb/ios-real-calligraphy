//
//  ProfileViewController.swift
//  Dictionary
//
//  Created by chenzhiwei on 2024/12/27.
//  Copyright © 2024年 chenzhiwei. All rights reserved.
//

import UIKit

class ProfileListTableViewCell:UITableViewCell{
    
    @IBOutlet weak var lineNameLabel: UILabel!
    
    static let reuseIdentifier = "ProfileListTableViewCell";
}


class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var sculptrueImageView: UIImageView!;
    
    @IBOutlet weak var profileListTableView: UITableView!;

    @IBOutlet weak var clickButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        profileListTableView.dataSource = self;
        profileListTableView.delegate = self;
        profileListTableView.isScrollEnabled = false;
        
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        if(DataManager.shared.isLoginIn){
            let alert = UIAlertController(title: "提示", message: "是否要退出账号？", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "是的", style: .default, handler:{_ in
                DataManager.shared.isLoginIn = false;
                self.viewWillAppear(true);
            }))
            alert.addAction(UIAlertAction(title: "稍后 ", style: .default, handler: nil))
            present(alert, animated: true, completion: nil);
        }else{
            performSegue(withIdentifier: "ShowLoginPage", sender: self);
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        if(DataManager.shared.isLoginIn){
            sculptrueImageView.image = UIImage(named:"sculpture-login");
            clickButton.setTitle(DataManager.shared.currentUsername, for: .normal)
        }else{
            sculptrueImageView.image = UIImage(named:"sculpture-not-login");
            clickButton.setTitle("去登录", for: .normal)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = profileListTableView.dequeueReusableCell(withIdentifier: "ProfileListTableViewCell") as! ProfileListTableViewCell;
        cell.lineNameLabel.text = DataManager.shared.profileList[indexPath.row];
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60);
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(30);
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0){ //我的收藏
            if(!DataManager.shared.isLoginIn){
                let alert = UIAlertController(title: "提示", message:
                    "请先登录账号", preferredStyle: .alert);
                alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil));
                present(alert, animated: true, completion: nil);
            }else{
                DataManager.shared.showFavorite = true;
                performSegue(withIdentifier: "ShowHistoryList", sender: self);
            }
        }else if(indexPath.row == 1){ //历史记录
            if(!DataManager.shared.isLoginIn){
                let alert = UIAlertController(title: "提示", message:
                    "请先登录账号", preferredStyle: .alert);
                alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil));
                present(alert, animated: true, completion: nil);
            }else{
                DataManager.shared.showFavorite = false;
                performSegue(withIdentifier: "ShowHistoryList", sender: self);
            }
        }else if(indexPath.row == 2){ //软件说明
            let alert = UIAlertController(title: "说明", message:
                "嵌入式软件开发课程设计，仅用于学习用途", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil));
            present(alert, animated: true, completion: nil)
        }else if(indexPath.row == 3){ //给我们打分
            let alert = UIAlertController(title: "说明", message:
                "感谢您为我们打分", preferredStyle: .actionSheet);
            alert.addAction(UIAlertAction(title:"5",style: .default, handler: nil));
            alert.addAction(UIAlertAction(title:"4",style: .default, handler: nil));
            alert.addAction(UIAlertAction(title:"3",style: .default, handler: nil));
            alert.addAction(UIAlertAction(title:"2",style: .default, handler: nil));
            alert.addAction(UIAlertAction(title:"1",style: .default, handler: nil));
            alert.addAction(UIAlertAction(title:"下次再打分",style: .default, handler: nil));
            present(alert, animated: true, completion: nil)
        }else{ //当前版本
            let alert = UIAlertController(title: "版本", message:
                "您当前版本号：1.0（已为最新版本）", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil));
            present(alert, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true);
    }
    
    
}
