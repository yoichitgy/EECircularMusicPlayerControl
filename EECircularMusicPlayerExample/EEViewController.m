//
//  EEViewController.m
//  EECircularMusicPlayer
//
//  Created by Yoichi Tagaya on 12/10/20.
//  Copyright (c) 2012 Yoichi Tagaya. All rights reserved.
//

#import "EEViewController.h"

@interface EEViewController ()

@property(nonatomic, strong) EECircularMusicPlayerControl *player;
@property(nonatomic) NSTimeInterval time;

@end

@implementation EEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.player = [[EECircularMusicPlayerControl alloc] initWithFrame:CGRectMake(135.0f, 90.0f, 50.0f, 50.0f)];
    self.player.delegate = self;
    self.player.duration = 60.0;
    [self.player addTarget:self action:@selector(didTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.player];
}

- (void)didTouchUpInside:(id)sender
{
    BOOL nowPlaying = self.player.playing;
    self.player.playing = !nowPlaying;
    if (!nowPlaying) {
        self.time = 0.0;
    }
}

- (NSTimeInterval)currentTime
{
    self.time += 0.02;
    return self.time;
}

@end
