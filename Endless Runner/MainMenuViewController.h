//
//  MainMenuViewController.h
//  Endless Runner
//
//  Created by acp14stt on 02/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "SettingsViewController.h"
#import "GameViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "GameScene.h"
#import "GameModel.h"
#import "AppDelegate.h"


@interface MainMenuViewController : UIViewController <CLLocationManagerDelegate>
//>>>>>>>>>>>>>>>>>>>>PROPERTIES<<<<<<<<<<<<<<<<<<<<


//>>>>>>>>>>>>>>>>>>>>UI ELEMENTS<<<<<<<<<<<<<<<<<<<<
@property (weak) IBOutlet UIButton *play;
@property (weak) IBOutlet UIButton *settings;
@property (weak) IBOutlet UIButton *highscores;
@property (weak) IBOutlet UIButton *instructions;

//>>>>>>>>>>>>>>>>>>>>SETTINGS<<<<<<<<<<<<<<<<<<<<
//All passed to the GameView to be reflected in game
@property bool tiltbool;//Tilt or buttons
@property SKTexture* bgtexture;//What does the background look like
@property SKTexture* groundtexture;//What does the ground look like
@property UIImage* bgimage;
@property UIImage* costumeimage;
@property NSMutableArray* costumearray;
@property NSMutableArray* backgroundarray;


//User defaults
@property NSUserDefaults* defaults;
@property (assign) bool england;
@property (assign) bool austria;
@property (assign) bool pit;
@property (assign) bool superlenny;
@property (assign) bool christmas;
@property (assign) bool halloween;
@property (assign) int bgimageindex;
@property (assign) int costumeimageindex;

//>>>>>>>>>>>>>>>>>>>>SEGUE STUFF<<<<<<<<<<<<<<<<<<<<
@property (strong) GameScene* menuscene; //Used to create the nice scrolling background on the main menu
@property (strong) SettingsViewController *svc;
@property (strong) GameViewController *gvc;

//>>>>>>>>>>>>>>>>>>>>LOCATION MANAGER<<<<<<<<<<<<<<<<<<<<
@property (strong) CLLocationManager *locationManager;
@property CLLocation *location;
@property NSString *Country;

-(void)loadDefaults;
-(void)saveDefaults;
-(void)fillcostumearray;
-(void)fillBackgroundArray;

@end
