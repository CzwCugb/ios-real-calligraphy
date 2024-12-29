//
//  HistoryViewController.swift
//  Dictionary
//
//  Created by chenzhiwei on 2024/12/28.
//  Copyright © 2024年 chenzhiwei. All rights reserved.
//

import UIKit


class HistoryTableViewCell:UITableViewCell{
    
    @IBOutlet weak var workImageView: UIImageView!
    
    @IBOutlet weak var workNameLabel: UILabel!
    
    static let reuseIdentifier = "HistoryTableViewCell";
}

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var historyTableView: UITableView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    private var showList:[String] = DataManager.shared.historyList;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTableView.dataSource = self;
        historyTableView.delegate = self;
        if(DataManager.shared.showFavorite){
            showList = DataManager.shared.favoriteList;
            titleLabel?.text = "我的收藏";
        }else{
            showList = DataManager.shared.historyList;
            titleLabel?.text = "历史记录";
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.reuseIdentifier, for: indexPath) as! HistoryTableViewCell;
        let image = UIImage(named:"\(showList[indexPath.row])-封面")
        cell.workImageView?.image = image;
        cell.workNameLabel.text = showList[indexPath.row];
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80);
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let strlist = showList[indexPath.row].split(separator: "-");
        DataManager.shared.selectedWorkType = String(strlist[0]);
        DataManager.shared.selectedWork = String(strlist[1]);
        tableView.deselectRow(at: indexPath, animated: true);
    }
}
