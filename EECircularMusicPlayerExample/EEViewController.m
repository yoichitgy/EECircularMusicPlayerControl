//
//  EEViewController.m
//  EECircularMusicPlayer
//
//  Created by Yoichi Tagaya on 12/10/20.
//  Copyright (c) 2012 Yoichi Tagaya. All rights reserved.
//

#import "EEViewController.h"


@interface EEViewController ()

@property(nonatomic, strong) AVAudioPlayer *audioPlayer;

@end


@implementation EEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // This is an example to use AVAudioPlayer to play a music.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Jimdubtrix_XTC-of-Gold-160" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.audioPlayer.delegate = self;
    [self.audioPlayer prepareToPlay];
    
    // Set duration
    self.player.duration = self.audioPlayer.duration;
    self.player.delegate = self;
}

- (void)viewDidUnload
{
    self.player = nil;
    self.audioPlayer = nil;
    [super viewDidUnload];
}

- (IBAction)didTouchUpInside:(id)sender
{
    BOOL startsPlaying = !self.audioPlayer.playing;
    self.player.playing = startsPlaying;
    if (startsPlaying) {
        [self.audioPlayer play];
    }
    else {
        [self.audioPlayer stop];
        self.audioPlayer.currentTime = 0.0;
        [self.audioPlayer prepareToPlay];
    }
}

#pragma mark - EECircularMusicPlayerControlDelegate
- (NSTimeInterval)currentTime
{
    return self.audioPlayer.currentTime;
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.player.playing = NO;
    [self.audioPlayer prepareToPlay];
}

@end
