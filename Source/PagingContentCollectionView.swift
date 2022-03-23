//
//  PagingContentCollectionView.swift
//  PagingViewKit
//
//  Created by kingsic on 2020/12/23.
//  Copyright © 2020 kingsic. All rights reserved.
//

import UIKit

@objc public protocol PagingContentCollectionViewDelegate: NSObjectProtocol {
    /// 滚动当前内容视图时对应的相关数据
    ///
    /// - parameter pagingContentCollectionView: PagingContentCollectionView
    /// - parameter progress: 滚动进度值
    /// - parameter currentIndex: 当前子视图下标值
    /// - parameter targetIndex: 目标子视图下标值
    @objc optional func pagingContentCollectionView(pagingContentCollectionView: PagingContentCollectionView, progress: CGFloat, currentIndex: Int, targetIndex: Int)
    /// 内容视图当前对应子视图的下标值
    ///
    /// - parameter pagingContentCollectionView: PagingContentCollectionView
    /// - parameter progress: 滚动进度值
    /// - parameter currentIndex: 当前子视图下标值
    /// - parameter targetIndex: 目标子视图下标值
    @objc optional func pagingContentCollectionView(pagingContentCollectionView: PagingContentCollectionView, index: Int)
    /// 内容视图开始拖拽的方法
    @objc optional func pagingContentCollectionViewWillBeginDragging()
    /// 内容视图结束拖拽的方法
    @objc optional func pagingContentCollectionViewDidEndDecelerating()
}

public class PagingContentCollectionView: UIView {
    public init(frame: CGRect, parentVC: UIViewController, childVCs: [UIViewController]) {
        super.init(frame: frame)
        parentViewController = parentVC
        childViewControllers = childVCs

        addSubview(collectionView)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// delegate
    public weak var delegate: PagingContentCollectionViewDelegate?
    /// 切换内容子视图是否需要动画效果，默认为 false
    public var isAnimated = false
    /// 内容子视图是否可以左右滚动，默认为 true；为 false 时，不需要设置代理及其方法
    public var isScrollEnabled: Bool? {
        willSet{
            collectionView.isScrollEnabled = newValue!
        }
    }

    private weak var parentViewController: UIViewController?
    private var childViewControllers: [UIViewController] = []
    private var startOffsetX: CGFloat = 0.0
    private var previousChildVC: UIViewController?
    private var previousChildVCIndex: Int = -1
    private var scroll: Bool?
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = self.bounds.size
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        
        let rect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        let tempCollectionView = UICollectionView(frame: rect, collectionViewLayout: flowLayout)
        tempCollectionView.showsVerticalScrollIndicator = false
        tempCollectionView.showsHorizontalScrollIndicator = false
        tempCollectionView.isPagingEnabled = true
        tempCollectionView.bounces = false
        tempCollectionView.backgroundColor = UIColor.clear
        tempCollectionView.delegate = self
        tempCollectionView.dataSource = self
        tempCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        return tempCollectionView
    }()
}

// MARK: 外部方法: 根据外界提供的下标值设置内容视图对应子视图
public extension PagingContentCollectionView {
    /// 根据外界提供的下标值设置内容视图对应子视图
    func setPagingContentCollectionView(index: Int) {
        let offsetX = CGFloat(index) * collectionView.frame.size.width
        startOffsetX = offsetX
        if previousChildVCIndex != index {
            collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: isAnimated)
        }
        previousChildVCIndex = index
        if (delegate != nil) && (delegate?.responds(to: #selector(delegate?.pagingContentCollectionView(pagingContentCollectionView:index:))))! {
            delegate?.pagingContentCollectionView!(pagingContentCollectionView: self, index: index)
        }
    }
}

private let cellID = "cellID"

extension PagingContentCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childViewControllers.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        cell.contentView.subviews.forEach { (subView) in
            subView.removeFromSuperview()
        }
        let childVC = childViewControllers[indexPath.item]
        parentViewController?.addChild(childVC)
        cell.contentView.addSubview(childVC.view)
        childVC.view.frame = cell.contentView.frame
        childVC.didMove(toParent: parentViewController)
        return cell
    }
}
extension PagingContentCollectionView {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffsetX = scrollView.contentOffset.x
        scroll = true
        if (delegate != nil) && (delegate?.responds(to: #selector(delegate?.pagingContentCollectionViewWillBeginDragging)))! {
            delegate?.pagingContentCollectionViewWillBeginDragging!()
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scroll = false
        let offsetX = scrollView.contentOffset.x
        previousChildVCIndex = Int(offsetX / scrollView.frame.size.width)
        if (delegate != nil) && (delegate?.responds(to: #selector(delegate?.pagingContentCollectionView(pagingContentCollectionView:index:))))! {
            delegate?.pagingContentCollectionView!(pagingContentCollectionView: self, index: previousChildVCIndex)
        }
        if (delegate != nil) && (delegate?.responds(to: #selector(delegate?.pagingContentCollectionViewDidEndDecelerating)))! {
            delegate?.pagingContentCollectionViewDidEndDecelerating!()
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isAnimated == true && scroll == false {
            return
        }
        // 1、定义获取需要的数据
        var progress: CGFloat = 0.0
        var currentIndex: Int = 0
        var targetIndex: Int = 0

        // 2、判断是左滑还是右滑
        let currentOffsetX: CGFloat = scrollView.contentOffset.x
        let scrollViewW: CGFloat = scrollView.bounds.size.width
        if currentOffsetX > startOffsetX { // 左滑
            // 1、计算 progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW);
            // 2、计算 currentIndex
            currentIndex = Int(currentOffsetX / scrollViewW);
            // 3、计算 targetIndex
            targetIndex = currentIndex + 1;
            if targetIndex >= childViewControllers.count {
                progress = 1;
                targetIndex = currentIndex;
            }
            // 4、如果完全划过去
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1;
                targetIndex = currentIndex;
            }
        } else { // 右滑
            // 1、计算 progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW));
            // 2、计算 targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW);
            // 3、计算 currentIndex
            currentIndex = targetIndex + 1;
            if currentIndex >= childViewControllers.count {
                currentIndex = childViewControllers.count - 1;
            }
        }
   
        if (delegate != nil) && (delegate?.responds(to: #selector(delegate?.pagingContentCollectionView(pagingContentCollectionView:progress:currentIndex:targetIndex:))))! {
            delegate?.pagingContentCollectionView!(pagingContentCollectionView: self, progress: progress, currentIndex: currentIndex, targetIndex: targetIndex)
        }
    }
}
