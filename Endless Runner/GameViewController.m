//
//  GameViewController.m
//  Endless Runner
//
//  Created by acp14stt on 25/11/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "ToastView.h"

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
    [self.gamescene.physicsWorld setContactDelegate:self.model];
    [self checkTiltBool];
    self.gamestarted = false;
    self.startedbytilt = false;
    [self addListenersToButtons];
    if (self.tiltbool == true){
        [self startGame];
    }
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

- (void)startGame{
    //Lets get going
    if (self.gamestarted == false) {
        self.gamestarted = true;
        self.updatespeed = 1;
        [self updaterfire];
    }
}

- (void)instantiateAccelerometer{
    //Prepare the Accelerometer
    self.motionManager = [[CMMotionManager alloc]init];
    if (self.motionManager.accelerometerAvailable) {
        self.motionManager.accelerometerUpdateInterval = 0.01; // 100 Hz
        [self.motionManager startAccelerometerUpdates];
        
        self.accelerometerHandler = ^(CMAccelerometerData *accData, NSError *error) {
           
            self.yRotation = accData.acceleration.y;
            if (self.yRotation > self.model.tiltsensitivity){
                [self.model moveTactileObjectLeft:self.model.player speed:0];
                self.startedbytilt = true;
            }
            if (self.yRotation < -self.model.tiltsensitivity){
                [self.model moveTactileObjectRight:self.model.player speed:0];
                self.startedbytilt = true;
            }
            if (self.yRotation < self.model.tiltsensitivity && self.yRotation > -self.model.tiltsensitivity){
                [self.model stopTactileObjectMovement:self.model.player Direction:0];
                [self.model stopTactileObjectMovement:self.model.player Direction:1];
            }
        };
        // fire off regular animation updates via a timer
        [self.motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc]init] withHandler:self.accelerometerHandler];
    }
    else {
        NSLog(@"No accelerometer on the device");
        self.motionManager = nil;
    }
}

- (void)checkTiltBool{
    if (self.tiltbool == true){
        self.left.hidden = true;
        self.right.hidden = true;
        [self instantiateAccelerometer];
        [ToastView showToastInParentView:self.view withText:@"Tilt to begin, tap to jump!" withDuaration:5.0];
    } else {
        [ToastView showToastInParentView:self.view withText:@"Press movement buttons to begin, tap to jump!" withDuaration:5.0];
        self.left.hidden = false;
        self.right.hidden = false;
    }
}

- (void)setGameBackground:(SKTexture*) bgImage{
    SKAction* moveBg = [SKAction moveByX:-self.model.backgroundtexture.size.width*2 y:0 duration:0.015 * self.model.backgroundtexture.size.width*2];
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
        sprite.yScale = 0.4;
        sprite.position = CGPointMake(i * sprite.size.width,sprite.size.height/2);
        [self.model moveNodeWithGround:sprite Repeat:true];
        [self.gamescene addChild:sprite];
    }
    
    //Adds an invisible tactile node for everything to stand on.
    self.model.groundnode = [SKNode node];
    self.model.groundnode.position = CGPointMake(0, 20);
    self.model.groundnode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.gamescene.size.width*4, 50)];
    self.model.groundnode.physicsBody.dynamic = NO;
    self.model.groundnode.physicsBody.categoryBitMask = 3;
    self.model.groundnode.physicsBody.collisionBitMask = 2;
    self.model.groundnode.physicsBody.contactTestBitMask = 2;
    [self.gamescene addChild:self.model.groundnode];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    [self.model jumpEntity:self.model.player];
    for (UITouch *touch in touches) {
        

    }
}

- (void)placePlayer{
    [self.model placePlayer];
    [self.gamescene addChild:self.model.player.node];
}










//TIMERS
- (void)updaterfire{
    updatetimer = [NSTimer scheduledTimerWithTimeInterval:self.updatespeed target:self selector:@selector(updaterFireMethod:) userInfo:nil repeats:YES];
    [updatetimer fire];
}

- (void)updaterFireMethod:(NSTimer *)updatetimer{
    if (self.startedbytilt == true || self.tiltbool == false) {
        
        Enemy* beehive = [[Beehive alloc] initWithNode:[SKSpriteNode spriteNodeWithImageNamed:@"BeehiveSam"]];
        [self.model placeEntWithLoc:2 Ent:beehive];
        [self.gamescene addChild:beehive.node];
        
        Enemy* bird = [[Bird alloc] initWithNode:[SKSpriteNode spriteNodeWithImageNamed:@"Bird"]];
        [self.model placeEntWithLoc:2 Ent:bird];
        [self.gamescene addChild:bird.node];

        
        Enemy* fox = [[Wolf alloc] initWithNode:[SKSpriteNode spriteNodeWithImageNamed:@"Wolf"]];
        [self.model placeEntWithLoc:0 Ent:fox];
        [self.gamescene addChild:fox.node];
        [fox animateSelf];
        
        /*TactileObject *Tobj = [self.model newEnvironmentObjectWithImageNamed:@"Stump" scale:0.2];
        [self.model placeEntWithLoc:0 Ent:Tobj];
        [self.gamescene addChild:Tobj.node];*/
    
    }
}





//STUFF
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


















//UI ELEMENTS
-(void)addListenersToButtons{
    [self.left addTarget:self action:@selector(holdLeft) forControlEvents:UIControlEventTouchDown];
    [self.right addTarget:self action:@selector(holdRight) forControlEvents:UIControlEventTouchDown];
    [self.left addTarget:self action:@selector(releaseLeft) forControlEvents:UIControlEventTouchUpInside];
    [self.right addTarget:self action:@selector(releaseRight) forControlEvents:UIControlEventTouchUpInside];
}

-(void)holdLeft
{
    [self startGame];
    [self.model moveTactileObjectLeft:self.model.player speed:(int)0];
}

-(void)holdRight
{
    [self startGame];
    [self.model moveTactileObjectRight:self.model.player speed:(int)0];
}

-(void)releaseLeft
{
    [self.model stopTactileObjectMovement:self.model.player Direction:0];
}

-(void)releaseRight
{
    [self.model stopTactileObjectMovement:self.model.player Direction:1];
}

-(IBAction)leftPressed:(UIButton*)sender{
    
}
-(IBAction)rightPressed:(UIButton*)sender{
    
}
-(IBAction)quitPressed:(UIButton*)sender{
    self.motionManager = nil;
    self.model = nil;
    self.gamescene = nil;
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}


@end
