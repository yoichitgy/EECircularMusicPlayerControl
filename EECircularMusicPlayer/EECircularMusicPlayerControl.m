//
//  EECircularMusicPlayerControl.m
//  EECircularMusicPlayer
//
//  Created by Yoichi Tagaya on 12/10/20.
//  Copyright (c) 2012 Yoichi Tagaya. All rights reserved.
//

#import "EECircularMusicPlayerControl.h"
#import <QuartzCore/QuartzCore.h>
#import "DACircularProgressView.h"

#pragma mark - EEPlayerButtonLayer
@interface EEPlayerButtonLayer : CALayer

@property(nonatomic, strong) UIColor *topTintColor;
@property(nonatomic, strong) UIColor *bottomTintColor;
@property(nonatomic, strong) UIColor *iconColor;
@property(nonatomic) BOOL playing;

@end

@implementation EEPlayerButtonLayer

- (void)drawInContext:(CGContextRef)context
{
    CGSize circleSize = self.bounds.size;
    CGFloat iconRatio = 0.6f;
    CGFloat iconFrameOffset = 0.5f * (1.0f - iconRatio);
    CGRect iconFrame = CGRectMake(iconFrameOffset * circleSize.width,
                                  iconFrameOffset * circleSize.height,
                                  iconRatio * circleSize.width,
                                  iconRatio * circleSize.height);

    // Fill circle area
    CGFloat radius = 0.5f * circleSize.width;
    int clockwise = 0;
    CGContextSetFillColorWithColor(context, self.topTintColor.CGColor);
    CGContextAddArc(context, radius, radius, radius, M_PI, 0.0f, clockwise);
    CGContextFillPath(context);
    CGContextSetFillColorWithColor(context, self.bottomTintColor.CGColor);
    CGContextAddArc(context, radius, radius, radius, 0.0f, M_PI, clockwise);
    CGContextFillPath(context);
   
    // Draw play/stop icon.
    CGContextSetFillColorWithColor(context, self.iconColor.CGColor);
    if (self.playing) {
        CGFloat factor = 0.8f;
        CGFloat originOffset = (1.0f - factor) / 2.0f;
        CGRect rect = CGRectMake(iconFrame.origin.x + originOffset * iconFrame.size.width,
                                 iconFrame.origin.y + originOffset * iconFrame.size.height,
                                 factor * iconFrame.size.width,
                                 factor * iconFrame.size.height);
        CGContextFillRect(context, rect);
    }
    else {
        CGRect triangleFrame = CGRectMake(iconFrame.origin.x + iconFrame.size.width / 3.0f / 4.0f,
                                          iconFrame.origin.y,
                                          iconFrame.size.width,
                                          iconFrame.size.height);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, triangleFrame.origin.x, triangleFrame.origin.y);
        CGContextAddLineToPoint(context, triangleFrame.origin.x, CGRectGetMaxY(triangleFrame));
        CGContextAddLineToPoint(context, CGRectGetMaxX(triangleFrame), triangleFrame.origin.y + triangleFrame.size.height / 2.0f);
        CGContextClosePath(context);
        CGContextFillPath(context);
    }
}

@end

#pragma mark - EECircularMusicPlayerLayer
@interface EECircularMusicPlayerLayer : CALayer

@property(nonatomic) CGFloat progressTrackRatio;
@property(nonatomic, strong) DACircularProgressLayer *progressLayer;
@property(nonatomic, strong) EEPlayerButtonLayer *buttonLayer;

@end

@implementation EECircularMusicPlayerLayer

- (id)init
{
    self = [super init];
    if (self)
    {
        // Default values
        CGFloat thicknessRatio = 0.3f;
        UIColor *trackTintColor = [UIColor colorWithRed:161.0f/255.0f green:173.0f/255.0f blue:194.0f/255.0f alpha:1.0f];
        UIColor *progressTintColor = [UIColor colorWithRed:85.0f/255.0f green:108.0f/255.0f blue:156.0f/255.0f alpha:1.0f];
        UIColor *topTintColor = [UIColor colorWithRed:50.0f/255.0f green:107.0f/255.0f blue:210.0f/255.0f alpha:1.0f];
        UIColor *bottomTintColor = [UIColor colorWithRed:30.0f/255.0f green:85.0f/255.0f blue:205.0f/255.0f alpha:1.0f];
        UIColor *iconColor = [UIColor colorWithWhite:210.0f/255.0f alpha:1.0f];
        
        // Progress layer
        self.progressLayer = [DACircularProgressLayer layer];
        self.progressLayer.thicknessRatio = thicknessRatio;
        self.progressLayer.trackTintColor = trackTintColor;
        self.progressLayer.progressTintColor = progressTintColor;
        self.progressLayer.roundedCorners = 0;
        [self addSublayer:self.progressLayer];
        
        // Button layer
        self.buttonLayer = [EEPlayerButtonLayer layer];
        self.buttonLayer.topTintColor = topTintColor;
        self.buttonLayer.bottomTintColor = bottomTintColor;
        self.buttonLayer.iconColor = iconColor;
        [self addSublayer:self.buttonLayer];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    CGFloat buttonPartRatio = 1.0f - self.progressTrackRatio;
    self.progressLayer.frame = CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height);
    self.buttonLayer.frame = CGRectMake(0.5f * self.progressTrackRatio * frame.size.width,
                                        0.5f * self.progressTrackRatio * frame.size.height,
                                        buttonPartRatio * frame.size.width,
                                        buttonPartRatio * frame.size.height);
    [self.progressLayer setNeedsDisplay];
    [self.buttonLayer setNeedsDisplay];
}

