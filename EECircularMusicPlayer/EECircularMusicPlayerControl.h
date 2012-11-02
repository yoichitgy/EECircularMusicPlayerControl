//
//  EECircularMusicPlayerControl.h
//  EECircularMusicPlayer
//
//  Created by Yoichi Tagaya on 12/10/20.
//  Copyright (c) 2012 Yoichi Tagaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DACircularProgressView.h"

@protocol EECircularMusicPlayerControlDelegate <NSObject>

@optional
- (NSTimeInterval)currentTime;

@end


@interface EECircularMusicPlayerControl : UIControl

@property(nonatomic, unsafe_unretained) id<EECircularMusicPlayerControlDelegate> delegate;
@property(nonatomic) CGFloat progressTrackRatio;

// Progress part
@property(nonatomic, strong) UIColor *trackTintColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *progressTintColor UI_APPEARANCE_SELECTOR;
@property(nonatomic) NSTimeInterval duration;
@property(nonatomic) NSTimeInterval currentTime;
- (void)setCurrentTime:(NSTimeInterval)currentTime animated:(BOOL)animated;

// Button part
@property(nonatomic, strong) UIColor *buttonTopTintColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *buttonBottomTintColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *iconColor UI_APPEARANCE_SELECTOR;
@property(nonatomic) BOOL playing;

@end
