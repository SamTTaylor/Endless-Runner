//
//  GameViewController.h
//  Endless Runner
//

//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>
#import "GameScene.h"
#import "GameModel.h"
#import "AppDelegate.h"

@interface GameViewController : UIViewController <SKPhysicsContactDelegate, UIGestureRecognizerDelegate>
//>>>>>>>>>>>>>>>>>>>>UI ELEMENTS<<<<<<<<<<<<<<<<<<<<
@property (weak) IBOutlet UIButton *left;
@property (weak) IBOutlet UIButton *right;
@property (weak) IBOutlet UIButton *quit;
@property (weak) IBOutlet UILabel *score;


//>>>>>>>>>>>>>>>>>>>>SCENES<<<<<<<<<<<<<<<<<<<<
@property (weak) GameScene* gamescene;
@property (weak) GameScene* challengescene;
//(Model)
@property GameModel* model;

//>>>>>>>>>>>>>>>>>>>>SETTINGS<<<<<<<<<<<<<<<<<<<<
@property bool tiltbool;
@property SKTexture* bgtexture;
@property SKTexture* groundtexture;


@property UIImage* screenshot;//Used to store the Facebook "Highscore" screen shot between methods


@property bool closing;//Used to stop actions from completing while the view is closing
@property bool gamestarted;//Used to stop actions from completing before the game has started
@property bool startedbytilt;//Used to stop the motionmanager from sending too many commands once the game has started, by letting the update timer read this value instead and start the game
@property double yRotation;//Used to monitor the tilt of the device
@property float updatespeed;//How fast updater timer ticks
@property NSTimer* updatetimer;//Performs spawn actions and score updates (primarily)
@property NSMutableArray *spawnedobjects;//Used to check what types of mob have been spawned


//>>>>>>>>>>>>>>>>>>>>GESTURE RECOGNIZERS<<<<<<<<<<<<<<<<<<<<
@property (strong) UITapGestureRecognizer *doubleTapRecognizer;
@property (strong) UISwipeGestureRecognizer *swipeRecognizer;
@property (strong) UIGestureRecognizer *buttonRecognizer;

//>>>>>>>>>>>>>>>>>>>>TILT SENSOR<<<<<<<<<<<<<<<<<<<<
@property (strong) CMMotionManager *motionManager;
@property (copy) CMAccelerometerHandler accelerometerHandler;

- (void) quitSelf;

@end
