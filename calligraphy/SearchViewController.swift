//  SearchViewController.swift
//  Dictionary
//
//  Created by chenzhiwei on 2024/12/24.
//  Copyright © 2024年 chenzhiwei. All rights reserved.
//

import UIKit

class WorkCarouselCell: UICollectionViewCell {
    
    @IBOutlet weak var workImageView: UIImageView!
    
    @IBOutlet weak var workNameLabel: UILabel!
    
    static let reuseIdentifier = "WorkCarouseCell"
}

class AuthorCarouseCell:UICollectionViewCell{
    
    @IBOutlet weak var authorImageView: UIImageView!
    
    @IBOutlet weak var authorNameLabel: UILabel!
    
    
    static let reuseIdentifier = "AuthorCarouseCell";
}


class SearchViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var workCollectionView: UICollectionView!
    
    @IBOutlet weak var authorCollectionView: UICollectionView!
    
    @IBOutlet weak var workPageControl: UIPageControl!
    
    
    private var timer: Timer?
    private let autoScrollInterval: TimeInterval = 3.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置搜索栏代理
        searchBar.delegate = self
        
        // 设置CollectionView代理和数据源
        workCollectionView.delegate = self
        workCollectionView.dataSource = self
        authorCollectionView.delegate = self;
        authorCollectionView.dataSource = self;
        
        // 配置CollectionView布局
        if let layout = workCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.itemSize = workCollectionView.frame.size
        }
        
        // 配置PageControl
        workPageControl.numberOfPages = DataManager.shared.showWorkList.count
        workPageControl.currentPage = 0
        
        // 设置滚动视图的减速率为快速，使得滚动更为灵敏
        workCollectionView.decelerationRate = .fast
        
        // 启动定时器
        startTimer()
        
        // 设置手势识别，按下空白处退出
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == workCollectionView){
            let strlist = DataManager.shared.showWorkList[indexPath.row].split(separator: "-");
            DataManager.shared.selectedWorkType = String(strlist[0]);
            DataManager.shared.selectedWork = String(strlist[1]);
            performSegue(withIdentifier: "ShowWorkPageList", sender: self);
        }else{
            DataManager.shared.selectedAuthor = DataManager.shared.showAuthorList[indexPath.row];
            performSegue(withIdentifier: "ShowAuthorDetail", sender: self);
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // 更新ItemSize，防止横屏或其他布局变化时轮播图不适应
        if let layout = workCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = workCollectionView.frame.size
            workCollectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 停止定时器
        invalidateTimer()
    }
    
    // MARK: - 定时器相关
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: autoScrollInterval, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
    }
    
    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func autoScroll() {
        let currentIndex = Int(workCollectionView.contentOffset.x / workCollectionView.frame.width)
        let nextIndex = (currentIndex + 1) % DataManager.shared.showWorkList.count
        let indexPath = IndexPath(item: nextIndex, section: 0)
        
        workCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        workPageControl.currentPage = nextIndex
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == workCollectionView){
            return DataManager.shared.showWorkList.count;
        }else{
            return DataManager.shared.showAuthorList.count;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView == workCollectionView){
            let cell = workCollectionView.dequeueReusableCell(withReuseIdentifier: WorkCarouselCell.reuseIdentifier, for: indexPath) as! WorkCarouselCell
            cell.workImageView.image = UIImage(named:"\(DataManager.shared.showWorkList[indexPath.row])-内容-1");
            cell.workNameLabel.text = DataManager.shared.showWorkList[indexPath.row];
            return cell
        }else{
            let cell = authorCollectionView.dequeueReusableCell(withReuseIdentifier: AuthorCarouseCell.reuseIdentifier, for: indexPath) as! AuthorCarouseCell;
            cell.authorImageView.image = UIImage(named:"\(DataManager.shared.showAuthorList[indexPath.row])")
            cell.authorNameLabel.text = DataManager.shared.showAuthorList[indexPath.row];
            return cell;
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if(scrollView == workCollectionView){
            invalidateTimer();
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 用户停止拖动，重新启动定时器
        if(scrollView == workCollectionView){
            startTimer();
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView == workCollectionView){
            let page = Int((scrollView.contentOffset.x + (0.5 * scrollView.frame.width)) / scrollView.frame.width)
            workPageControl.currentPage = page % DataManager.shared.showWorkList.count
        }
    }
    
    // MARK: - 自定义分页行为
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if(scrollView == workCollectionView){
            // 获取当前页码
            let pageWidth = scrollView.frame.width
            let currentPage = Int(scrollView.contentOffset.x / pageWidth)
            
            var targetPage = currentPage
            
            // 根据滑动速度和方向决定目标页码
            if velocity.x > 0.3 {
                targetPage = currentPage + 1
            } else if velocity.x < -0.3 {
                targetPage = currentPage - 1
            } else {
                // 根据滚动的偏移量决定是否切换页码
                let offset = scrollView.contentOffset.x - (CGFloat(currentPage) * pageWidth)
                if offset > pageWidth / 2 {
                    targetPage = currentPage + 1
                } else if offset < -pageWidth / 2 {
                    targetPage = currentPage - 1
                }
            }
            
            // 确保目标页码在有效范围内
            targetPage = max(0, min(targetPage, DataManager.shared.showWorkList.count - 1))
            
            // 计算新的偏移量
            let newOffset = CGPoint(x: CGFloat(targetPage) * pageWidth, y: 0)
            
            // 设置目标偏移量
            targetContentOffset.pointee = newOffset
            
            // 更新PageControl
            workPageControl.currentPage = targetPage
        }
       
    }
    
    // 退出键盘函数
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let query:String = searchBar.text!;
        
        if query.isEmpty{
            let alert = UIAlertController(title: "提示", message: "请先输入搜索内容", preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil));
            present(alert, animated: true, completion: nil);
        }
        
        var cnt = 0;
        for worklist in DataManager.shared.workList{
            for work in worklist{
                if(work == query){
                    DataManager.shared.selectedWork = work;
                    if(cnt == 0){
                        DataManager.shared.selectedWorkType = "楷书";
                    }else if(cnt == 1){
                        DataManager.shared.selectedWorkType = "行书";
                    }else{
                        DataManager.shared.selectedWorkType = "草书";
                    }
                    let str = "\(DataManager.shared.selectedWorkType ?? "")-\(DataManager.shared.selectedWork ?? "")";
                    var vis = false;
                    for i in DataManager.shared.historyList{
                        if(i == str){
                            vis = true;
                            break;
                        }
                    }
                    if(!vis && DataManager.shared.isLoginIn){
                        DataManager.shared.historyList = [str] + DataManager.shared.historyList;
                    }
                    performSegue(withIdentifier: "ShowWorkPageList", sender: query)
                    return;
                }
            }
            cnt = cnt + 1;
        }
        
        let alert = UIAlertController(title: "提示", message: "未找到对应作品: \(query)", preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil));
        present(alert, animated: true, completion: nil);
        
        searchBar.resignFirstResponder()
    }
    
}

