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

NSTimer *updatetimer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Load new game
    [self initialiseGameScene];
    [self instantiateGyro];
    [self checkTiltBool];
    
    //Lets get going
    self.updatespeed = 1;
    [self updaterfire];
    [self addListenersToButtons];
}


- (void)initialiseGameScene{
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    // Create and configure the scene.
    self.gamescene = [GameScene unarchiveFromFile:@"GameScene"];
    self.gamescene.scaleMode = SKSceneScaleModeAspectFill;
    self.model = [[GameModel alloc] initWithPlayer];
    [self setGameBackground:self.model.backgroundtexture];
    [self setGameGround:self.model.groundtexture];
    [self placePlayer];
    // Present the scene.
    [skView presentScene:self.gamescene];
}

- (void)instantiateGyro{
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

- (void)checkTiltBool{
    if (self.tiltbool == true){
        self.left.hidden = true;
        self.right.hidden = true;
    } else {
        self.left.hidden = false;
        self.right.hidden = false;
    }
}

- (void)setGameBackground:(SKTexture*) bgImage{
    SKAction* moveBg = [SKAction moveByX:-self.model.backgroundtexture.size.width*2 y:0 duration:0.008 * self.model.backgroundtexture.size.width*2];
    SKAction* resetBg = [SKAction moveByX:self.model.backgroundtexture.size.width*2 y:0 duration:0];
    SKAction* loopBgMovement = [SKAction repeatActionForever:[SKAction sequence:@[moveBg, resetBg]]];
    
    
    for( int i = 0; i < 2 + self.gamescene.frame.size.width; ++i ) {
        SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:bgImage];
        [sprite setScale:0.5];
        sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height/2);
        [sprite runAction:loopBgMovement];
        [self.gamescene addChild:sprite];
    }
}

- (void)setGameGround:(SKTexture*) groundtexture{
    
    for( int i = 0; i < 2 + self.gamescene.frame.size.width / ( self.model.groundtexture.size.width * 2 ); ++i ) {
        // Create the sprite
        SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:self.model.groundtexture];
        sprite.yScale = 0.1;
        sprite.position = CGPointMake(i * sprite.size.width,sprite.size.height/2);
        [self.model moveNodeWithGround:sprite Repeat:true];
        [self.gamescene addChild:sprite];
    }
    
    //Adds an invisible tactile node for everything to stand on.
    self.model.groundnode = [SKNode node];
    self.model.groundnode.position = CGPointMake(0, 20);
    self.model.groundnode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.gamescene.size.width*4, 50)];
    self.model.groundnode.physicsBody.dynamic = NO;
    [self.gamescene addChild:self.model.groundnode];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {


    }
}

- (void)placePlayer{
    [self.model placePlayer];
    [self.gamescene addChild:self.model.player.node];
}


//Initialises and Fires updater timer in one go
- (void)updaterfire{
    updatetimer = [NSTimer scheduledTimerWithTimeInterval:self.updatespeed target:self selector:@selector(updaterFireMethod:) userInfo:nil repeats:YES];
    [updatetimer fire];
}

- (void)updaterFireMethod:(NSTimer *)updatetimer{
    TactileObject *Tobj = [self.model newEnvironmentObjectWithImageNamed:@"rock"];
    [Tobj.node.physicsBody setMass:500];
    [self.model placeEntWithLoc:0 Ent:Tobj];
    [Tobj.node setScale:0.4];
    [self.gamescene addChild:Tobj.node];
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


-(void)addListenersToButtons{
    [self.left addTarget:self action:@selector(holdLeft) forControlEvents:UIControlEventTouchDown];
    [self.right addTarget:self action:@selector(holdRight) forControlEvents:UIControlEventTouchDown];
    [self.jump addTarget:self action:@selector(holdJump) forControlEvents:UIControlEventTouchDown];
    [self.left addTarget:self action:@selector(releaseLeft) forControlEvents:UIControlEventTouchUpInside];
    [self.right addTarget:self action:@selector(releaseRight) forControlEvents:UIControlEventTouchUpInside];
    [self.jump addTarget:self action:@selector(releaseJump) forControlEvents:UIControlEventTouchUpInside];
}

-(void)holdLeft
{
    [self.model moveTactileObjectLeft:self.model.player];
}

-(void)holdRight
{
    [self.model moveTactileObjectRight:self.model.player];
}

-(void)holdJump
{
    [self.model jumpEntity:self.model.player];
}

-(void)releaseLeft
{
    [self.model stopTactileObjectMovement:self.model.player];
}

-(void)releaseRight
{
    [self.model stopTactileObjectMovement:self.model.player];
}

-(void)releaseJump
{
    //Could be used later for something cool
}

-(IBAction)leftPressed:(UIButton*)sender{
    
}
-(IBAction)rightPressed:(UIButton*)sender{
    
}
-(IBAction)quitPressed:(UIButton*)sender{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)jumpPressed:(UIButton*)sender{
    
}


@end
