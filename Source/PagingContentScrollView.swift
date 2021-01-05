//
//  PagingContentScrollView.swift
//  PagingViewKit
//
//  Created by kingsic on 2020/12/23.
//  Copyright © 2020 kingsic. All rights reserved.
//

import UIKit

@objc public protocol PagingContentScrollViewDelegate: NSObjectProtocol {
    /// 滚动当前内容视图时对应的相关数据
    ///
    /// - parameter pagingContentScrollView: PagingContentScrollView
    /// - parameter progress: 滚动进度值
    /// - parameter currentIndex: 当前子视图下标值
    /// - parameter targetIndex: 目标子视图下标值
    @objc optional func pagingContentScrollView(pagingContentScrollView: PagingContentScrollView, progress: CGFloat, currentIndex: Int, targetIndex: Int)
    /// 内容视图当前对应子视图的下标值
    ///
    /// - parameter pagingContentScrollView: PagingContentScrollView
    /// - parameter progress: 滚动进度值
    /// - parameter currentIndex: 当前子视图下标值
    /// - parameter targetIndex: 目标子视图下标值
    @objc optional func pagingContentScrollView(pagingContentScrollView: PagingContentScrollView, index: Int)
    /// 内容视图开始拖拽的方法
    @objc optional func pagingContentScrollViewWillBeginDragging()
    /// 内容视图结束拖拽的方法
    @objc optional func pagingContentScrollViewDidEndDecelerating()
}

