//
//  WorkListViewController.swift
//  Dictionary
//
//  Created by chenzhiwei on 2024/12/25.
//  Copyright © 2024年 chenzhiwei. All rights reserved.
//

import UIKit

class WorkCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var workImageView: UIImageView!
    
    @IBOutlet weak var workNameLabel: UILabel!
    
    static let reuseIdentifier = "WorkCollectionViewCell";
    
}


class WorkTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var workTypeLabel: UILabel!
    
    @IBOutlet weak var workCollectionView: UICollectionView!
    
    static let reuseIdentifier = "WorkTableViewCell";
    public var workTypeInd = 0;
    
    // 每个collectionview包含几个cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5;
    }
    
    // collectionview datasource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = workCollectionView.dequeueReusableCell(withReuseIdentifier: "WorkCollectionViewCell", for: indexPath) as! WorkCollectionViewCell;
        var imageName = "";
        if(workTypeInd == 0){
            imageName = "楷书-";
        }else if(workTypeInd == 1){
            imageName = "行书-";
        }else{
            imageName = "草书-";
        }
        imageName = imageName + DataManager.shared.workList[workTypeInd][indexPath.row] + "-封面";
        collectionCell.workImageView?.image = UIImage(named: imageName);
        collectionCell.workNameLabel?.text = DataManager.shared.workList[workTypeInd][indexPath.row];
        return collectionCell;
    }
    
    // collectionview delegate
    
    // 处理点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DataManager.shared.selectedWork = DataManager.shared.workList[workTypeInd][indexPath.row];
        if(workTypeInd == 0){
            DataManager.shared.selectedWorkType = "楷书";
        }else if(workTypeInd == 1){
            DataManager.shared.selectedWorkType = "行书";
        }else{
            DataManager.shared.selectedWorkType = "草书";
        }
    }
}


class WorkListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var workTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workTableView.dataSource = self;
        workTableView.delegate = self;
    }
    
    // UITableDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = workTableView.dequeueReusableCell(withIdentifier: WorkTableViewCell.reuseIdentifier,for:indexPath) as! WorkTableViewCell;
        tableCell.workTypeLabel?.text = DataManager.shared.workTypeList[indexPath.section]
        tableCell.workTypeInd = indexPath.section;
        tableCell.workCollectionView.dataSource = tableCell.self;
        tableCell.workCollectionView.delegate = tableCell.self;
        return tableCell;
    }
    
    // UITableDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250;
    }
    
}
