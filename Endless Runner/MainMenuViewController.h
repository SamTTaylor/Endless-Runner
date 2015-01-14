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

@interface MainMenuViewController : UIViewController

@property (weak) IBOutlet UIButton *play;
@property (weak) IBOutlet UIButton *settings;

@property bool tiltbool;
@property SKTexture* bgtexture;
@property SKTexture* groundtexture;


@property GameScene* menuscene;
@property (weak) SettingsViewController *svc;
@property (weak) GameViewController *gvc;

@end
