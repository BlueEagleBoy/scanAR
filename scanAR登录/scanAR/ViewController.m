//
//  ViewController.m
//  毕业设计
//
//  Created by BlueEagleBoy on 16/2/4.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import "ViewController.h"
#import "StrokedRectangle.h"
#import "ExternalRenderer.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

#import <WikitudeNativeSDK/WikitudeNativeSDK.h>
#import "AppDelegate.h"
#import "BLEViewController.h"
#import "ExternalEAGLView.h"



@interface ViewController ()<WTWikitudeNativeSDKDelegate,WTCloudTrackerDelegate>

//wikitSDK
@property (nonatomic, strong)WTWikitudeNativeSDK *wikitudeSDK;
//云端追踪器
@property (nonatomic, strong)WTCloudTracker *cloudTracker;

@property (nonatomic, copy)WTWikitudeUpdateHandler wikitudeUpdateHandler;
@property (nonatomic, copy)WTWikitudeDrawHandler wikitudeDrawHandler;
@property (nonatomic, strong)EAGLContext *sharedWikitudeEAGLCameraContext;
@property (nonatomic, assign) BOOL isTracking;
@property (nonatomic, strong) ExternalRenderer *renderer;
@property (nonatomic, strong) StrokedRectangle *renderableRectangle;
@property (nonatomic, assign) BOOL isContinuousRecognitionActive;
//@property (weak, nonatomic) IBOutlet UIButton *continuousButton;

@property (nonatomic, strong)AVPlayer *player;
@property (nonatomic, strong)ExternalEAGLView *eaglView;
@property (nonatomic, strong)UIButton *continuousButton;
@property (nonatomic, strong)UIImageView *lineImg;
@end

@implementation ViewController

- (void)loadView {
    
    ExternalEAGLView *eaglView = [[ExternalEAGLView alloc]init];
    self.eaglView = eaglView;
    self.view = eaglView;

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.cloudTracker stopContinuousRecognition];
    self.cloudTracker = nil;
//    self.renderer = nil;
}

- (AVPlayer *)player {
    
    if (!_player) {
        
        NSLog(@"生成palyer");
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
        view.backgroundColor = [UIColor redColor];
        [self.eaglView addSubview:view];
        
        NSURL *url = [NSURL URLWithString:@"http://192.168.1.44/resources/videos/minion_01.mp4"];
        
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
        
        _player = [AVPlayer playerWithPlayerItem:item];
        
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        playerLayer.frame = CGRectMake(0, 0, 300, 200);
        
        [self.view.layer addSublayer:playerLayer];
    }
    
    return _player;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏的样式
    [self setupNavigationBar];
    
    self.tabBarController.tabBar.hidden = YES;
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, BLEScreenHeight - 50, 200, 30)];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.eaglView addSubview:button];
    self.continuousButton = button;
    [button setTitle:@"开始识别" forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(startRecognize:) forControlEvents:UIControlEventTouchUpInside];
    
    [self shareInstance];
}

- (void)setupNavigationBar {
    
    //设置导航栏的背景颜色为透明
    [self.tabBarController.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    //设置导航栏的背景图片
    [self.tabBarController.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    //取消导航栏的阴影
    self.tabBarController.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
    //设置导航栏的渲染颜色
    self.tabBarController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //设置返回按钮的图片
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"mainVC_top_backButton_image"] style:UIBarButtonItemStyleDone target:self action:@selector(didClickGoBack)];
    self.tabBarController.navigationItem.leftBarButtonItem = backItem;
    
    //设置转换摄像头的图片
    UIButton *transformCamera = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [transformCamera setBackgroundImage:[UIImage imageNamed:@"mainVC_change_camare_bg"] forState:UIControlStateNormal];
    self.tabBarController.navigationItem.titleView = transformCamera;
    
    //设置搜索按钮的图片
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"mainVC_search_button_bg"] style:UIBarButtonItemStyleDone target:self action:@selector(didClickSearchItem)];
    self.tabBarController.navigationItem.rightBarButtonItem = searchItem;
    
}



- (void)didClickSearchItem {
    
    NSLog(@"didClick");
    
}

- (void)shareInstance {
    
    self.renderer = [[ExternalRenderer alloc] init];
    self.renderableRectangle = [[StrokedRectangle alloc] init];
    self.renderableRectangle.scale = 320.0f;
    
    //创建wikitudeSDK对象
    self.wikitudeSDK = [[WTWikitudeNativeSDK alloc]initWithRenderingMode:WTRenderingMode_External delegate:self];
    
    [self.wikitudeSDK setLicenseKey:kWTLicenseKey];
    
}


- (void)didClickGoBack {
    
    NSLog(@"goback");
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    
    [self.renderer setupRenderingWithLayer:[self.eaglView eaglLayer]];
    [self.renderer startRenderLoopWithRenderBlock:[self renderBlock]];
    
    [self.wikitudeSDK start:nil completion:^(BOOL isRunning, NSError * _Nonnull error) {
        
        if (!isRunning) {
            
            NSLog(@"wikitude没有运行，rease:%@",[error localizedDescription]);
        }else {
            
            self.cloudTracker = [self.wikitudeSDK.trackerManager createCloudTrackerWithToken:@"e0a6784d7c3da1a64cb5c62891554253" targetCollectionId:@"56b389a86e97035403141ff0" extendedTargets:nil andDelegate:self];
            
        }
    }];
}


