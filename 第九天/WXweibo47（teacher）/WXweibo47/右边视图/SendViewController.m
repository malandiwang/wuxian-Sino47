//
//  SendViewController.m
//  WXweibo47
//
//  Created by imac on 15/9/21.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "SendViewController.h"
#import "RootDrawerController.h"
#import "ZoomImageView.h"
#import "UIProgressView+AFNetworking.h"

@interface SendViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZoomImageViewDelegate>
{
    //文本框
    UITextView *_textView;
    //编辑控件视图
    UIView *_editorBar;
    //选择图片视图
    ZoomImageView *_sendImgView;
    //要发送的图片
    UIImage *_sendImage;
    
    
}
@end

@implementation SendViewController

- (void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //让当前对象监听键盘高度改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardDidChangeFrameNotification object:nil];

    
    //创建导航栏视图
    [self _loadNavigationViews];
    
    //创建编辑模块
    [self _loadEditorViews];
    
    

}

//让当前对象监听键盘高度改变的通知
- (void)keyboardAction:(NSNotification *)notification
{
    //拿到通知里面的userInfo参数
    NSDictionary *userInfo = notification.userInfo;
    //拿到当前键盘的y坐标
    CGFloat keyboard_y = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
//    NSLog(@"%.2f", keyboard_y);
    
    //根据键盘的y坐标来改变编辑控件的坐标
    if (keyboard_y >= kScreenHeight) {
        _editorBar.bottom = kScreenHeight - 64;
    }else {
        _editorBar.bottom = keyboard_y - 64;
    }
}


//创建编辑模块
- (void)_loadEditorViews
{
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.font = [UIFont systemFontOfSize:16.0];
    //作为第一响应者
    [_textView becomeFirstResponder];
    [self.view addSubview:_textView];
    
    
    //创建工具栏和工具栏上的多个按钮
    _editorBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 64 - 55, kScreenWidth, 55)];
    _editorBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_editorBar];
    
    NSArray *imgs = @[
                      @"compose_toolbar_1.png",
                      @"compose_toolbar_4.png",
                      @"compose_toolbar_3.png",
                      @"compose_toolbar_6.png",
                      @"compose_toolbar_5.png"
                      ];
    for (int i = 0; i < imgs.count; i++) {
        NSString *imgName = imgs[i];
        
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake((kScreenWidth/5)*i + 15, 20, 40, 33)];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10 + i;
        button.imgName = imgName;
        [_editorBar addSubview:button];
    }
    
}

