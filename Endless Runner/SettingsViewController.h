//
//  SettingsViewController.h
//  Endless Runner
//
//  Created by acp14stt on 02/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UIImagePickerControllerDelegate>

@property (weak) IBOutlet UISegmentedControl *tiltcontrol;
@property (weak) IBOutlet UIButton *bgLeft;
@property (weak) IBOutlet UIButton *bgRight;
@property (weak) IBOutlet UIButton *avatarLeft;
@property (weak) IBOutlet UIButton *avatarRight;

@property (weak) IBOutlet UIImageView *bgimageview;
@property (weak) IBOutlet UIImageView *avatarimageview;

@property bool tiltbool;
@property NSString* bgimagestring;
@property NSString* avatarimagestring;

@end