- (IBAction)startRecognize:(id)sender {
    self.isContinuousRecognitionActive = !self.isContinuousRecognitionActive;
    
    if ( self.isContinuousRecognitionActive )
    {
        if ( self.cloudTracker && self.cloudTracker.isLoaded )
        {
            //接收到回调
            [self.cloudTracker startContinuousRecognitionWithInterval:1.5 successHandler:^(WTCloudRecognitionResponse *response) {
                NSLog(@"received continuous response...");
                if ( response.recognized ) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.cloudTracker stopContinuousRecognition];
                        [self.continuousButton setTitle:@"Start Continuous Recognition" forState:UIControlStateNormal];
                    });
                }
            } interruptionHandler:nil errorHandler:^(NSError *error) {
            }];
            [self.continuousButton setTitle:@"Stop Continuous Recognition" forState:UIControlStateNormal];
        }
        else
        {
            NSLog(@"Cloud tracker is not ready yet. Wait for -cloud");
        }
    }
    else
    {
        [self.cloudTracker stopContinuousRecognition];
        [self.continuousButton setTitle:@"Start Continuous Recognition" forState:UIControlStateNormal];
    }
}

#pragma mark - ExternalRenderer render loop
- (ExternalRenderBlock)renderBlock
{

    return ^ (CADisplayLink *displayLink) {
        if ( self.wikitudeUpdateHandler
            &&
            self.wikitudeDrawHandler )
        {
            self.wikitudeUpdateHandler();
            self.wikitudeDrawHandler();
        }
        
        [self.renderer bindBuffer];
        
        if ( _isTracking )
        {
            [self.renderableRectangle drawInContext:[self.renderer internalContext]];
        }
    };
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [self.wikitudeSDK shouldTransitionToSize:size withTransitionCoordinator:coordinator];
}


#pragma mark WTWikitudeNativeSDKDelegte的代理方法
- (void)wikitudeNativeSDK:(WTWikitudeNativeSDK * __nonnull)wikitudeNativeSDK didCreatedExternalUpdateHandler:(WTWikitudeUpdateHandler __nonnull)updateHandler
{
    self.wikitudeUpdateHandler = updateHandler;
}

- (void)wikitudeNativeSDK:(WTWikitudeNativeSDK * __nonnull)wikitudeNativeSDK didCreatedExternalDrawHandler:(WTWikitudeDrawHandler __nonnull)drawHandler
{
    self.wikitudeDrawHandler = drawHandler;
}

- (EAGLContext *)eaglContextForVideoCameraInWikitudeNativeSDK:(WTWikitudeNativeSDK * __nonnull)wikitudeNativeSDK
{
    if (!_sharedWikitudeEAGLCameraContext )
    {
        EAGLContext *rendererContext = [self.renderer internalContext];
        self.sharedWikitudeEAGLCameraContext = [[EAGLContext alloc] initWithAPI:[rendererContext API] sharegroup:[rendererContext sharegroup]];
    }
    return self.sharedWikitudeEAGLCameraContext;
}

- (CGRect)eaglViewSizeForExternalRenderingInWikitudeNativeSDK:(WTWikitudeNativeSDK * __nonnull)wikitudeNativeSDK
{
    return self.eaglView.bounds;
}

- (void)wikitudeNativeSDK:(WTWikitudeNativeSDK * __nonnull)wikitudeNativeSDK didEncounterInternalError:(NSError * __nonnull)error
{
    NSLog(@"Internal Wikitude SDK error encounterd. %@", [error localizedDescription]);
}


#pragma  mark 云端追踪器的代理方法
- (void)cloudTrackerFinishedLoading:(WTCloudTracker *)cloudTracker {
    
    NSLog(@"云端追踪器加载完成");
    
}

- (void)cloudTracker:(WTCloudTracker *)cloudTracker failedToLoadWithError:(NSError *)error {
    
    NSLog(@"云端追踪器加载失败%@",[error localizedDescription]);
}

#pragma mark获取追踪数据的代理方法
//会在新目标在当前摄像头画面中被发现时调用:识别开始
- (void)baseTracker:(WTBaseTracker *)baseTracker didRecognizedTarget:(WTImageTarget *)recognizedTarget {
    
    NSLog(@"获取到目标%@",recognizedTarget.name);
    [self.renderer stopRenderLoop];
    BLEViewController *viewVc = [[BLEViewController alloc]init];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = viewVc;
    
    self.isTracking = NO;
    
}
//会在已知目标移动到新位置时调用:被识别中
- (void)baseTracker:(WTBaseTracker *)baseTracker didTrackTarget:(WTImageTarget *)trackedTarget {
    
    NSLog(@"正在识别");
    
    NSLog(@"%@",[NSThread currentThread]);
    
    [self.renderableRectangle setProjectionMatrix:trackedTarget.projection];
    [self.renderableRectangle setModelViewMatrix:trackedTarget.modelView];

    [self.renderer teardownRendering];
    
}
//会在已知目标无法在最后一帧摄像头画面中找不到时调用:识别结束
- (void)baseTracker:(WTBaseTracker *)baseTracker didLostTarget:(WTImageTarget *)lostTarget {
    
    NSLog(@"目标丢失:%@",lostTarget.name);
    self.isTracking = NO;
    
}

- (BOOL)prefersStatusBarHidden {
    
    return YES;
}

- (void)dealloc {
    
    NSLog(@"viewcontroller  dealloc");
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

@end
