//
//  SettingsViewController.h
//  Endless Runner
//
//  Created by acp14stt on 02/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

//>>>>>>>>>>>>>>>>>>>>UI ELEMENTS<<<<<<<<<<<<<<<<<<<<
@property (weak) IBOutlet UISegmentedControl *tiltcontrol;
@property (weak) IBOutlet UIButton *bgLeft;
@property (weak) IBOutlet UIButton *bgRight;
@property (weak) IBOutlet UIButton *avatarLeft;
@property (weak) IBOutlet UIButton *avatarRight;
@property (weak) IBOutlet UILabel *bglocked;
@property (weak) IBOutlet UILabel *costumelocked;

@property (weak) IBOutlet UIImageView *bgimageview;
@property (weak) IBOutlet UIImageView *avatarimageview;
@property UIImage* currentbgimage;
@property UIImage* currentcostumeimage;

//>>>>>>>>>>>>>>>>>>>>SETTINGS<<<<<<<<<<<<<<<<<<<<
@property bool tiltbool;//Whether tilt should be user for movement control or not
@property NSString* bgimagestring;//What the background image should be
@property NSString* avatarimagestring;//What the avatar image should be

@property NSMutableArray* backgroundarray;
@property NSMutableArray* costumearray;

@end