public class PagingContentScrollView: UIView {
    public init(frame: CGRect, parentVC: UIViewController, childVCs: [UIViewController]) {
        super.init(frame: frame)
        parentViewController = parentVC
        childViewControllers = childVCs

        addSubview(scrollView)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// delegate
    public weak var delegate: PagingContentScrollViewDelegate?
    /// 切换内容子视图是否需要动画效果，默认为 false
    public var isAnimated = false
    /// 内容子视图是否可以左右滚动，默认为 true；为 false 时，不需要设置代理及其方法
    public var isScrollEnabled: Bool? {
        willSet{
            scrollView.isScrollEnabled = newValue!
        }
    }

    private weak var parentViewController: UIViewController?
    private var childViewControllers: [UIViewController] = []
    private var startOffsetX: CGFloat = 0.0
    private var previousChildVC: UIViewController?
    private var previousChildVCIndex: Int = -1
    private var scroll: Bool?
    
    private lazy var scrollView: UIScrollView = {
        let tempScrollView = UIScrollView()
        tempScrollView.frame = self.bounds
        tempScrollView.bounces = false
        tempScrollView.delegate = self
        tempScrollView.isPagingEnabled = true
        tempScrollView.showsVerticalScrollIndicator = false
        tempScrollView.showsHorizontalScrollIndicator = false
        let contentWidth: CGFloat = CGFloat(childViewControllers.count) * tempScrollView.frame.size.width
        tempScrollView.contentSize = CGSize(width: contentWidth, height: 0)
        return tempScrollView
    }()
}

// MARK: 外部方法: 根据外界提供的下标值设置内容视图对应子视图
public extension PagingContentScrollView {
    /// 根据外界提供的下标值设置内容视图对应子视图
    func setPagingContentScrollView(index: Int) {
        let offsetX = CGFloat(index) * scrollView.frame.size.width
        // 1、切换子控制器的时候，执行上个子控制器的 viewWillDisappear 方法
        if previousChildVC != nil && previousChildVCIndex != index {
            previousChildVC?.beginAppearanceTransition(false, animated: false)
        }
        // 2、添加子控制器及子控制器的 view 到父控制器及父控制器 view 中
        if previousChildVCIndex != index {
            let childVC: UIViewController = childViewControllers[index]
            var firstAdd = false
            if !(parentViewController?.children.contains(childVC))! {
                parentViewController?.addChild(childVC)
                firstAdd = true
            }
            childVC.beginAppearanceTransition(true, animated: false)
            
            if (firstAdd) {
                scrollView.addSubview(childVC.view)
                childVC.view.frame = CGRect(x: offsetX, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
            }
            
            // 切换子控制器的时候，执行上个子控制器的 viewDidDisappear 方法
            if previousChildVC != nil && previousChildVCIndex != index {
                previousChildVC?.endAppearanceTransition()
            }
            childVC.endAppearanceTransition()
            
            if (firstAdd) {
                childVC.didMove(toParent: parentViewController)
            }
            
            // 记录上个子控制器
            previousChildVC = childVC
            // 处理内容偏移
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: isAnimated)
        }
        // 3.2、记录上个子控制器下标
        previousChildVCIndex = index
        // 3.3、重置 startOffsetX
        startOffsetX = offsetX
        
        // 4、pagingContentScrollView:index:
        if delegate != nil && (delegate?.responds(to: #selector(delegate?.pagingContentScrollView(pagingContentScrollView:index:))))! {
            delegate?.pagingContentScrollView!(pagingContentScrollView: self, index: index)
        }
    }
}

extension PagingContentScrollView: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffsetX = scrollView.contentOffset.x
        scroll = true
        if delegate != nil && (delegate?.responds(to: #selector(delegate?.pagingContentScrollViewWillBeginDragging)))! {
            delegate?.pagingContentScrollViewWillBeginDragging?()
        }
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scroll = false
        // 1、根据标题下标计算 pageContent 偏移量
        let offsetX: CGFloat = scrollView.contentOffset.x
        // 2、切换子控制器的时候，执行上个子控制器的 viewWillDisappear 方法
        if startOffsetX != offsetX {
            previousChildVC?.beginAppearanceTransition(false, animated: false)
        }
        // 3、获取当前显示子控制器的下标
        let index: Int = Int(offsetX / scrollView.frame.size.width)
        // 4、添加子控制器及子控制器的 view 到父控制器以及父控制器 view 中
        let childVC: UIViewController = childViewControllers[index]
       
        var firstAdd = false
        if !(parentViewController?.children.contains(childVC))! {
            parentViewController?.addChild(childVC)
            firstAdd = true
        }
       
        childVC.beginAppearanceTransition(true, animated: false)
       
        if (firstAdd) {
            scrollView.addSubview(childVC.view)
            childVC.view.frame = CGRect(x: offsetX, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        }
               
        // 2.1、切换子控制器的时候，执行上个子控制器的 viewDidDisappear 方法
        if startOffsetX != offsetX {
            previousChildVC?.endAppearanceTransition()
        }
        childVC.endAppearanceTransition()
       
        if (firstAdd) {
            childVC.didMove(toParent: parentViewController)
        }
               
        // 4.1、记录上个展示的子控制器、记录当前子控制器偏移量
        previousChildVC = childVC
        previousChildVCIndex = index
               
        // 5、pagingContentScrollView:index:
        if delegate != nil && (delegate?.responds(to: #selector(delegate?.pagingContentScrollView(pagingContentScrollView:index:))))! {
            delegate?.pagingContentScrollView!(pagingContentScrollView: self, index: index)
        }
        // 6、pagingContentScrollViewDidEndDecelerating
        if delegate != nil && (delegate?.responds(to: #selector(delegate?.pagingContentScrollViewDidEndDecelerating)))! {
            delegate?.pagingContentScrollViewDidEndDecelerating!()
        }
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isAnimated == true && scroll == false { return }
        // 1、定义获取需要的数据
        var progress: CGFloat = 0.0
        var originalIndex: Int = 0
        var targetIndex: Int = 0
                
        // 2、判断是左滑还是右滑
        let currentOffsetX: CGFloat = scrollView.contentOffset.x
        let scrollViewW: CGFloat = scrollView.bounds.size.width
        if currentOffsetX > startOffsetX { // 左滑
            // 1、计算 progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW);
            // 2、计算 originalIndex
            originalIndex = Int(currentOffsetX / scrollViewW);
            // 3、计算 targetIndex
            targetIndex = originalIndex + 1;
            if targetIndex >= childViewControllers.count {
                progress = 1;
                targetIndex = originalIndex;
            }
            // 4、如果完全划过去
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1;
                targetIndex = originalIndex;
            }
        } else { // 右滑
            // 1、计算 progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW));
            // 2、计算 targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW);
            // 3、计算 originalIndex
            originalIndex = targetIndex + 1;
            if originalIndex >= childViewControllers.count {
                originalIndex = childViewControllers.count - 1;
            }
        }
                
        // 3、将 progress／currentIndex／targetIndex 传递给 PagingTitleView
        if delegate != nil && (delegate?.responds(to: #selector(delegate?.pagingContentScrollView(pagingContentScrollView:progress:currentIndex:targetIndex:))))! {
            delegate?.pagingContentScrollView!(pagingContentScrollView: self, progress: progress, currentIndex: originalIndex, targetIndex: targetIndex)
        }
    }
}
