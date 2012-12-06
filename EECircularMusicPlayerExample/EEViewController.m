//
//  EEViewController.m
//  EECircularMusicPlayer
//
//  Created by Yoichi Tagaya on 12/10/20.
//  Copyright (c) 2012 Yoichi Tagaya. All rights reserved.
//

#import "EEViewController.h"


@interface EEViewController ()

@property(nonatomic, strong) AVAudioPlayer *audioPlayer; // This is used by playerControl1.
@property (strong, nonatomic) NSTimer *timer; // This is used by playerControl2.

@end


@implementation EEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    // Example 1 (playerControl1)
    // This is an example to update the current time of the control by a delegate.
    // Also this is an example to use AVAudioPlayer to play a music with EECircularMusicPlayerControl.
    //
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Jimdubtrix_XTC-of-Gold-160" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.audioPlayer.delegate = self;
    [self.audioPlayer prepareToPlay];
    self.playerControl1.duration = self.audioPlayer.duration;
    self.playerControl1.delegate = self;
    
    //
    // Example 2 (playerControl2)
    // This is an example to update the current time of the control by yourself.
    // Also this is an example to customize the appearance of EECircularMusicPlayerControl.
    //
    self.playerControl2.duration = 30.0;
    self.playerControl2.progressTrackRatio = 0.4f;
    self.playerControl2.trackTintColor = [UIColor colorWithWhite:190.0f/255.0f alpha:1.0f];
    self.playerControl2.highlightedTrackTintColor = [UIColor colorWithWhite:160.0f/255.0f alpha:1.0f];
    self.playerControl2.progressTintColor = [UIColor colorWithRed:0.0f/255.0f green:88.0f/255.0f blue:219.0f/255.0f alpha:1.0f];
    self.playerControl2.highlightedProgressTintColor = [UIColor colorWithRed:11.0f/255.0f green:76.0f/255.0f blue:176.0f/255.0f alpha:1.0f];
    self.playerControl2.buttonTopTintColor = [UIColor colorWithWhite:240.0f/255.0f alpha:1.0f];
    self.playerControl2.highlightedButtonTopTintColor = [UIColor colorWithWhite:240.0f/255.0f alpha:1.0f];
    self.playerControl2.buttonBottomTintColor = [UIColor colorWithWhite:217.0f/255.0f alpha:1.0f];
    self.playerControl2.highlightedButtonBottomTintColor = [UIColor colorWithWhite:217.0f/255.0f alpha:1.0f];
    self.playerControl2.iconColor = [UIColor colorWithWhite:123.0f/255.0f alpha:1.0f];
    self.playerControl2.highlightedIconColor =[UIColor colorWithWhite:80.0f/255.0f alpha:1.0f];
}

- (void)viewDidUnload
{
    self.playerControl1 = nil;
    self.playerControl2 = nil;
    self.audioPlayer = nil;
    [super viewDidUnload];
}

- (void)startControl2
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(didControl2TimeChange) userInfo:nil repeats:YES];
}

- (void)stopControl2
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)didControl2TimeChange
{
    NSTimeInterval time = self.playerControl2.currentTime + 0.02;
    self.playerControl2.currentTime = time;
    
    if (self.playerControl2.currentTime >= self.playerControl2.duration && [self.timer isValid])
    {
        [self stopControl2];
        self.playerControl2.playing = NO;
        self.playerControl2.currentTime = 0.0;
    }
}

- (IBAction)didTouchUpInside:(id)sender
{
    if (sender == self.playerControl1) {
        BOOL startsPlaying = !self.audioPlayer.playing;
        self.playerControl1.playing = startsPlaying;
        if (startsPlaying) {
            [self.audioPlayer play];
        }
        else {
            [self.audioPlayer stop];
            self.audioPlayer.currentTime = 0.0;
            [self.audioPlayer prepareToPlay];
        }
    }
    else if (sender == self.playerControl2) {
        BOOL startsPlaying = !self.playerControl2.playing;
        self.playerControl2.playing = startsPlaying;
        if (startsPlaying) {
            [self startControl2];
        }
        else {
            [self stopControl2];
        }
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
    self.playerControl1.playing = NO;
    [self.audioPlayer prepareToPlay];
}

@end
