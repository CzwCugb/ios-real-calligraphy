//
//  WordViewController.swift
//  Dictionary
//
//  Created by chenzhiwei on 2024/12/26.
//  Copyright © 2024年 chenzhiwei. All rights reserved.
//

import UIKit

class WordViewController: UIViewController {
    
    
    @IBOutlet weak var wordImageView: UIImageView!
    
    @IBOutlet weak var workNameLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var yearlabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        let wordIdx = DataManager.shared.wordIdx;
        let imagePath = DataManager.shared.responseWordList![wordIdx!];
        wordImageView.image = UIImage(named:imagePath);
        let detailList = imagePath.split(separator: "-");
        print(detailList);
        if(imagePath != "empty"){
            authorLabel.text = "作品：\(detailList[0])";
            workNameLabel.text = "作者：\(detailList[1])";
            yearlabel.text = "创作时代：\(DataManager.shared.workYearDict[String(detailList[1])]!)";
        }else{
            authorLabel.text = "作品：未知";
            workNameLabel.text = "作者：未知";
            yearlabel.text = "创作时代：未知";
        }
    }
    

}
