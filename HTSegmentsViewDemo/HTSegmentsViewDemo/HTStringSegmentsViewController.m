//
//  HTStringSegmentsViewController.m
//  HTUIDemo
//
//  Created by zp on 15/9/7.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "HTStringSegmentsViewController.h"
#import "HTSegmentsView.h"
#import "HTSegmentsViewAnimator.h"
#import "ColorUtils.h"
#import "MCBlurView.h"

static CGFloat kPageWidth = 200;

@interface HTStringSegmentsViewController () <UIScrollViewDelegate, HTSegmentsViewDelegate>

@property (nonatomic, strong) HTStringToLabelDataSource *horizontalDataSource;
@property (nonatomic, strong) HTSegmentsView *horizontalSegmentsView;


@property (nonatomic, strong) HTStringToLabelDataSource *verticalDataSource;
@property (nonatomic, strong) HTSegmentsView *verticalSegmentsView;

@property (nonatomic, strong) UIScrollView *pageScrollView;

@end

@implementation HTStringSegmentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addPageScrollView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _horizontalDataSource = [self createSegmentsViewDataSource:YES];
    _horizontalSegmentsView = [self createSegmentsView:YES];
    [self addSegmentsViewBlurBackground:_horizontalSegmentsView];
    _horizontalSegmentsView.segmentsDataSource = _horizontalDataSource;
    
    _verticalDataSource = [self createSegmentsViewDataSource:NO];
    _verticalSegmentsView = [self createSegmentsView:NO];
    [self addSegmentsViewBlurBackground:_verticalSegmentsView];
    _verticalSegmentsView.segmentsDataSource = _verticalDataSource;
}

- (CGFloat)segmentsViewWidth:(BOOL)bHorizontal
{
    return bHorizontal ? 220 : 100;
}

- (CGFloat)segmentsViewHeight:(BOOL)bHorizontal
{
    return bHorizontal ? 60 : 280;
}

- (id<HTSegmentsViewDatasource>)createSegmentsViewDataSource:(BOOL)bHorizontal
{
    HTStringToLabelDataSource *dataSource = [[HTStringToLabelDataSource alloc] initWithArray:[self stringArray] segmentCellClass:nil];
    dataSource.fontSize = 6;
    dataSource.selectedFontSize = 20;
    dataSource.textColor = [UIColor blackColor];
    dataSource.selectedTextColor = [UIColor redColor];
    dataSource.cellWidth = 120;//width/[self stringArray].count;
    dataSource.cellHeight = bHorizontal ? [self segmentsViewHeight:bHorizontal] : 60;//height;
    
    return dataSource;
}

- (HTSegmentsView*)createSegmentsView:(BOOL)bHorizontal
{
    Class segmentsViewClass = bHorizontal ? HTHorizontalSegmentsView.class : HTVerticalSegmentsView.class;
    HTSegmentsView *segmentsView = [[segmentsViewClass alloc] initWithSelectedIndex:0];
    segmentsView.frame = CGRectMake(bHorizontal ? 100 : 0 , 100, [self segmentsViewWidth:bHorizontal], [self segmentsViewHeight:bHorizontal]);
    segmentsView.layer.borderWidth = 1;
    segmentsView.layer.borderColor = [UIColor redColor].CGColor;
    segmentsView.needAdjustToCenter = YES;
    segmentsView.segmentsDelegate = self;
    
    
    [self.view addSubview:segmentsView];
    
    self.title = @"SegmentsTest";
    self.view.backgroundColor = [UIColor whiteColor];
    
    HTSublineSegmentViewAnimator *animator = [[HTSublineSegmentViewAnimator alloc] initWithSegmentsView:segmentsView backgroundColor:[UIColor lightGrayColor] lineColor:[UIColor greenColor] lineHeight:5];
    animator.lineWidthEqualToCellContent = YES;
    animator.cellContentPadding = 10;
    animator.animationDuration = .25;
    segmentsView.animator = animator;
    
    return segmentsView;
}

- (void)addSegmentsViewBlurBackground:(HTSegmentsView*)segmentsView
{
    MCBlurView *blurView = [[MCBlurView alloc] initWithFrame:segmentsView.frame];
    [self.view insertSubview:blurView belowSubview:segmentsView];
}

- (NSArray*)stringArray
{
    return @[@"button", @"button1button1", @"button2", @"button3",@"button", @"button1", @"button2", @"button3",@"button", @"button1", @"button2", @"button3"];
//    return @[@"button", @"button1"];
}

- (void)addPageScrollView
{
    UIScrollView *sv = [UIScrollView new];
    CGFloat width = kPageWidth, height=200;
    sv.frame = CGRectMake(100, 160, width, height);
    
    NSUInteger count = [self stringArray].count;
    sv.contentSize = CGSizeMake(width * count, height);
    
    [self.view addSubview:sv];
    
    for (int i=0; i<count; i++) {
        UIView *v = [UIView new];
        v.frame = CGRectMake(i * width, 0, width, height);
        v.backgroundColor = [UIColor randomRGBColor];
        
        [sv addSubview:v];
    }
    
    sv.pagingEnabled = YES;
    sv.delegate = self;
    
    _pageScrollView = sv;
    
    [sv addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_horizontalSegmentsView reloadData];
        [_verticalSegmentsView reloadData];
    });
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]){
        CGFloat contentOffset = _pageScrollView.contentOffset.x;
        NSUInteger currentIndex = contentOffset/kPageWidth;
        CGFloat percent = (contentOffset - currentIndex * kPageWidth)/kPageWidth;
        
        if (_pageScrollView.isDragging || _pageScrollView.decelerating){
            [_horizontalSegmentsView moveFrom:currentIndex to:currentIndex+1 percent:percent];
            [_verticalSegmentsView moveFrom:currentIndex to:currentIndex+1 percent:percent];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat contentOffset = _pageScrollView.contentOffset.x;
    NSUInteger currentIndex = contentOffset/kPageWidth;
    
    NSLog(@"%s", __FUNCTION__);
    
    [_horizontalSegmentsView setSelectedIndex:currentIndex animated:NO];
    [_verticalSegmentsView setSelectedIndex:currentIndex animated:NO];
}

#pragma mark HTSegmentsView delegate
- (void)segmentsView:(HTSegmentsView *)segmentsView didSelectedAtIndex:(NSUInteger)index
{
    [_pageScrollView setContentOffset:CGPointMake(index * kPageWidth, 0) animated:YES];
}

- (BOOL)segmentsView:(HTSegmentsView *)segmentsView shouldSelectedAtIndex:(NSUInteger)index
{
    if (index == 2)
        return NO;
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_pageScrollView removeObserver:self forKeyPath:@"contentOffset"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
