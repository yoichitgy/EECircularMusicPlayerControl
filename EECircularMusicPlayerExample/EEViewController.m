//
//  EEViewController.m
//  EECircularMusicPlayer
//
//  Created by Yoichi Tagaya on 12/10/20.
//  Copyright (c) 2012 Yoichi Tagaya. All rights reserved.
//

#import "EEViewController.h"

@interface EEViewController ()

@property(nonatomic) NSTimeInterval time;

@end

@implementation EEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.player.delegate = self;
    self.player.duration = 60.0;
}

- (void)viewDidUnload {
    [self setPlayer:nil];
    [super viewDidUnload];
}

- (NSTimeInterval)currentTime
{
    self.time += 0.02;
    return self.time;
}

- (IBAction)didTouchUpInside:(id)sender
{
    BOOL nowPlaying = self.player.playing;
    self.player.playing = !nowPlaying;
    if (!nowPlaying) {
        self.time = 0.0;
    }
}

@end
