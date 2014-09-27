//
//  EECircularMusicPlayerControl.m
//  EECircularMusicPlayer
//
//  Created by Yoichi Tagaya on 12/10/20.
//  Copyright (c) 2012 Yoichi Tagaya. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EECircularMusicPlayerControl.h"
#import <QuartzCore/QuartzCore.h>
#import "EECircularMusicPlayerDACircularProgressView.h"

#pragma mark - EEPlayerButtonLayer
@interface EEPlayerButtonLayer : CALayer

@property(nonatomic, strong) UIColor *topTintColor;
@property(nonatomic, strong) UIColor *bottomTintColor;
@property(nonatomic, strong) UIColor *iconColor;
@property(nonatomic, strong) UIColor *highlightedTopTintColor;
@property(nonatomic, strong) UIColor *highlightedBottomTintColor;
@property(nonatomic, strong) UIColor *highlightedIconColor;
@property(nonatomic, strong) UIColor *disabledTopTintColor;
@property(nonatomic, strong) UIColor *disabledBottomTintColor;
@property(nonatomic, strong) UIColor *disabledIconColor;
@property(nonatomic) BOOL enabled;
@property(nonatomic) BOOL highlighted;
@property(nonatomic) BOOL playing;

@end

@implementation EEPlayerButtonLayer

