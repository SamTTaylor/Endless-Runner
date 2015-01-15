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

@property (weak) IBOutlet UIButton *left;
@property (weak) IBOutlet UIButton *right;
@property (weak) IBOutlet UIButton *quit;
@property (weak) IBOutlet UILabel *score;

@property (weak) GameScene* gamescene;
@property (weak) GameScene* challengescene;
@property GameModel* model;


@property bool tiltbool;
@property SKTexture* bgtexture;
@property SKTexture* groundtexture;

@property bool closing;
@property bool gamestarted;
@property bool startedbytilt;
@property double yRotation;
@property float updatespeed;
@property NSTimer* updatetimer;
@property NSMutableArray *spawnedobjects;

@property (strong) UITapGestureRecognizer *doubleTapRecognizer;
@property (strong) UISwipeGestureRecognizer *swipeRecognizer;
@property (strong) UIGestureRecognizer *buttonRecognizer;
@property (strong) CMMotionManager *motionManager;
@property (copy) CMGyroHandler gyroHandler;
@property (copy) CMAccelerometerHandler accelerometerHandler;

- (void) quitSelf;

@end
