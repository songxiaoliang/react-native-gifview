//
//  GIFImageView.h
//  gif
//
//  Created by jayden on 2018/4/3.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "CADisplayLineImageView.h"

@interface GIFImageView : CADisplayLineImageView
@property (nonatomic, assign) BOOL playStatus;
@property (nonatomic, strong) NSString * imageName;
@end
