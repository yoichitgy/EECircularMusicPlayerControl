//
//  EECircularMusicPlayerControl.h
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

#import <UIKit/UIKit.h>

@protocol EECircularMusicPlayerControlDelegate <NSObject>

@optional
- (NSTimeInterval)currentTime;

@end


@interface EECircularMusicPlayerControl : UIControl

@property(nonatomic, weak) id<EECircularMusicPlayerControlDelegate> delegate;
@property(nonatomic) CGFloat progressTrackRatio;

// Progress part
@property(nonatomic, strong) UIColor *trackTintColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *progressTintColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *highlightedTrackTintColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *highlightedProgressTintColor UI_APPEARANCE_SELECTOR;
@property(nonatomic) NSTimeInterval duration;
@property(nonatomic) NSTimeInterval currentTime;
- (void)setCurrentTime:(NSTimeInterval)currentTime animated:(BOOL)animated;

// Button part
@property(nonatomic, strong) UIColor *buttonTopTintColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *buttonBottomTintColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *iconColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *highlightedButtonTopTintColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *highlightedButtonBottomTintColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *highlightedIconColor UI_APPEARANCE_SELECTOR;
@property(nonatomic) BOOL playing;

@end
