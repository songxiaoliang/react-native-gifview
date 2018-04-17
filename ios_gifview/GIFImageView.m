//
//  GIFImageView.m
//  gif
//
//  Created by jayden on 2018/4/3.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "GIFImageView.h"

@implementation GIFImageView
-(void)setImageName:(NSString *)imageName{
  if ([imageName hasPrefix:@"http"]) {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
      NSData *urlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageName]];
      dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf setImage: [CADisplayLineImage imageWithData:urlData]];
      });
    });
  } else {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
    [self setImage:[CADisplayLineImage imageWithContentsOfFile:filePath]];
  }
}


-(void)setPlayStatus:(BOOL)playStatus{
  if (playStatus) {
    [self startAnimating];
  } else {
    [self stopAnimating];
  }
}

@end