//编辑按钮
- (void)buttonAction:(ThemeButton *)btn
{
    if (btn.tag == 10) {
        //选择图片
        //弹出提示框
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            //取消
            _sendImage = nil;
            [_sendImgView removeFromSuperview];
            _sendImgView = nil;
            
            //还原编辑控件的偏移
            for (int i = 0; i < 4; i ++) {
                ThemeButton *btn = (ThemeButton *)[_editorBar viewWithTag:10 + i];
                btn.transform = CGAffineTransformIdentity;
            
            }
            
        }];
        
        UIAlertAction *camara = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //拍照
            //判断是否有摄像头
            BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
            
            if (!isCamera) {
                //提示用户没有摄像头
            UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有摄像头" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
            [alertCtrl addAction:action];
            //模态弹出提示框
            [self presentViewController:alertCtrl animated:YES completion:nil];
                
                return;
            }
            
            //来自相机
            UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
            //图片来源
            imgPicker.sourceType =UIImagePickerControllerSourceTypeCamera;
            imgPicker.delegate = self;
            
            [self presentViewController:imgPicker animated:YES completion:nil];
            
        }];

        UIAlertAction *photo = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //相册
            //来自相册
            UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
            //图片来源
            imgPicker.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
            
            imgPicker.delegate = self;
            
            [self presentViewController:imgPicker animated:YES completion:nil];
            
        }];

        [alertCtrl addAction:camara];
        [alertCtrl addAction:photo];
        [alertCtrl addAction:cancle];
        
        [self presentViewController:alertCtrl animated:YES completion:nil];
        
        
    }else if (btn.tag == 11){
        //...
    }else if (btn.tag == 12){
        //
    }else if (btn.tag == 13){
        
    }
    
    
}
/**
 *  相册相机的代理方法
 *
 *  @param picker      返回的控制器
 *  @param image       返回选择的图片
 *  @param editingInfo 编辑的信息
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    //模态消失
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    //初始化选择的视图
    if (_sendImgView == nil) {
        _sendImgView = [[ZoomImageView alloc] initWithFrame:CGRectMake(10, 20, 30, 30)];
        
        _sendImgView.layer.cornerRadius = 5;
        _sendImgView.layer.masksToBounds = YES;
        _sendImgView.contentMode = UIViewContentModeScaleAspectFit;
        //添加放大手势
        [_sendImgView addTapZoomInImageViewWithFullUrlString:nil];
        //设置代理
        _sendImgView.zoomDelegate = self;
        
        [_editorBar addSubview:_sendImgView];
        
        
        //设置编辑控件的偏移
        for (int i = 0; i < 4; i ++) {
            ThemeButton *btn = (ThemeButton *)[_editorBar viewWithTag:10 + i];
            btn.transform = CGAffineTransformTranslate(btn.transform, 30 - i * 5, 0);
            
        }
    }
    
    //把图片给_sendImgView
    _sendImgView.image = image;
    
    //发送
    _sendImage = image;
    
    //返回写微博界面，_textView为第一响应者，也可以放在这里（或者下面的一种方法）最好用下面的方法
//    [_textView becomeFirstResponder];

}

//选择完图片后，_textView为第一响应者
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_textView becomeFirstResponder];
}



//创建导航栏视图
- (void)_loadNavigationViews
{
    //左边自定义按钮
    ThemeButton *leftBtn = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    leftBtn.imgName = @"button_icon_close.png";
    [leftBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //右边自定义按钮
    ThemeButton *rightBtn = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    rightBtn.imgName = @"button_icon_ok.png";
    [rightBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;

    
}

//关闭微博
- (void)closeAction
{
    __weak RootDrawerController *rootCtrl = (RootDrawerController *)self.view.window.rootViewController;
    //关闭模态
    [self dismissViewControllerAnimated:YES completion:^{
        
        //返回后，关闭侧滑，使用MMDraw里面的方法
        [rootCtrl closeDrawerAnimated:YES completion:nil];
        
    }];
    
}
//发送微博
- (void)sendAction
{
    //做本地判断
    NSString *text = _textView.text;
    NSString *error = nil;
    if (text.length == 0) {
        error = @"微博内容为空";
    }else if (text.length > 140) {
        error = @"微博内容大雨140字符";
    }
    
    if (error != nil) {
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"提示" message:error preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
        [alertCtrl addAction:action];
        //模态弹出提示框
        [self presentViewController:alertCtrl animated:YES completion:nil];
        return;
    }
    
    //发送微博
    [self sendWeiboWithText:text];

}

//发送微博（请求网络）
- (void)sendWeiboWithText:(NSString *)text
{
    //第三方
//    [self showHUD:@"正在发送"];
    

    //-----------第一种方法-------------//
//    //第六个，UILabel
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 100)/2, 0, 100, 15)];
//    label.text = @"正在上传";
//    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = [UIColor whiteColor];
//    label.font = [UIFont boldSystemFontOfSize:12];

    //请求网络
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:text forKey:@"status"];
    
    NSString *urlStr = nil;
    if (_sendImage == nil) {
        //没有图片参数
        urlStr = statuses_update;
    }else {
        //有图片
        urlStr = statuses_upload;
        //把图片封装成NSData类型，作为参数去请求网络
        //图片转化成data
        NSData *data = UIImageJPEGRepresentation(_sendImage, 1);
        
        //如果数据大于1M，则压缩
        if (data.length > 1024 * 1024) {
            //压缩为0.3
            data = UIImageJPEGRepresentation(_sendImage, 0.3);
        }
        //加入请求参数
        [params setValue:data forKey:@"pic"];
    }
    
    
    _sendOpertion = [DataService requestWithURL:urlStr
                         params:params
                     httpMethod:@"POST"
                 finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
                     //发送成功
//                     [self completeHUD:@"发送成功"];
                     //界面返回
//                     [self closeAction];
                     
                     //-----------第一种方法-------------//
//                  label.text = @"发送成功";
//                     //3秒后把windo隐藏
//                     [self performSelector:@selector(removeWindow) withObject:nil afterDelay:3];
                     //-----------第二种方法-------------//

                     [self sendTipWindow:@"发送成功" show:NO];
                                      }
                   failuerBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                       
                       //发送失败
//                       [self completeHUD:@"发送失败"];
                       //-----------第一种方法-------------//

//                       label.text = @"发送失败";
//                       //3秒后把window隐藏了
//                       [self performSelector:@selector(removeWindow) withObject:nil afterDelay:3];

                       //-----------第二种方法-------------//
                       
                       [self sendTipWindow:@"发送失败" show:NO];

                   }];
    
    
    //-----------第二种方法-------------//
    
    [self sendTipWindow:@"正在上传" show:YES];

    //界面返回
    [self closeAction];
    
    //-----------------第一种方法-------------------//
//    //拿到代理
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    
//    delegate.secondWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
//    delegate.secondWindow.hidden = NO;
//    delegate.secondWindow.backgroundColor = [UIColor grayColor];
//    //优先级
//    delegate.secondWindow.windowLevel = UIWindowLevelStatusBar;
//    
//    UIProgressView *progress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 15, kScreenWidth, 5)];
//    //已经加载的
//    progress.progressTintColor = [UIColor redColor];
//    //没有加载的
//    progress.trackTintColor = [UIColor greenColor];
//    
//    [delegate.secondWindow addSubview:progress];
//
//    [progress setProgressWithUploadProgressOfOperation:opertion animated:YES];
//    
//    [delegate.secondWindow addSubview:label];
//    

}

//解决放大缩小图片时产生的bug
#pragma mark -ZoomImageViewDelegate
//放大后调用的方法
- (void)zoomImageViewDidIn
{
    //注销为第一响应者
    [_textView resignFirstResponder];
}

//缩小以后调用的方法
- (void)zoomImageViewDidOut
{
    //作为第一响应者
    [_textView becomeFirstResponder];
    
}

//第一种方法
////发送成功
//- (void)removeWindow
//{
//    //拿到代理
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    delegate.secondWindow.hidden = YES;
//    
//}












- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
