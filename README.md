# PagingViewKit

#### [Objc版本](https://github.com/kingsic/SGPagingView)


## 结构图
``` 
PagingTitleViewConfigure（PagingTitleView 初始化配置信息）

PagingTitleView（用于与 PagingContent 联动）

PagingContentScrollView（内部由 UIScrollView 实现）

PagingContentCollectionView（内部由 UICollectionView 实现）
``` 


## 效果图
![](https://github.com/kingsic/Kar98k/blob/master/SGPagingView/SGPagingView.gif)


##  Installation
* 1、CocoaPods 导入 pod 'PagingViewKit', '~> 1.0.1'
* 2、下载项目将 “Source” 文件夹内的类拖到到工程中


## 代码介绍
##### PagingViewKit 的使用（详细使用, 请参考 Demo）
```
let configure: PagingTitleViewConfigure = PagingTitleViewConfigure()
// PagingTitle
let pagingTitleView = PagingTitleView(frame: frame, titles: titles, delegate: self, configure: configure)
view.addSubview(pagingTitleView)

// PagingContent
let pagingContent: PagingContentScrollView = PagingContentScrollView(frame: frame, parentVC: self, childVCs: childVCs)
pagingContent.delegate = self
view.addSubview(pagingContent)
```

##### PagingTitleView 代理方法
```
func pagingTitleView(pagingTitleView: PagingTitleView, index: Int) {
    pagingContentView.setPagingContentScrollView(index: index)
}
```

##### PagingContentScrollView 代理方法
```
func pagingContentScrollView(pagingContentScrollView: PagingContentScrollView, progress: CGFloat, currentIndex: Int, targetIndex: Int) {
    pagingTitleView.setPagingTitleView(progress: progress, currentIndex: currentIndex, targetIndex: targetIndex)
}
```


## Requirements
* iOS 10.0 +


## Concluding remarks
* 案例项目 [网易新闻](https://github.com/kingsic/NetEaseNews)
* 更多内容介绍请参考 [OC版](https://github.com/kingsic/SGPagingView)
* 如有问题请参考OC版本介绍或加QQ群：825339547

