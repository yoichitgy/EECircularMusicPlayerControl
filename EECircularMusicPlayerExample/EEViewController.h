//
//  EEViewController.h
//  EECircularMusicPlayer
//
//  Created by Yoichi Tagaya on 12/10/20.
//  Copyright (c) 2012 Yoichi Tagaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "EECircularMusicPlayerControl.h"

@interface EEViewController : UIViewController <EECircularMusicPlayerControlDelegate, AVAudioPlayerDelegate>

@property (strong, nonatomic) IBOutlet EECircularMusicPlayerControl *playerControl1;
@property (strong, nonatomic) IBOutlet EECircularMusicPlayerControl *playerControl2;
- (IBAction)didTouchUpInside:(id)sender;

@end
