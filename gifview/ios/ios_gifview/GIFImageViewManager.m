//
//  GIFImageViewManager.m
//  gif
//
//  Created by jayden on 2018/4/3.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "GIFImageViewManager.h"
#import "GIFImageView.h"

#import <React/RCTEventDispatcher.h>  //事件派发，不导入会引起Xcode警告
#import <React/RCTBridge.h>           //进行通信的头文件


@implementation GIFImageViewManager

//  标记宏（必要）
RCT_EXPORT_MODULE()
RCT_EXPORT_VIEW_PROPERTY(playStatus, BOOL);
RCT_EXPORT_VIEW_PROPERTY(imageName, NSString);

- (UIView *)view{
  return [GIFImageView new];
}
@end
