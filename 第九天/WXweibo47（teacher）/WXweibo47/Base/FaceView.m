//
//  FaceView.m
//  WXweibo47
//
//  Created by imac on 15/9/22.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "FaceView.h"

#define face_width 30.0
#define face_height 30.0

#define item_width (kScreenWidth/7.0)
#define item_height (kScreenWidth/7.0)

@implementation FaceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //...
        //处理数据
        [self _initData];
    }
    return self;
}

- (void)_initData
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    
    NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
    
    _items = [NSMutableArray array];
    
    NSMutableArray *item2D = nil;
    
    for (int i = 0; i < array.count; i ++) {
        if (item2D == nil || item2D.count == 28) {
            item2D = [NSMutableArray array];
            [_items addObject:item2D];
        }
        
        NSDictionary *dic = array[i];
        [item2D addObject:dic];
        
    }
    
    self.width = kScreenWidth * _items.count;
    self.height = item_height * 4;
    
    //初始化放大镜视图
    _magnifierView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 92)];
    _magnifierView.hidden = YES;
    _magnifierView.backgroundColor = [UIColor clearColor];
    _magnifierView.image = [UIImage imageNamed:@"emoticon_keyboard_magnifier.png"];
    [self addSubview:_magnifierView];
    
    //创建表情视图
    UIImageView *faceItem = [[UIImageView alloc] initWithFrame:CGRectMake((64 - face_width)/2, 15, face_width, face_height)];
    faceItem.tag = 2015;
    faceItem.backgroundColor = [UIColor clearColor];
    [_magnifierView addSubview:faceItem];
    
    
}

//把表情画上去
- (void)drawRect:(CGRect)rect
{
    int row = 0; //行
    int colum = 0; //列
    
    for (int i = 0; i < _items.count; i ++) {
        NSArray *item2D = [_items objectAtIndex:i];
        for (int j = 0; j < item2D.count; j ++) {
            NSDictionary *dic = [item2D objectAtIndex:j];
            NSString *imgName = [dic objectForKey:@"png"];
            
            UIImage *image = [UIImage imageNamed:imgName];
            
            CGFloat x = kScreenWidth * i + item_width * colum +(item_width - face_width)/2;
            CGFloat y = item_height * row + (item_height - face_height) / 2;
            
            
            [image drawInRect:CGRectMake(x, y, face_width, face_height)];
            
            colum ++;
            if (colum == 7) {
                row ++;
                colum = 0;
            }
            
            if (row == 4) {
                row = 0;
            }
        }
    
    }
    
    
}

#pragma mark -Touch Methed

- (void)touchFaceItem:(CGPoint )point
{
    _magnifierView.hidden = NO;
    
    
    //计算那一页
   NSInteger page = point.x / kScreenWidth;
    //安全判断
    if (page > _items.count) {
        _magnifierView.hidden = YES;
        return;
    }
    
    //计算行
    NSInteger row = point.y / item_height;
    NSInteger colum = (point.x - kScreenWidth *page) / item_width;
    //限制行和列的取值范围
    row = MAX(0, row);
    row = MIN(row, 3);
    colum = MAX(0, colum);
    colum = MIN(colum, 6);
    
    //计算出索引值
    NSInteger index = row * 7 + colum;
    
    NSArray *item2D = [_items objectAtIndex:page];
    
    //安全判断
    if (index >= item2D.count) {
        _magnifierView.hidden = YES;
        _selectedFaceName = nil;
        return;
    }
    
    NSDictionary *dic = [item2D objectAtIndex:index];
    
    //图片地址
    NSString *imgName = [dic objectForKey:@"png"];
    //表情的名字
    NSString *faceName = [dic objectForKey:@"chs"];
    
    //优化代码
    if (![faceName isEqualToString:_selectedFaceName]) {
        //给放大镜上的表情视图赋值
        UIImageView *facImgView =(UIImageView*)[_magnifierView viewWithTag:2015];
        facImgView.image = [UIImage imageNamed:imgName];
        
        //设置放大镜的位置
        //设置横坐标
        CGFloat x = page * kScreenWidth + colum * item_width + 0.5 * item_width;
        _magnifierView.center = CGPointMake(x, 0);
        
        //设置纵坐标
        CGFloat y = row * item_height + 0.5 * item_height;
        _magnifierView.bottom = y;

        _selectedFaceName = faceName;

    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _magnifierView.hidden = NO;
    
    //禁止滑动
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = NO;
    }

    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    //调用自定义方法，处理坐标
    [self touchFaceItem:point];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    //调用自定义方法，处理坐标
    [self touchFaceItem:point];

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _magnifierView.hidden = YES;
    
    //打开滑动视图
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = YES;
    }

    //回调block
    if (self.block) {
        
        self.block(_selectedFaceName);
    }
    
}










//-------------------text------------------//
////触摸点击
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = touches.anyObject;
//    
////    UIView *touchView = touch.view;
//    
//    CGPoint point = [touch locationInView:self];
////    NSLog(@"x------%.2f,y--------%.2f", point.x, point.y);
//    NSInteger i = point.x / kScreenWidth;   //第几页
//    NSInteger j = point.y / item_height;    //第几行
//    //第几列
//    NSInteger k = (point.x - (kScreenWidth * i)) / item_width;
//    
//    NSArray *array2D = _items[i];
//    NSInteger imgPoint = k + j * 7;
//    
//    NSDictionary *dic = [array2D objectAtIndex:imgPoint];
//    
//    NSString *imgName = [dic objectForKey:@"cht"];
//    
//    NSLog(@"%@", imgName);
//
//    
//}


@end
