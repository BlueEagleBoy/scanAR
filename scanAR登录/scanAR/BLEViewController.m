//
//  BLEViewController.m
//  增强现实
//
//  Created by BlueEagleBoy on 16/3/5.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import "BLEViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "BLETabBarController.h"
#import "AppDelegate.h"



@interface BLEViewController ()

@property (nonatomic, strong)AVPlayer *player;
@property (nonatomic, strong)AVPlayerViewController *playerVc;

@end

@implementation BLEViewController

- (AVPlayer *)player {
    
    if (!_player) {
        
        NSLog(@"生成palyer");
        
        NSURL *url = [NSURL URLWithString:@"http://192.168.1.44/resources/videos/minion_h264.mp4"];
        
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(didClickBack)];
//    
//    self.navigationItem.leftBarButtonItem = barItem;
//
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, BLEScreenWidth, 40)];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(didClickBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backBtn];
    
    
    
//    [self.player play];
    [self playerPlayerVC];
    
}

- (void)didClickBack {
    
    BLETabBarController *tabBarVc = [[BLETabBarController alloc]init];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = tabBarVc;
}




- (void)playerPlayerVC {
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:@"http://192.168.1.44/resources/videos/minion_h264.mp4"]];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    
    AVPlayerViewController *playerVc = [[AVPlayerViewController alloc]init];
    playerVc.player = player;
    
    playerVc.videoGravity = AVLayerVideoGravityResizeAspect;
    playerVc.showsPlaybackControls = YES;
    [playerVc.player play];
    playerVc.view.frame = CGRectMake(0, 64, BLEScreenWidth, BLEScreenHeight - 64);
    [self.view addSubview:playerVc.view];
    self.playerVc = playerVc;

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    NSLog(@"BLEViewController");
}

@end