- (CGFloat)progressTrackRatio
{
    return self.progressLayer.thicknessRatio;
}

- (void)setProgressTrackRatio:(CGFloat)progressTrackRatio
{
    self.progressLayer.thicknessRatio = progressTrackRatio;
    [self setFrame:self.frame];
}

@end


#pragma mark - EECircularMusicPlayerControl
@implementation EECircularMusicPlayerControl

+ (Class)layerClass
{
    return [EECircularMusicPlayerLayer class];
}

- (EECircularMusicPlayerLayer *)circularMusicPlayerLayer
{
    return (EECircularMusicPlayerLayer *)self.layer;
}

- (id)init
{
    return [self initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;     
}

- (void)didMoveToWindow
{
    CGFloat scale = [UIScreen mainScreen].scale;
    self.circularMusicPlayerLayer.progressLayer.contentsScale = scale;
    self.circularMusicPlayerLayer.buttonLayer.contentsScale = scale;
}

#pragma mark Progress Part
- (UIColor *)trackTintColor
{
    return self.circularMusicPlayerLayer.progressLayer.trackTintColor;
}

- (void)setTrackTintColor:(UIColor *)trackTintColor
{
    self.circularMusicPlayerLayer.progressLayer.trackTintColor = trackTintColor;
    [self.circularMusicPlayerLayer.progressLayer setNeedsDisplay];
}

- (UIColor *)progressTintColor
{
    return self.circularMusicPlayerLayer.progressLayer.progressTintColor;
}

- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    self.circularMusicPlayerLayer.progressLayer.progressTintColor = progressTintColor;
    [self.circularMusicPlayerLayer.progressLayer setNeedsDisplay];
}

- (NSTimeInterval)currentTime
{
    return self.circularMusicPlayerLayer.progressLayer.progress * self.duration;
}

- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    [self setCurrentTime:currentTime animated:NO];
}

- (void)setCurrentTime:(NSTimeInterval)currentTime animated:(BOOL)animated
{
    CGFloat progress = self.duration <= 0.0 ? 0.0f : currentTime / self.duration;
    CGFloat pinnedProgress = MIN(MAX(progress, 0.0f), 1.0f);
    if (animated)
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
        animation.duration = fabsf(progress - pinnedProgress); // Same duration as UIProgressView animation
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.fromValue = [NSNumber numberWithFloat:progress];
        animation.toValue = [NSNumber numberWithFloat:pinnedProgress];
        [self.circularMusicPlayerLayer.progressLayer addAnimation:animation forKey:@"progress"];
    }
    else
    {
        [self.circularMusicPlayerLayer.progressLayer setNeedsDisplay];
    }
    self.circularMusicPlayerLayer.progressLayer.progress = pinnedProgress;
}

#pragma mark Button Part
- (UIColor *)buttonTopTintColor
{
    return  self.circularMusicPlayerLayer.buttonLayer.topTintColor;
}

- (void)setButtonTopTintColor:(UIColor *)buttonTopTintColor
{
    self.circularMusicPlayerLayer.buttonLayer.topTintColor = buttonTopTintColor;
    [self.circularMusicPlayerLayer.buttonLayer setNeedsDisplay];
}

- (UIColor *)buttonBottomTintColor
{
    return self.circularMusicPlayerLayer.buttonLayer.bottomTintColor;
}

- (void)setButtonBottomTintColor:(UIColor *)buttonBottomTintColor
{
    self.circularMusicPlayerLayer.buttonLayer.bottomTintColor = buttonBottomTintColor;
    [self.circularMusicPlayerLayer.buttonLayer setNeedsDisplay];
}

- (UIColor *)iconColor
{
    return self.circularMusicPlayerLayer.buttonLayer.iconColor;
}

- (void)setIconColor:(UIColor *)iconColor
{
    self.circularMusicPlayerLayer.buttonLayer.iconColor = iconColor;
    [self.circularMusicPlayerLayer.buttonLayer setNeedsDisplay];
}

- (BOOL)playing
{
    return self.circularMusicPlayerLayer.buttonLayer.playing;
}

- (void)setPlaying:(BOOL)playing
{
    self.circularMusicPlayerLayer.buttonLayer.playing = playing;
    [self.circularMusicPlayerLayer.buttonLayer setNeedsDisplay];
}

@end
