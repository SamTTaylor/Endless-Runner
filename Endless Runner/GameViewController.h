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

@interface GameViewController : UIViewController

@property (weak) IBOutlet UIButton *left;
@property (weak) IBOutlet UIButton *right;
@property (weak) IBOutlet UIButton *quit;
@property (weak) IBOutlet UILabel *score;

@property GameScene* gamescene;
@property GameModel* model;


@property bool tiltbool;
@property bool gamestarted;
@property bool startedbytilt;
@property double yRotation;
@property float updatespeed;

@property (strong) CMMotionManager *motionManager;

@property (copy) CMGyroHandler gyroHandler;
@property (copy) CMAccelerometerHandler accelerometerHandler;



@end
