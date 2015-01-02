//
//  GameViewController.m
//  Endless Runner
//
//  Created by acp14stt on 25/11/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    self.gamescene = [GameScene unarchiveFromFile:@"GameScene"];
    self.gamescene.scaleMode = SKSceneScaleModeAspectFill;
    self.model = [[GameModel alloc] initWithPlayer];
    [self setGameBackground:self.model.backgroundnode];
    [self placePlayer];
    // Present the scene.
    [skView presentScene:self.gamescene];
    if (self.motionManager.gyroAvailable) {
        self.motionManager.gyroUpdateInterval = 0.01; // 100 Hz
        self.gyroHandler = ^(CMGyroData *gyroData, NSError *error) {
            CMRotationRate rotate = gyroData.rotationRate;
            // need to update the user interface on the main thread
            dispatch_async(dispatch_get_main_queue(),^{
                NSLog(@"%f", rotate.x);
            });
        };
        [self.motionManager startGyroUpdatesToQueue:[[NSOperationQueue alloc]init] withHandler:self.gyroHandler];
    }
    else {
        NSLog(@"No gyroscope on the device");
        self.motionManager = nil;
    }

    //Prepare the Gyro
    self.motionManager = [[CMMotionManager alloc]init];
}


-(void)setGameBackground:(SKSpriteNode*) bgImage{
    self.gamescene.currentBackgroundImage = bgImage;
    bgImage.position = CGPointMake(CGRectGetMidX(self.gamescene.frame), CGRectGetMidY(self.gamescene.frame));
    bgImage.name = @"BACKGROUND";
    bgImage.xScale = 0.5;
    bgImage.yScale = 0.5;
    [self.gamescene addChild:bgImage];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        //CGPoint location = [touch locationInNode:self.gamescene];
        //[self.model rotatePlayer];
        [self.model movePlayer];

    }
}

-(void)placePlayer{
    self.model.player.node.yScale = 0.5;
    self.model.player.node.xScale = -0.5;
    [self.model.player.node setPosition:CGPointMake(self.model.player.node.frame.size.width/2, self.model.player.node.frame.size.height)];
    [self.gamescene addChild:self.model.player.node];

}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
