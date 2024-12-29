//
//  PageDetailViewController.swift
//  Dictionary
//
//  Created by chenzhiwei on 2024/12/25.
//  Copyright © 2024年 chenzhiwei. All rights reserved.
//

import UIKit

class PageDetailViewController: UIViewController {
    
    @IBOutlet weak var pageDetailScrollView: UIScrollView!
    
    @IBOutlet weak var scaleSlider: UISlider!
    
    
    private let pageImageView = UIImageView();
    private var imageName:String?;
    private var pageImage:UIImage?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        imageName = DataManager.shared.selectedWorkType! + "-" + DataManager.shared.selectedWork! + "-内容-\(DataManager.shared.selectedPage!)";
        
        pageImage = UIImage(named:imageName!);
        //print(imageName);
        pageImageView.frame.size = pageImage!.size;
        pageImageView.image = pageImage;
        pageDetailScrollView.backgroundColor = #colorLiteral(red: 1, green: 0.5466704123, blue: 0.4093110613, alpha: 1)
        pageDetailScrollView.contentSize = pageImage!.size;
        pageDetailScrollView.addSubview(pageImageView);
        sliderValueChanged(self);
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        let scale = CGFloat(scaleSlider.value);
        let newWidth = pageImage!.size.width*scale;
        let newHeight = pageImage!.size.height*scale;
        let newSize = CGSize(width: newWidth, height: newHeight);
        pageImageView.frame.size = newSize;
        pageDetailScrollView.contentSize = newSize;
        centerImageView()
        
    }
    
    private func centerImageView() {
        let scrollViewSize = pageDetailScrollView.bounds.size
        let imageSize = pageImageView.frame.size
        
        let horizontalInset: CGFloat
        let verticalInset: CGFloat
        
        if imageSize.width < scrollViewSize.width {
            horizontalInset = (scrollViewSize.width - imageSize.width) / 2
        } else {
            horizontalInset = 0
        }
        
        if imageSize.height < scrollViewSize.height {
            verticalInset = (scrollViewSize.height - imageSize.height) / 2
        } else {
            verticalInset = 0
        }
        
        pageDetailScrollView.contentInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }}
