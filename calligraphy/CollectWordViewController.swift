//
//  CollectWordViewController.swift
//  Dictionary
//
//  Created by chenzhiwei on 2024/12/25.
//  Copyright © 2024年 chenzhiwei. All rights reserved.
//

import UIKit

class CollectWordViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var workTypePicker: UIPickerView!
    
    @IBOutlet weak var authorPicker: UIPickerView!
    
    @IBOutlet weak var sentenceTextField: UITextView!
    
    private var authorlist = DataManager.shared.showAuthorList;
    
    private var workTypeList = DataManager.shared.workTypeList;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workTypePicker.delegate = self;
        workTypePicker.dataSource = self;
        authorPicker.delegate = self;
        authorPicker.dataSource = self;
        
        // 设置手势识别，按下空白处退出
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        authorPicker.selectRow(0, inComponent: 0, animated: true);
        workTypePicker.selectRow(0, inComponent: 0, animated: true);
        
        authorlist = ["全部"] + authorlist;
        
        workTypeList.removeLast();
        workTypeList =  ["全部"] + workTypeList;
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == workTypePicker){
            return workTypeList.count;
        }else{
            return authorlist.count;
        }
    }
    
    // 设置每行显示的内容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == workTypePicker){
            return workTypeList[row];
        }else{
            return authorlist[row];
        }
    }
    
    // 处理用户选择的事件
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == authorPicker){
            DataManager.shared.authorForSearch = authorlist[row];
        }else{
            DataManager.shared.workTypeForSearch = workTypeList[row];
        }
        
    }
    
    @IBAction func showButtonClicked(_ sender: Any) {
        DataManager.shared.inputSentence = Array((sentenceTextField?.text)!);
    }
    
    // 退出键盘函数
    @objc func dismissKeyboard() {
        sentenceTextField.resignFirstResponder();
    }
}
