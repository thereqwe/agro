//
//  ViewController.m
//  YoukuAgroDemo
//
//  Created by Yue Shen on 16/8/25.
//  Copyright © 2016年 Yue Shen. All rights reserved.
//

#import "ViewController.h"
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>
@interface ViewController ()<AgoraRtcEngineDelegate>
{
    AgoraRtcEngineKit *engineKit;
    UIView *ui_view_local_preview;
    UIView *ui_view_remote_preview;
    NSMutableArray<UIView*> *viewArr;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    viewArr = [NSMutableArray new];
    [self setupUI];
    [self setupEngine];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)setupEngine
{
    engineKit = [AgoraRtcEngineKit sharedEngineWithVendorKey:@"773eb3c3fdc141dca3d8d376b8960609" delegate:self];
    int rst;
   
    rst = [engineKit enableVideo];
    [engineKit joinChannelByKey:NULL channelName:@"14" info:@"hello" uid:100 joinSuccess:^(NSString *channel, NSUInteger uid, NSInteger elapsed) {
        NSLog(@"%@",channel);
    }];
    AgoraRtcVideoCanvas *canvas = [[AgoraRtcVideoCanvas alloc]init];
    canvas.view = ui_view_local_preview;
    canvas.uid = 100;
    [engineKit setupLocalVideo:canvas];
}

- (void)setupUI
{
    ui_view_local_preview = [UIView new];
    ui_view_local_preview.frame = (CGRect){0,20,200,200};
    [self.view addSubview:ui_view_local_preview];
    
    ui_view_remote_preview = [UIView new];
    ui_view_remote_preview.frame = (CGRect){0,200,200,200};
    [self.view addSubview:ui_view_remote_preview];
    
    
    ui_view_remote_preview.frame = (CGRect){0,23,34,56};
    NSLog(@"change the camera");
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoDecodedOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed
{
    NSLog(@"First Remoto Videodecoded====>%lu",(unsigned long)uid);
    //add(23);
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed
{
    NSLog(@"join====>%lu",(unsigned long)uid);
    AgoraRtcVideoCanvas *canvas = [[AgoraRtcVideoCanvas alloc]init];
    canvas.view = ui_view_remote_preview;
    canvas.uid = uid;
    [engineKit setupRemoteVideo:canvas];
}
@end
