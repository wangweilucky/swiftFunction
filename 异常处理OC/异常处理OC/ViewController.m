//
//  ViewController.m
//  异常处理OC
//
//  Created by wangwei on 5/6/20.
//  Copyright © 2020 wangwei. All rights reserved.
//

#import "ViewController.h"
#import "VideoInfo.h"
#import "StatUtility.h"

@interface ViewController ()

@property(nonatomic, strong) NSDictionary<NSString *, VideoInfo *> *videos;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)logVideoPlay:(NSString *)videoUrl {
    VideoInfo *info = self.videos[videoUrl];
    [StatUtility uploadInfo:@{@"video_title":info.videoTitle}];
}

- (void)statVideoPlay1:(NSString *)videoUrl {
    assert(videoUrl != nil);
    VideoInfo *info = self.videos[videoUrl];
    if (info && info.videoTitle) {
        [StatUtility uploadInfo:@{@"video_title":info.videoTitle}];
    }
}

- (void)statVideoPlay2:(NSString *)videoUrl {
    assert(videoUrl != nil);
    VideoInfo *info = self.videos[videoUrl];
    if (info && info.videoTitle) {
        [StatUtility uploadInfo:@{@"video_title":info.videoTitle}];
        //...
        //...
        //...
        [StatUtility uploadInfo:@{@"video_category":info.videoCategory}];
        //...
        //...
        //...
    }
}


@end