- (id)init
{
    self = [super init];
    if (self) {
        self.enabled = YES;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)context
{
    CGSize circleSize = self.bounds.size;
    CGFloat iconRatio = 0.6f;
    CGFloat iconFrameOffset = 0.5f * (1.0f - iconRatio);
    CGRect iconFrame = CGRectMake(iconFrameOffset * circleSize.width,
                                  iconFrameOffset * circleSize.height,
                                  iconRatio * circleSize.width,
                                  iconRatio * circleSize.height);
    
    UIColor *topTintColor, *bottomTintColor, *iconColor;
    if (self.enabled) {
        topTintColor = self.highlighted ? self.highlightedTopTintColor : self.topTintColor;
        bottomTintColor = self.highlighted ? self.highlightedBottomTintColor : self.bottomTintColor;
        iconColor = self.highlighted ? self.highlightedIconColor : self.iconColor;
    }
    else {
        topTintColor = self.disabledTopTintColor;
        bottomTintColor = self.disabledBottomTintColor;
        iconColor = self.disabledIconColor;
        CGFloat factor = 0.75f;
        UIColor *clearColor = [UIColor clearColor];
        if (!topTintColor) {
            topTintColor = [self.topTintColor isEqual:clearColor] ? clearColor : [self.topTintColor colorWithAlphaComponent:factor];
        }
        if (!bottomTintColor) {
            bottomTintColor = [self.bottomTintColor isEqual:clearColor] ? clearColor : [self.bottomTintColor colorWithAlphaComponent:factor];
        }
        if (!iconColor) {
            iconColor = [self.iconColor isEqual:clearColor] ? clearColor : [self.iconColor colorWithAlphaComponent:factor];
        }
    }

    // Fill circle area
    CGFloat radius = 0.5f * circleSize.width;
    int clockwise = 0;
    CGContextSetFillColorWithColor(context, topTintColor.CGColor);
    CGContextAddArc(context, radius, radius, radius, M_PI, 0.0f, clockwise);
    CGContextFillPath(context);
    CGContextSetFillColorWithColor(context, bottomTintColor.CGColor);
    CGContextAddArc(context, radius, radius, radius, 0.0f, M_PI, clockwise);
    CGContextFillPath(context);
   
    // Draw play/stop icon.
    CGContextSetFillColorWithColor(context, iconColor.CGColor);
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


#pragma mark - EEPlayerBorderLayer
@interface EEPlayerBorderLayer : CALayer

@property(nonatomic, strong) UIColor *color;
@property(nonatomic, strong) UIColor *highlightedColor;
@property(nonatomic, strong) UIColor *disabledColor;
@property(nonatomic) CGFloat width;
@property(nonatomic) BOOL highlighted;
@property(nonatomic) BOOL enabled;

@end

@implementation EEPlayerBorderLayer

- (id)init
{
    self = [super init];
    if (self) {
        self.enabled = YES;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)context
{
    UIColor *color;
    if (self.enabled) {
        color = self.highlighted ? self.highlightedColor : self.color;
    }
    else {
        color = self.disabledColor;
        if (!color) {
            CGFloat factor = 0.75f;
            UIColor *clearColor = [UIColor clearColor];
            color = [self.color isEqual:clearColor] ? clearColor : [self.color colorWithAlphaComponent:factor];
        }
    }
    
    CGFloat inset = self.width / 2.0f;
    CGRect insetFrame = CGRectInset(self.bounds, inset, inset); // To draw inside the frame.
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, self.width);
    CGContextStrokeEllipseInRect(context, insetFrame);
}

@end


#pragma mark - EECircularMusicPlayerLayer
@interface EECircularMusicPlayerLayer : CALayer

@property(nonatomic) CGFloat progressTrackRatio;
@property(nonatomic, strong) EECircularMusicPlayerDACircularProgressLayer *progressLayer;
@property(nonatomic, strong) EEPlayerButtonLayer *buttonLayer;
@property(nonatomic, strong) EEPlayerBorderLayer *borderLayer;

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
        UIColor *borderColor = [UIColor clearColor];
        UIColor *highlightedTrackTintColor = [UIColor colorWithRed:118.0f/255.0f green:131.0f/255.0f blue:151.0f/255.0f alpha:1.0f];
        UIColor *highlightedProgressTintColor = [UIColor colorWithRed:42.0f/255.0f green:59.0f/255.0f blue:92.0f/255.0f alpha:1.0f];
        UIColor *highlightedTopTintColor = [UIColor colorWithRed:11.0f/255.0f green:76.0f/255.0f blue:176.0f/255.0f alpha:1.0f];
        UIColor *highlightedBottomTintColor = [UIColor colorWithRed:0.0f/255.0f green:44.0f/255.0f blue:126.0f/255.0f alpha:1.0f];
        UIColor *highlightedIconColor = [UIColor colorWithWhite:174.0f/255.0f alpha:1.0f];
        UIColor *highlightedBorderColor = [UIColor clearColor];
        CGFloat borderWidth = 1.0f;

        // Progress layer
        self.progressLayer = [EECircularMusicPlayerDACircularProgressLayer layer];
        self.progressLayer.thicknessRatio = thicknessRatio;
        self.progressLayer.trackTintColor = trackTintColor;
        self.progressLayer.progressTintColor = progressTintColor;
        self.progressLayer.highlightedTrackTintColor = highlightedTrackTintColor;
        self.progressLayer.highlightedProgressTintColor = highlightedProgressTintColor;
        self.progressLayer.disabledTrackTintColor = nil;
        self.progressLayer.disabledProgressTintColor = nil;
        self.progressLayer.roundedCorners = 0;
        [self addSublayer:self.progressLayer];
        
        // Button layer
        self.buttonLayer = [EEPlayerButtonLayer layer];
        self.buttonLayer.topTintColor = topTintColor;
        self.buttonLayer.bottomTintColor = bottomTintColor;
        self.buttonLayer.iconColor = iconColor;
        self.buttonLayer.highlightedTopTintColor = highlightedTopTintColor;
        self.buttonLayer.highlightedBottomTintColor = highlightedBottomTintColor;
        self.buttonLayer.highlightedIconColor = highlightedIconColor;
        self.buttonLayer.disabledTopTintColor = nil;
        self.buttonLayer.disabledBottomTintColor = nil;
        self.buttonLayer.disabledIconColor = nil;
        [self addSublayer:self.buttonLayer];
        
        // Border layer
        self.borderLayer = [EEPlayerBorderLayer layer];
        self.borderLayer.color = borderColor;
        self.borderLayer.highlightedColor = highlightedBorderColor;
        self.borderLayer.disabledColor = nil;
        self.borderLayer.width = borderWidth;
        [self addSublayer:self.borderLayer];
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
    self.borderLayer.frame = CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height);
    [self.progressLayer setNeedsDisplay];
    [self.buttonLayer setNeedsDisplay];
    [self.borderLayer setNeedsDisplay];
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
@interface EECircularMusicPlayerControl ()

@property (strong, nonatomic) NSTimer *timer;

@end


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

- (void)dealloc
{
    [self.timer invalidate];
}

- (void)didMoveToWindow
{
    CGFloat scale = [UIScreen mainScreen].scale;
    self.circularMusicPlayerLayer.progressLayer.contentsScale = scale;
    self.circularMusicPlayerLayer.buttonLayer.contentsScale = scale;
    self.circularMusicPlayerLayer.borderLayer.contentsScale = scale;
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    self.circularMusicPlayerLayer.progressLayer.enabled = enabled;
    self.circularMusicPlayerLayer.buttonLayer.enabled = enabled;
    self.circularMusicPlayerLayer.borderLayer.enabled = enabled;
    [self.circularMusicPlayerLayer.progressLayer setNeedsDisplay];
    [self.circularMusicPlayerLayer.buttonLayer setNeedsDisplay];
    [self.circularMusicPlayerLayer.borderLayer setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    self.circularMusicPlayerLayer.progressLayer.highlighted = highlighted;
    self.circularMusicPlayerLayer.buttonLayer.highlighted = highlighted;
    self.circularMusicPlayerLayer.borderLayer.highlighted = highlighted;
    [self.circularMusicPlayerLayer.progressLayer setNeedsDisplay];
    [self.circularMusicPlayerLayer.buttonLayer setNeedsDisplay];
    [self.circularMusicPlayerLayer.borderLayer setNeedsDisplay];
}

- (CGFloat)progressTrackRatio
{
    return self.circularMusicPlayerLayer.progressTrackRatio;
}

- (void)setProgressTrackRatio:(CGFloat)progressTrackRatio
{
    self.circularMusicPlayerLayer.progressTrackRatio = progressTrackRatio;
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

- (UIColor *)highlightedTrackTintColor
{
    return self.circularMusicPlayerLayer.progressLayer.highlightedTrackTintColor;
}

- (void)setHighlightedTrackTintColor:(UIColor *)highlightedTrackTintColor
{
    self.circularMusicPlayerLayer.progressLayer.highlightedTrackTintColor = highlightedTrackTintColor;
    [self.circularMusicPlayerLayer.progressLayer setNeedsDisplay];
}

- (UIColor *)highlightedProgressTintColor
{
    return self.circularMusicPlayerLayer.progressLayer.highlightedProgressTintColor;
}

- (void)setHighlightedProgressTintColor:(UIColor *)highlightedProgressTintColor
{
    self.circularMusicPlayerLayer.progressLayer.highlightedProgressTintColor = highlightedProgressTintColor;
    [self.circularMusicPlayerLayer.progressLayer setNeedsDisplay];
}

- (UIColor *)disabledTrackTintColor
{
    return self.circularMusicPlayerLayer.progressLayer.disabledTrackTintColor;
}

- (void)setDisabledTrackTintColor:(UIColor *)disabledTrackTintColor
{
    self.circularMusicPlayerLayer.progressLayer.disabledTrackTintColor = disabledTrackTintColor;
    [self.circularMusicPlayerLayer.progressLayer setNeedsDisplay];
}

- (UIColor *)disabledProgressTintColor
{
    return self.circularMusicPlayerLayer.progressLayer.disabledProgressTintColor;
}

- (void)setDisabledProgressTintColor:(UIColor *)disabledProgressTintColor
{
    self.circularMusicPlayerLayer.progressLayer.disabledProgressTintColor = disabledProgressTintColor;
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

- (UIColor *)highlightedButtonTopTintColor
{
    return self.circularMusicPlayerLayer.buttonLayer.highlightedTopTintColor;
}

- (void)setHighlightedButtonTopTintColor:(UIColor *)highlightedButtonTopTintColor
{
    self.circularMusicPlayerLayer.buttonLayer.highlightedTopTintColor = highlightedButtonTopTintColor;
    [self.circularMusicPlayerLayer.buttonLayer setNeedsDisplay];
}

- (UIColor *)highlightedButtonBottomTintColor
{
    return self.circularMusicPlayerLayer.buttonLayer.highlightedBottomTintColor;
}

- (void)setHighlightedButtonBottomTintColor:(UIColor *)highlightedButtonBottomTintColor
{
    self.circularMusicPlayerLayer.buttonLayer.highlightedBottomTintColor = highlightedButtonBottomTintColor;
    [self.circularMusicPlayerLayer.buttonLayer setNeedsDisplay];
}

- (UIColor *)highlightedIconColor
{
    return self.circularMusicPlayerLayer.buttonLayer.highlightedIconColor;
}

- (void)setHighlightedIconColor:(UIColor *)highlightedIconColor
{
    self.circularMusicPlayerLayer.buttonLayer.highlightedIconColor = highlightedIconColor;
    [self.circularMusicPlayerLayer.buttonLayer setNeedsDisplay];
}

- (UIColor *)disabledButtonTopTintColor
{
    return self.circularMusicPlayerLayer.buttonLayer.disabledTopTintColor;
}

- (void)setDisabledButtonTopTintColor:(UIColor *)disabledButtonTopTintColor
{
    self.circularMusicPlayerLayer.buttonLayer.disabledTopTintColor = disabledButtonTopTintColor;
    [self.circularMusicPlayerLayer.buttonLayer setNeedsDisplay];
}

- (UIColor *)disabledButtonBottomTintColor
{
    return self.circularMusicPlayerLayer.buttonLayer.disabledBottomTintColor;
}

- (void)setDisabledButtonBottomTintColor:(UIColor *)disabledButtonBottomTintColor
{
    self.circularMusicPlayerLayer.buttonLayer.disabledBottomTintColor = disabledButtonBottomTintColor;
    [self.circularMusicPlayerLayer.buttonLayer setNeedsDisplay];
}

- (UIColor *)disabledIconColor
{
    return self.circularMusicPlayerLayer.buttonLayer.disabledIconColor;
}

- (void)setDisabledIconColor:(UIColor *)disabledIconColor
{
    self.circularMusicPlayerLayer.buttonLayer.disabledIconColor = disabledIconColor;
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
    
    [self.timer invalidate];
    if (playing) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(didTimeChange) userInfo:nil repeats:YES];
    }
    else {
        self.timer = nil;
        self.currentTime = 0.0;
    }
}

#pragma mark Border Part
- (UIColor *)borderColor
{
    return self.circularMusicPlayerLayer.borderLayer.color;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.circularMusicPlayerLayer.borderLayer.color = borderColor;
    [self.circularMusicPlayerLayer.borderLayer setNeedsDisplay];
}

- (UIColor *)highlightedBorderColor
{
    return self.circularMusicPlayerLayer.borderLayer.highlightedColor;
}

- (void)setHighlightedBorderColor:(UIColor *)highlightedBorderColor
{
    self.circularMusicPlayerLayer.borderLayer.highlightedColor = highlightedBorderColor;
    [self.circularMusicPlayerLayer.borderLayer setNeedsDisplay];
}

- (UIColor *)disabledBorderColor
{
    return self.circularMusicPlayerLayer.borderLayer.disabledColor;
}

- (void)setDisabledBorderColor:(UIColor *)disabledBorderColor
{
    self.circularMusicPlayerLayer.borderLayer.disabledColor = disabledBorderColor;
    [self.circularMusicPlayerLayer.borderLayer setNeedsDisplay];
}

- (CGFloat)borderWidth
{
    return self.circularMusicPlayerLayer.borderLayer.width;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.circularMusicPlayerLayer.borderLayer.width = borderWidth;
    [self.circularMusicPlayerLayer.borderLayer setNeedsDisplay];
}

#pragma mark Event Handler
- (void)didTimeChange
{
    if ([self.delegate respondsToSelector:@selector(currentTime)]) {
        self.currentTime = self.delegate.currentTime;
    }
}

@end
