# SGPagingView-Swift

#### [Objective-C Version](https://github.com/kingsic/SGPagingView)
#### iOS技术交流群：429899752


## 结构图
![](https://github.com/kingsic/SGPagingView/raw/master/Picture/SGPagingView.png)
``` 
SGPageTitleViewConfigure（SGPageTitleView 初始化配置信息）

SGPageTitleView（用于与 SGPageContent 联动）

SGPageContentScrollView（内部由 UIScrollView 实现）

SGPageContentCollectionView（内部由 UICollectionView 实现）
``` 


## 效果图
![](https://github.com/kingsic/SGPagingView/raw/master/Picture/sorgle.gif)


## 代码介绍（详细使用, 请参考 Demo）
##### SGPagingView 的使用（详细使用, 请参考 Demo）
```
// SGPageTitleViewConfigure
let configure = SGPageTitleViewConfigure()
// SGPageTitleView
self.pageTitleView = SGPageTitleView(frame: rect, delegate: self, titleNames: titles, configure: configure)
view.addSubview(pageTitleView!)

// SGPageContentScrollView
self.pageContentScrollView = SGPageContentScrollView(frame: contentRect, parentVC: self, childVCs: childVCs)
pageContentScrollView?.delegateScrollView = self
view.addSubview(pageContentScrollView!)
```

##### SGPageTitleView 代理方法
```
func pageTitleView(pageTitleView: SGPageTitleView, index: Int) {
pageContentScrollView?.setPageContentScrollView(index: index)
}
```

##### SGPageContentScrollView 代理方法
```
func pageContentScrollView(pageContentScrollView: SGPageContentScrollView, progress: CGFloat, originalIndex: Int, targetIndex: Int) {
pageTitleView?.setPageTitleView(progress: progress, originalIndex: originalIndex, targetIndex: targetIndex)
}
```


## Concluding remarks

* 更多内容介绍请参考 [OC版](https://github.com/kingsic/SGPagingView)

* 请为我续杯咖啡，谢谢您的支持<br>
![](https://github.com/kingsic/Kar98k/blob/master/Source/wc_admiring_code.png)

