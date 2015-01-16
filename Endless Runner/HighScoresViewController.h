//
//  HighScoresViewController.h
//  Endless Runner
//
//  Created by acp14stt on 14/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface HighScoresViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

//>>>>>>>>>>>>>>>>>>>>UI ELEMENTS<<<<<<<<<<<<<<<<<<<<
@property (weak) IBOutlet UITableView* highscoretable;
@property NSMutableArray *highscores;//Used to mirror the immutable global highscores array

@end
