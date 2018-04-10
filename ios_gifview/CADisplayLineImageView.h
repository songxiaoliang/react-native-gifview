//
//  CADisplayLineImageView.h
//  LoadGIF
//
//  Created by ZhengWei on 16/4/26.
//  Copyright © 2016年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CADisplayLineImage.h"
@interface CADisplayLineImageView : UIImageView

@property (nonatomic,copy) NSString *runLoopMode;
-(void)stopAnimating;
-(void)startAnimating;
@end
