//
//  MainMenuViewController.h
//  Endless Runner
//
//  Created by acp14stt on 02/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"
#import "GameViewController.h"

@interface MainMenuViewController : UIViewController

@property bool tiltbool;

@property (weak) SettingsViewController *svc;
@property (weak) GameViewController *gvc;

@end
