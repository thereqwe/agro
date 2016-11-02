//
//  YKChatViewController.m
//  YoukuAgroDemo
//
//  Created by Yue Shen on 2016/10/25.
//  Copyright © 2016年 Yue Shen. All rights reserved.
//

#import "YKChatViewController.h"
#import "Masonry.h"
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
@interface YKChatViewController ()<AgoraRtcEngineDelegate>

@end

@implementation YKChatViewController
{
    NSMutableArray<UIView*> *chatViewArr;
    AgoraRtcEngineKit *engineKit;
    NSMutableArray<NSNumber*> *chatStatusArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupEnv];
}

- (void)setupEnv {
    engineKit = [AgoraRtcEngineKit sharedEngineWithVendorKey:@"773eb3c3fdc141dca3d8d376b8960609" delegate:self];
    int rst;
    
    rst = [engineKit enableVideo];
    int x = arc4random() % 100;
    [engineKit joinChannelByKey:NULL channelName:@"shit"info:@"hello" uid:x joinSuccess:^(NSString *channel, NSUInteger uid, NSInteger elapsed) {
        NSLog(@"%@",channel);
    }];
    AgoraRtcVideoCanvas *canvas = [[AgoraRtcVideoCanvas alloc]init];
    canvas.view = chatViewArr[4];
    chatStatusArr[4]=@1;
    canvas.uid = 100;
    [engineKit setupLocalVideo:canvas];
}

- (void)setupUI {
    chatViewArr = [NSMutableArray new];
    chatStatusArr = [NSMutableArray new];
    NSArray *ptArr = @[@[@0,@0],@[@1,@0],@[@2,@0],
                       @[@0,@1],@[@1,@1],@[@2,@1],
                       @[@0,@2],@[@1,@2],@[@2,@2],
                       ];
    CGFloat cellHeight = kScreenHeight/3;
    CGFloat cellWidth  = kScreenWidth/3;
    for(int i=0;i<9;i++){
        UILabel *lb = [UILabel new];
        lb.text = [NSString stringWithFormat:@"%d",i];
        lb.frame = CGRectMake(0, 0, 20, 20);
        UIView *view = [UIView new];
        [view addSubview:lb];
        view.backgroundColor = [UIColor brownColor];
        view.layer.borderWidth = 1;
        view.layer.borderColor = [UIColor whiteColor].CGColor;
        CGFloat x =  cellWidth*[(NSNumber*)ptArr[i][0] floatValue];
        CGFloat y =  cellHeight*[(NSNumber*)ptArr[i][1] floatValue];
        view.frame = CGRectMake(x, y, cellWidth, cellHeight);
        [chatViewArr addObject:view];
        [chatStatusArr addObject:@0];
        [self.view addSubview:view];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoDecodedOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed
{
    NSLog(@"First Remoto Videodecoded====>%lu",(unsigned long)uid);
    UIView *view = [UIView new];
    view.frame = (CGRect){123,123,123,123};
    //add(23);
}


- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed
{
    for(int i=0;i<9;i++){
        if([chatStatusArr[i] isEqualToNumber:@0]){
            NSLog(@"join====>%lu",(unsigned long)uid);
            AgoraRtcVideoCanvas *canvas = [[AgoraRtcVideoCanvas alloc]init];
            canvas.view = chatViewArr[i];
            chatStatusArr[i]=@1;
            canvas.uid = uid;
            [engineKit setupRemoteVideo:canvas];
            break;
        }
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOccurError:(AgoraRtcErrorCode)errorCode {
    NSLog(@"err--%ld",(long)errorCode);
    NSLog(@"log the");
    NSLog(@"123");
}
@end
