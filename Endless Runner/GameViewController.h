//
//  GameViewController.h
//  Endless Runner
//

//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"

@interface GameViewController : UIViewController

@property GameScene* gamescene;

@property SKSpriteNode* playercharacter;

@end
