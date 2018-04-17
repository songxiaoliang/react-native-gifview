//
//  CADisplayLineImage.h
//  LoadGIF
//
//  Created by ZhengWei on 16/4/26.
//  Copyright © 2016年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CADisplayLineImage : UIImage

@property (nonatomic,readonly) NSTimeInterval *frameDurations;
@property (nonatomic,readonly) NSUInteger loopCount;
@property (nonatomic,readonly) NSTimeInterval totalDuratoin;

-(UIImage *)getFrameWithIndex:(NSUInteger)idx;

@end
