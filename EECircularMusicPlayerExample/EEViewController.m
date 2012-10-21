//
//  EEViewController.m
//  EECircularMusicPlayer
//
//  Created by Yoichi Tagaya on 12/10/20.
//  Copyright (c) 2012 Yoichi Tagaya. All rights reserved.
//

#import "EEViewController.h"
#import "EECircularMusicPlayerControl.h"

@interface EEViewController ()

@property(nonatomic, strong) EECircularMusicPlayerControl *player;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation EEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.player = [[EECircularMusicPlayerControl alloc] initWithFrame:CGRectMake(135.0f, 90.0f, 50.0f, 50.0f)];
    [self.player addTarget:self action:@selector(didTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.player];
}

- (void)progressChange
{
    CGFloat progress = self.player.progress + 0.001f;
    [self.player setProgress:progress animated:YES];
    
    if (self.player.progress >= 1.0f && [self.timer isValid])
    {
        [self stopAnimation];
        self.player.playing = false;
        self.player.progress = 0.0f;
    }
}

- (void)startAnimation
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(progressChange) userInfo:nil repeats:YES];
}

- (void)stopAnimation
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)didTouchUpInside:(id)sender
{
    BOOL nowPlaying = self.player.playing;
    if (nowPlaying) {
        [self stopAnimation];
    }
    else {
        [self startAnimation];
    }
    self.player.playing = !nowPlaying;
}

@end
