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

@property GameScene* gamescene;
@property GameModel* model;

@property (strong) CMMotionManager *motionManager;

@property (copy) CMGyroHandler gyroHandler;

@end
