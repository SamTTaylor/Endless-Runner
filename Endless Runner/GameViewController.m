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

static const int playerCategory = 0x1 << 1;
static const int enemyCategory = 0x1 << 2;
static const int bogCategory = 0x1 << 5;
static const int lethalpassableCategory = 0x1 << 6;
static const int mushroomCategory = 0x1 << 7;
static const int lethalimpassableCategory = 0x1 << 8;

NSTimer *updatetimer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Load new game
    NSLog(@"Loaded game");
    [self initialiseGameScene];
    [self.gamescene.physicsWorld setContactDelegate:self];
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
                [self movePlayerLeft];
                self.startedbytilt = true;
            }
            if (self.yRotation < -self.model.tiltsensitivity){
                [self movePlayerRight];
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
        [sprite setScale:0.55];
        sprite.position = CGPointMake(i * sprite.size.width-(5*i), sprite.size.height/2);
        [sprite runAction:loopBgMovement];
        [self.gamescene addChild:sprite];
    }
}

- (void)setGameGround:(SKTexture*) groundtexture{
    
    for( int i = 0; i < 2 + self.gamescene.frame.size.width / ( self.model.groundtexture.size.width * 2 ); ++i ) {
        // Create the sprite
        SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:self.model.groundtexture];
        sprite.yScale = 0.4;
        sprite.position = CGPointMake(i * sprite.size.width-(30*i),sprite.size.height/2);
        [self.model moveNodeWithGround:sprite Repeat:true];
        [self.gamescene addChild:sprite];
    }
    
    //Adds an invisible tactile node for everything to stand on.
    self.model.groundnode = [SKNode node];
    self.model.groundnode.position = CGPointMake(0, 20);
    self.model.groundnode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.gamescene.size.width*4, 50)];
    self.model.groundnode.physicsBody.dynamic = NO;
    self.model.groundnode.physicsBody.categoryBitMask = 0x1 << 3;
    self.model.groundnode.physicsBody.collisionBitMask = 0x1 << 2;
    self.model.groundnode.physicsBody.contactTestBitMask = 0x1 << 2;
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
    self.updatetimer = [NSTimer scheduledTimerWithTimeInterval:self.updatespeed target:self selector:@selector(updaterFireMethod:) userInfo:nil repeats:YES];
    [updatetimer fire];
}

- (void)updaterFireMethod:(NSTimer *)updatetimer{
    if (self.startedbytilt == true || self.tiltbool == false) {
        
        float i = (double)self.model.difficultyscore/(double)self.model.difficultythreshold;
        if ([self dicerollWithPercentage:(i*100+20)] == YES){
            if ([self dicerollWithPercentage:(50)]==YES){
                [self spawnRandomObstacle];
            } else {
                [self spawnRandomEnemy];
            }
        }
        
        [self incrementScores];

        
    

    }
}

- (bool) dicerollWithPercentage:(int)percentage {
    return arc4random_uniform(100) < percentage;
}

- (void) spawnRandomObstacle{
    int i = arc4random()%self.model.currentdifficulty;
    TactileObject* Tobj = [[TactileObject alloc] init];
    Tobj = self.model.obstacles[i];
    int loc;
    TactileObject* spawn = [[Tobj.class alloc] initWithNode:[SKSpriteNode spriteNodeWithTexture:Tobj.node.texture]];
        loc = 0;
    [self.model placeEntWithLoc:loc Ent:spawn];
    NSString *strClass = NSStringFromClass(spawn.class);
    if ([strClass  isEqual: @"Stump"]) {
        [spawn.node setPosition:CGPointMake(spawn.node.position.x, spawn.node.position.y+40)];
    } else if ([strClass  isEqual: @"Bog"]) {
        [spawn.node setPosition:CGPointMake(spawn.node.position.x, spawn.node.position.y)];
    } else if ([strClass  isEqual: @"Spikes"]) {
        [spawn.node setPosition:CGPointMake(spawn.node.position.x, spawn.node.position.y+40)];
    } else if ([strClass  isEqual: @"Mushroom"]) {
        [spawn.node setPosition:CGPointMake(spawn.node.position.x, spawn.node.position.y+40)];
    } else if ([strClass  isEqual: @"Bush"]) {
        [spawn.node setPosition:CGPointMake(spawn.node.position.x, spawn.node.position.y+20)];
    }
    
    [self.gamescene addChild:spawn.node];
}

- (void) spawnRandomEnemy{
    int i = arc4random()%self.model.currentdifficulty;
    Enemy* en = [[Enemy alloc] init];
    en = self.model.enemies[i];
    int loc;
    NSString *strClass = NSStringFromClass(en.class);
    Enemy* spawn = [[en.class alloc] initWithNode:[SKSpriteNode spriteNodeWithTexture:en.node.texture]];
    if([strClass  isEqual: @"Bird" ]){
        loc = 2;
    } else if([strClass  isEqual: @"Beehive" ]){
        loc = 3;
    } else {
        loc = 0;
    }
    [self.model placeEntWithLoc:loc Ent:spawn];
    [self.gamescene addChild:spawn.node];
    [spawn animateSelf];
}


- (void) incrementScores{
    [self.model incrementScore:self.model.currentdifficulty * 10];
    [self.model incrementDifficultyScore:1];
    [self.model updateDifficulty];
    self.score.text = [NSString stringWithFormat:@"%d", self.model.score];
}

- (void) quitSelf{
    self.motionManager = nil;
    self.closing = true;
    self.model = nil;
    self.gamescene = nil;
    [self.updatetimer invalidate];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void) checkLives{
    [self.model.player takeLife];
    if(self.model.player.lives<=0){
        [self quitSelf];
    };
}

- (void)movePlayerLeft{
    [self.model moveTactileObjectLeft:self.model.player speed:(int)0];
}

-(void)movePlayerRight{
    [self.model moveTactileObjectRight:self.model.player speed:(int)0];
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


//Contact handling
- (void)didBeginContact:(SKPhysicsContact *)contact {
    SKSpriteNode *firstNode, *secondNode;
    firstNode = (SKSpriteNode *)contact.bodyA.node;
    secondNode = (SKSpriteNode *) contact.bodyB.node;
    
    if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == enemyCategory){
        [self checkLives];
    }
    if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == lethalpassableCategory){
        [self checkLives];
    }
    if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == lethalimpassableCategory){
        [self checkLives];
    }
    if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == bogCategory){
        [self.model.player collidedWithBog];
    }
    if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == mushroomCategory){
        [contact.bodyB setCategoryBitMask:0x1 << 9];
        [self.model.player collidedWithMushroom];
    }
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
    [self movePlayerLeft];
}

-(void)holdRight
{
    [self startGame];
    [self movePlayerRight];
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
    [self quitSelf];
}


@end
