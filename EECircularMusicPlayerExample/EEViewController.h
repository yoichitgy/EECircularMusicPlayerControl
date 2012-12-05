//
//  EEViewController.h
//  EECircularMusicPlayer
//
//  Created by Yoichi Tagaya on 12/10/20.
//  Copyright (c) 2012 Yoichi Tagaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EECircularMusicPlayerControl.h"

@interface EEViewController : UIViewController <EECircularMusicPlayerControlDelegate>

@property (strong, nonatomic) IBOutlet EECircularMusicPlayerControl *player;
- (IBAction)didTouchUpInside:(id)sender;

@end
