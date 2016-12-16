#HTSegmentsView使用文档



##简介

HTSegmentsView对一组子控件进行“单选”状态管理，并且支持选中状态的切换与动画。HTSegmentsView继承自UIScrollView，支持用户自定义内部cell、选择过渡动画、cell排版，并提供常见的实现：

* 内部cell：HTStringSegmentsCell
* 选择过渡动画：HTSublineSegmentViewAnimator
* cell排版：HTHorizontalSegmentsView、HTVerticalSegmentsView

###注意：
HTSegmentsView是继承自UIScrollView，为了避免NavigationController导致的`-64`的contentOffset问题，需要将HTSegmentsView所在的ViewController的automaticallyAdjustsScrollViewInsets属性设置为NO,或者在合适的时间将修改掉HTSegmentsView的contentOffset值。

###[使用说明](#使用说明)

[1.导入头文件](#导入头文件)

[2.设置ViewController协议和属性](#设置ViewController协议和属性)

[3.实例化SegmentsView](#实例化SegmentsView)

[4.创建并设置DataSource](#创建并设置DataSource)

[5.创建并设置选择过渡动画](#创建并设置选择过渡动画)


###[功能扩展和自定义说明](#功能扩展和自定义说明)

[1.自定义DataSource](#自定义DataSource)

[2.自定义选择过渡动画](#自定义选择过渡动画)

[3.自定义SegmentsView排版](#自定义SegmentsView排版)


<p id="使用说明">
##使用说明

说明：

* 示例使用组件提供的一种水平排版的SegmentsView，用户也可以使用垂直排版的HTHorizontalSegmentsView或者自定义排版的SegmentsView，使用方法类似。如何自定义SegmentsView后文有介绍。
* 示例中使用的HTSegmentsViewDatasource使用的是组件提供的一种文本标签数据源，用户也可以使用自定义的数据源，使用方法类似。如何自定义数据源后文有介绍。
* 示例中使用的HTSublineSegmentViewAnimator是组件提供的一种选择过渡动画的实现，用户也可以使用自定义选择过渡动画，使用方法类似。如何自定义选择过渡动画后文有介绍。


<p id="导入头文件">
1) 导入头文件

```
#import "HTSegmentsView.h"
```
<p id="设置ViewController协议和属性">
2) 设置ViewController协议和属性

```
@interface MyViewController () <HTSegmentsViewDelegate>
@property (nonatomic, strong) HTStringToLabelDataSource *horizontalDataSource;
@property (nonatomic, strong) HTSegmentsView *horizontalSegmentsView;
@end
```
<p id="实例化SegmentsView">
3) 实例化SegmentsView，并设置其代理

```
_horizontalSegmentsView = [[HTHorizontalSegmentsView alloc] initWithSelectedIndex:0];
_horizontalSegmentsView = CGRectMake(30,100,260,50);
_horizontalSegmentsView = self;
_horizontalSegmentsView.needAdjustToCenter = YES;
[self.view addSubview: _horizontalSegmentsView];
```

<p id="创建并设置DataSource">
4) 创建并设置DataSource

```
HTStringToLabelDataSource *dataSource  = [[HTStringToLabelDataSource alloc] initWithArray:@[@"button1",@"button2",@"button3"] segmentCellClass:nil];
dataSource.fontSize = 12;
dataSource.selectedFontSize = 16;
dataSource.textColor = [UIColor blackColor];
dataSource.selectedTextColor = [UIColor redColor];
dataSource.cellWidth = 120;
dataSource.cellHeight = 60;

_horizontalDataSource = dataSource;
_horizontalSegmentsView.segmentsDataSource = dataSource;
```

<p id="创建并设置选择过渡动画">
5) 创建并设置选择过渡动画HTSegmentsViewAnimator

```
HTSublineSegmentViewAnimator *animator = [[HTSublineSegmentViewAnimator alloc] initWithSegmentsView:segmentsView backgroundColor:[UIColor lightGrayColor] lineColor:[UIColor greenColor] lineHeight:5];
animator.animationDuration = 0.3;
_horizontalSegmentsView.animator = animator;
```

<p id="功能扩展和自定义说明">
##功能扩展和自定义说明

<p id="自定义DataSource">
####自定义DataSource
HTSegmentsViewDatasource对于HTSegmentsView类似于UITableViewDataSource对于UITableView的作用，它提供了构建HTSegmentsView所需要的数据信息。

HTStringToLabelDataSource是本组件提供的一种DataSource的实现，用户可以根据需要自定义的DataSource，自定义的DataSource需要遵循HTSegmentsViewDatasource协议。

```
@protocol HTSegmentsViewDatasource <NSObject>

/*!
 *  返回Cell个数，这些HTSegmentsCellView会一次性全部构造出来
 *
 *  @param segmentsView
 *
 *  @return Cell个数
 */
@required
- (NSUInteger)numberOfCellsInSegementsView:(HTSegmentsView*)segmentsView;


/*!
 *  返回index处的HTSegmentsCellView
 *
 *  @param segmentsView
 *  @param index
 *
 *  @return HTSegmentsCellView
 */
@required
- (HTSegmentsCellView*)segmentsView:(HTSegmentsView*)segmentsView cellForIndex:(NSUInteger)index;

/*!
 *  返回每个控件的尺寸。HTSegmentsView是基于UIScrollView实现，所以此接口返回的Size会影响HTSegmentsView的content size，如果需要禁用某个方向的滚动，建议此处返回合适的尺寸，例如使用HTHorizontalSegmentsView时，此接口返回的CGSize的height需要设置成与HTSegmentsView的高度相等；使用HTVerticalSegmentsView时，此接口返回的CGSize的width需要设置成与HTSegmentsView的宽度相等。
 *
 *  @param segmentsView
 *  @param index
 *
 *  @return Cell的尺寸
 */
@required
- (CGSize)segmentsView:(HTSegmentsView*)segmentsView cellSizeForIndex:(NSUInteger)index;

/*!
 *  返回每个控件内容的尺寸，控件内容尺寸一般小于控件尺寸
 *
 *  @param segmentsView
 *  @param index
 *
 *  @return Cell内容的尺寸
 */
@optional
- (CGRect)segmentsView:(HTSegmentsView*)segmentsView cellContentRectForIndex:(NSUInteger)index;

@end
```
<p id="自定义选择过渡动画">
####自定义选择过渡动画
HTSublineSegmentViewAnimator是本组件提供的一种过渡动画实现，支持下划线和背景的过渡动画。用户也可以根据需求，自定义Animator，自定义的Animator需要派生自HTSegmentsViewAnimator，重写如下函数。

```
/*!
 *  从某个index移动到另外一个index，使用percent表示移动的百分比
 *
 *  @param fromIndex 开始的index
 *  @param to        目标的index
 *  @param percent   移动百分比
 *  @param animated  是否使用动画
 */
- (void)moveSegmentFrom:(NSUInteger)fromIndex to:(NSUInteger)to percent:(CGFloat)percent animated:(BOOL)animated;

// liuchang 命名问题，"to:(NSUInteger)to" 改成 "to:(NSUInteger)toIndex" 比较好？


/*!
 *  从当前状态移动到index处的Cell
 *
 *  @param index    移动的目标
 *  @param animated 是否使用动画
 */
- (void)moveToIndex:(NSUInteger)index animated:(BOOL)animated;

/*!
 *  隐藏动画控件
 */
- (void)hide;

/*!
 *  显示动画控件
 */
- (void)show;
```

<p id="自定义SegmentsView排版">
####自定义SegmentsView排版
本组件默认提供了两种排版样式的SegmentsView：HTHorizontalSegmentsView(水平排版)和HTVerticalSegmentsView(垂直排版)，用户可以根据需求自定义cell的排版样式。自定义cell的排版样式可以通过继承HTSegmentsView，重写`- (void)layoutSubviews`的方法，来自定义排版样式。

<p id="自定义HTSegmentsCellView">
####自定义HTSegmentsCellView
HTSegmentsCellView是用于构建HTSegmentsView的子视图单元，用户可以根据需求从HTSegmentsCellView派生出自定义的子视图。本组件提供了HTStringSegmentsCell作为一种实现，用于HTStringToLabelDataSource的默认子视图。

