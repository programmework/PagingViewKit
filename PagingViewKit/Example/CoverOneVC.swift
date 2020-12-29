//
//  CoverOneVC.swift
//  PagingViewKit
//
//  Created by kingsic on 2020/12/29.
//  Copyright © 2020 kingsic. All rights reserved.
//

import UIKit

class CoverOneVC: UIViewController, PagingTitleViewDelegate, PagingContentScrollViewDelegate {
    
    deinit {
        print("CoverOneVC - deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        view.addSubview(pagingTitleView)
        view.addSubview(pagingContentView)
    }
    
    lazy var pagingTitleView: PagingTitleView = {
        let configure: PagingTitleViewConfigure = PagingTitleViewConfigure()
        configure.indicatorType = .Cover
        configure.indicatorHeight = 34
        configure.indicatorAdditionalWidth = 30
        configure.indicatorCornerRadius = 17
        configure.indicatorColor = .black
        configure.selectedColor = .white
        
        let frame = CGRect.init(x: 0, y: 100, width: view.frame.size.width, height: 44)
        let titles = ["关注", "推荐", "热榜", "免费小说"]
        let pagingTitle = PagingTitleView(frame: frame, titles: titles, delegate: self, configure: configure)
        return pagingTitle
    }()
    
    lazy var pagingContentView: PagingContentScrollView = {
        let vc1 = UIViewController()
        vc1.view.backgroundColor = .orange
        let vc2 = UIViewController()
        vc2.view.backgroundColor = .purple
        let vc3 = UIViewController()
        vc3.view.backgroundColor = .green
        let vc4 = UIViewController()
        vc4.view.backgroundColor = .brown
        let vcs = [vc1, vc2, vc3, vc4]
        
        let y: CGFloat = pagingTitleView.frame.maxY + 20
        let tempRect: CGRect = CGRect.init(x: 0, y: y, width: view.frame.size.width, height: view.frame.size.height - y)
        let pagingContent: PagingContentScrollView = PagingContentScrollView(frame: tempRect, parentVC: self, childVCs: vcs)
        pagingContent.delegate = self
        return pagingContent
    }()

    func pagingContentScrollView(pagingContentScrollView: PagingContentScrollView, progress: CGFloat, currentIndex: Int, targetIndex: Int) {
        pagingTitleView.setPagingTitleView(progress: progress, currentIndex: currentIndex, targetIndex: targetIndex)
    }
    
    func pagingTitleView(pagingTitleView: PagingTitleView, index: Int) {
        pagingContentView.setPagingContentScrollView(index: index)
    }
}
