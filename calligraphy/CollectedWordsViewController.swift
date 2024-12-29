//
//  CollectedWordsViewController.swift
//  Dictionary
//
//  Created by chenzhiwei on 2024/12/25.
//  Copyright © 2024年 chenzhiwei. All rights reserved.
//

import UIKit


class WordCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var wordImageView: UIImageView!
    
    static let reuseIdentifier = "WordCollectionViewCell";
}


class CollectedWordsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var collectedWordsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.shared.responseWordList?.removeAll();
        collectedWordsCollectionView.dataSource = self;
        collectedWordsCollectionView.delegate = self;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.shared.inputSentence!.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectedWordsCollectionView.dequeueReusableCell(withReuseIdentifier: "WordCollectionViewCell", for: indexPath) as! WordCollectionViewCell;
        let wordImagePath = findword(
            wordType: DataManager.shared.workTypeForSearch,
            author: DataManager.shared.authorForSearch,
            wordName: DataManager.shared.inputSentence![indexPath.row]);
        DataManager.shared.responseWordList!.append(wordImagePath!);
        cell.wordImageView?.image = UIImage(named: wordImagePath!);
        return cell;
    }
    
    private func findword(wordType:String?, author:String?, wordName:Character?) -> String?{
        for (key,value) in DataManager.shared.wordListDict{
            if((key[1] == wordType || wordType == "全部") && (key[0] == author || author == "全部")){
                for word in value{
                    if(word == String(wordName!)){
                        return "\(key[0])-\(key[2])-\(wordName!)";
                        //print("imagepath == \(str)");
                    }
                }
            }
        }
        return "empty";
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DataManager.shared.wordIdx = indexPath.row;
    }
    
}
