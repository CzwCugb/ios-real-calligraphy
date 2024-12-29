//
//  AuthorDetailViewController.swift
//  Dictionary
//
//  Created by chenzhiwei on 2024/12/28.
//  Copyright © 2024年 chenzhiwei. All rights reserved.
//

import UIKit

class AuthorDetailViewController: UIViewController {

    @IBOutlet weak var authorImageView: UIImageView!
    
    @IBOutlet weak var authorMsgTextView_1: UITextView!
    
    @IBOutlet weak var authorMagTextView_2: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let author = DataManager.shared.selectedAuthor!;
        authorImageView.image = UIImage(named:author);
        authorMsgTextView_1.text = DataManager.shared.authorMsgList[author]![0];
        authorMagTextView_2.text = DataManager.shared.authorMsgList[author]?[1];
    }

}
