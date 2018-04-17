//
//  CADisplayLineImageView.m
//  LoadGIF
//
//  Created by ZhengWei on 16/4/26.
//  Copyright © 2016年 Bourbon. All rights reserved.
//

#import "CADisplayLineImageView.h"

@interface CADisplayLineImageView ()
{
    int tmp;
}
@property (nonatomic) NSUInteger currentFrameIndex;
@property (nonatomic,strong) CADisplayLineImage *animatedImage;
@property (nonatomic,strong) CADisplayLink *displayLink;
@property (nonatomic) NSTimeInterval accumulator;
@property (nonatomic,strong) UIImage *currentFrame;
@property (nonatomic) NSUInteger loopCountdown;

@end
@implementation CADisplayLineImageView

const NSTimeInterval kMaxTimeStep = 1;
@synthesize runLoopMode = _runLoopMode;
@synthesize displayLink = _displayLink;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init
{
    if (self = [super init]) {
        self.currentFrameIndex = 0;
    }
    return self;
}
-(CADisplayLink *)displayLink
{
    //如果有superview就是已经创建了，创建时新建一个CADisplayLink，并制定方法，最后加到一个Runloop中，完成创建
    if (self.superview) {
        if (!_displayLink && self.animatedImage) {
            
            _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeKeyframe:)];
            [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:self.runLoopMode];
        }
    }else{
        [_displayLink invalidate];
        _displayLink = nil;
    }
    return _displayLink;
}
-(NSString *)runLoopMode
{
    return _runLoopMode ?: NSRunLoopCommonModes;
}
-(void)setRunLoopMode:(NSString *)runLoopMode{
    //这个地方需要重写，因为CADisplayLink是依赖在runloop中的，所以如果设置了imageview的runloop的话
    //就要停止动画，并重新设置CADisplayLink对应的runloop，最后在根据情况是否开始动画
    if (runLoopMode != _runLoopMode) {
        [self stopAnimating];
        NSRunLoop *runloop = [NSRunLoop mainRunLoop];
        [self.displayLink removeFromRunLoop:runloop forMode:_runLoopMode];
        [self.displayLink addToRunLoop:runloop forMode:runLoopMode];
        
        _runLoopMode = runLoopMode;
        [self startAnimating];
    }
}
-(void)setImage:(UIImage *)image
{
    if (image == self.image) {
        return;
    }
    
    [self stopAnimating];
    
    self.currentFrameIndex = 0;
    self.loopCountdown = 0;
    self.accumulator = 0;
    if ([image isKindOfClass:[CADisplayLineImage class]] && image.images) {
        
        //设置静止态的图片
        if (image.images[0]) {
            [super setImage:image.images[0]];
        }else{
            [super setImage:nil];
        }
        self.currentFrame = nil;
        self.animatedImage = (CADisplayLineImage *)image;
        self.loopCountdown = self.animatedImage.loopCount ? : NSUIntegerMax;
        [self startAnimating];
        
    }else{
        self.animatedImage = nil;
        [super setImage:image];
    }
    [self.layer setNeedsDisplay];
}
//如果知道这个图就是gif，那可以直接调用这个方法
-(void)setAnimatedImage:(CADisplayLineImage *)animatedImage
{
    _animatedImage = animatedImage;
    if (animatedImage == nil) {
        self.layer.contents = nil;
    }
}
//判断是否正在进行动画
-(BOOL)isAnimating
{
    return [super isAnimating] || (self.displayLink && !self.displayLink.isPaused);
}
//停止动画
-(void)stopAnimating
{
    //如果不是gif就返回父类方法
    if (!self.animatedImage) {
        [super stopAnimating];
        return;
    }
    self.loopCountdown = 0;
    self.displayLink.paused = YES;
}
//开始动画
-(void)startAnimating
{
    if (!self.animatedImage) {
        [super startAnimating];
        return;
    }
    if (self.isAnimating) {
        return;
    }
    self.loopCountdown = self.animatedImage.loopCount ? :NSUIntegerMax;
    self.displayLink.paused = NO;
}
//切换动画的关键方法
-(void)changeKeyframe:(CADisplayLink *)displayLink
{
    if (self.currentFrameIndex >= self.animatedImage.images.count) {
        return;
    }
    //这里就是不停的取图，不停的设置，然后不停的调用displayLayer:方法
    self.accumulator += fmin(displayLink.duration, kMaxTimeStep);
    while (self.accumulator >= self.animatedImage.frameDurations[self.currentFrameIndex]) {
        self.accumulator -= self.animatedImage.frameDurations[self.currentFrameIndex];
        if (++self.currentFrameIndex >= self.animatedImage.images.count) {
            if (--self.loopCountdown == 0) {
                [self stopAnimating];
                return;
            }
            self.currentFrameIndex = 0;
        }
        self.currentFrameIndex = MIN(self.currentFrameIndex, self.animatedImage.images.count - 1);
        self.currentFrame = [self.animatedImage getFrameWithIndex:self.currentFrameIndex];
        [self.layer setNeedsDisplay];
    }
}
//绘制图片
-(void)displayLayer:(CALayer *)layer
{
    if (!self.animatedImage || [self.animatedImage.images count] == 0) {
        return;
    }
    if(self.currentFrame && ![self.currentFrame isKindOfClass:[NSNull class]]){
        layer.contents = (__bridge id)([self.currentFrame CGImage]);
    }
}
-(void)didMoveToWindow
{
    [super didMoveToWindow];
    if (self.window) {
        [self startAnimating];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self.window) {
                [self stopAnimating];
            }
        });
    }
}
-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if (self.superview) {
        //Has a superview, make sure it has a displayLink
        [self displayLink];
    } else {
        //Doesn't have superview, let's check later if we need to remove the displayLink
        dispatch_async(dispatch_get_main_queue(), ^{
            [self displayLink];
        });
    }
}
-(void)setHighlighted:(BOOL)highlighted
{
    if (!self.animatedImage) {
        [super setHighlighted:highlighted];
    }
}
-(UIImage *)image
{
    return self.animatedImage ? : [super image];
}
-(CGSize)sizeThatFits:(CGSize)size
{
    return self.image.size;
}
@end
