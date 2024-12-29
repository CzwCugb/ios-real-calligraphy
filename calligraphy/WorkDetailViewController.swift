//
//  WorkDetailViewController.swift
//  Dictionary
//
//  Created by chenzhiwei on 2024/12/25.
//  Copyright © 2024年 chenzhiwei. All rights reserved.
//

import UIKit

class pageCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var pageImageView: UIImageView!
    
    @IBOutlet weak var pageIdxLabel: UILabel!
    
    static let reuseIdentidier = "PageCollectionViewCell";
}


class WorkDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var pageCollectionView: UICollectionView!
    
    @IBOutlet weak var titlelabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        titlelabel.text = DataManager.shared.selectedWork;
        pageCollectionView.dataSource = self;
        pageCollectionView.delegate = self;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let pageNum = DataManager.shared.PageNumDict[DataManager.shared.selectedWork!];
        return pageNum!;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = pageCollectionView.dequeueReusableCell(withReuseIdentifier: "PageCollectionViewCell", for: indexPath) as! pageCollectionViewCell;
        cell.pageIdxLabel?.text = "\(indexPath.row + 1)";
        
        let pageImageName = "\(DataManager.shared.selectedWorkType!)-\(DataManager.shared.selectedWork!)-内容-\(indexPath.row+1)"
        //print(pageImageName);
        cell.pageImageView?.image = UIImage(named:pageImageName);
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DataManager.shared.selectedPage = indexPath.row + 1;
    }
    
    @IBAction func favoriteButtonClicked(_ sender: Any) {
        if(!DataManager.shared.isLoginIn){
            let alert = UIAlertController(title: "提示", message: "请先登录账号", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return;
        }
        
        let str = "\(DataManager.shared.selectedWorkType ?? "")-\(DataManager.shared.selectedWork ?? "")";
        for i in DataManager.shared.favoriteList{
            if(i == str){
                let alert = UIAlertController(title: "提示", message: "该作品已收藏", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                return;
            }
        }
        let alert = UIAlertController(title: "提示", message: "成功收藏\(DataManager.shared.selectedWork ?? "")", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        DataManager.shared.favoriteList.append(str);
    }
}
