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
#import <Social/Social.h>

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

static const int playerCategory = 0x1 << 1, enemyCategory = 0x1 << 2, bogCategory = 0x1 << 5, lethalpassableCategory = 0x1 << 6, mushroomCategory = 0x1 << 7, lethalimpassableCategory = 0x1 << 8, pitCategory = 0x1 << 10, berryCategory = 0x1 << 11, butterflyCategory = 0x1 << 12, havenCategory = 0x1 << 13;


NSTimer *updatetimer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Load new game
    [self initialiseGameScene];
    [self initialiseModel];
    [self GameStart];
    [self.gamescene.physicsWorld setContactDelegate:self];
    [self checkTiltBool];
    self.gamestarted = false;
    self.startedbytilt = false;
    [self addListenersToButtons];
    [self instantiateGestureRecognizers];
    self.spawnedobjects = [[NSMutableArray alloc] init];
    if (self.tiltbool == true){
        [self startGame];
    }
    [self updateLifeIcons];
}


- (void)initialiseGameScene{
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    // Create and configure the scene.
    self.gamescene = [GameScene unarchiveFromFile:@"GameScene"];
    self.gamescene.scaleMode = SKSceneScaleModeAspectFill;
    [self.gamescene setBoundsWithCategory:0];
}

- (void)initialiseModel{
    self.model = [[GameModel alloc] initWithPlayer];
    [self.model setGroundtexture:self.groundtexture];
    [self.model setBackgroundtexture:self.bgtexture];
}

-(void) GameStart{
    [self setGameBackground];
    [self setGameGround];
    [self placePlayer:0];
    // Present the scene.
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    [skView presentScene:self.gamescene transition:[SKTransition fadeWithColor:[UIColor blackColor] duration:1]];
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
                [self stopPlayerLeft];
                [self stopPlayerRight];
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

- (void)setGameBackground{
    int distance = self.bgtexture.size.width*2;
    SKAction* moveBg = [SKAction moveByX:-distance y:0 duration:0.01 * distance];
    SKAction* resetBg = [SKAction moveByX:distance y:0 duration:0];
    SKAction* loopBgMovement = [SKAction repeatActionForever:[SKAction sequence:@[moveBg, resetBg]]];
    
    
    for( int i = 0; i < 2 + self.gamescene.frame.size.width; ++i ) {
        SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:self.bgtexture];
        [sprite setScale:0.55];
        sprite.zPosition = -20;
        sprite.lightingBitMask = 0x1 << 1;
        sprite.position = CGPointMake(i * sprite.size.width-(5*i), sprite.size.height/2);
        
        [sprite runAction:[SKAction runBlock:^{
            [sprite runAction:loopBgMovement];
        }]];
        
        [self.gamescene addChild:sprite];
    }
}

- (void)setGameGround{
    
    for( int i = 0; i < 2 + self.gamescene.frame.size.width / ( self.groundtexture.size.width * 2 ); ++i ) {
        // Create the sprite
        SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:self.groundtexture];
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

- (void)placePlayer:(int)scene{
    [self.model placePlayer:scene];
    switch (scene) {
        case 0:
            [self.gamescene addChild:self.model.player];
            break;
        case 1:
            [self.challengescene addChild:self.model.player];
            break;
        default:
            break;
    }
    
}





//Touch & Gesture handling

-(void) instantiateGestureRecognizers{
    [self instantiateSwipeRecognizer];
    [self instantiateDoubleTapRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ((touch.view == self.left || touch.view == self.right)) {
        return NO;
    }
    return YES;
}

- (void)instantiateDoubleTapRecognizer{
    self.doubleTapRecognizer =
    [[UITapGestureRecognizer alloc]initWithTarget:self
                                           action:@selector(handleDoubleTap)];
    self.doubleTapRecognizer.numberOfTapsRequired = 2;
    [self.doubleTapRecognizer setDelegate:self];
    [self.doubleTapRecognizer requireGestureRecognizerToFail:self.swipeRecognizer];
    [self.view addGestureRecognizer:self.doubleTapRecognizer];
}

-(void)handleDoubleTap {
    if([self getNodeTouched:(UITouch*)self.doubleTapRecognizer].class == NSClassFromString(@"Beehive")){
            [(Beehive*)[self getNodeTouched:(UITouch*)self.doubleTapRecognizer] deathAnimation];
            [self.model incrementScore:self.model.currentdifficulty * 10];
    }
    
}


- (void)instantiateSwipeRecognizer{
    self.swipeRecognizer =
    [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
    [self.swipeRecognizer setDelegate:self];
    [self.view addGestureRecognizer:self.swipeRecognizer];
}

-(void)handleSwipe:(UISwipeGestureRecognizer*)sender{
    if([self.gamescene nodeAtPoint:CGPointMake([sender locationInView:self.gamescene.view].x, ([sender locationInView:self.gamescene.view].y-self.gamescene.view.frame.size.height)*-1)].class== NSClassFromString(@"Bush")){
            [(Bush*)[self getNodeTouched:(UITouch*)self.swipeRecognizer] deathAnimation];
            [self.model incrementScore:self.model.currentdifficulty * 10];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        if ([self getNodeTouched:touch].class != NSClassFromString(@"Beehive")){
            [self.model jumpEntity:self.model.player];
        }
    }
}

-(SKNode*) getNodeTouched:(UITouch*)touch{
    return [self.gamescene nodeAtPoint:CGPointMake([touch locationInView:self.gamescene.view].x, ([touch locationInView:self.gamescene.view].y-self.gamescene.view.frame.size.height)*-1)];
}












//TIMERS
- (void)updaterfire{
    self.updatetimer = [NSTimer scheduledTimerWithTimeInterval:self.updatespeed target:self selector:@selector(updaterFireMethod:) userInfo:nil repeats:YES];
    [updatetimer fire];
}

- (void)updaterFireMethod:(NSTimer *)updatetimer{
    [self checkPlayerPos];
    if (self.startedbytilt == true || self.tiltbool == false) {
        [self spawnSomething];
        [self incrementScores];
    }
}

- (void)spawnSomething{
    float i = (double)self.model.difficultyscore/(double)self.model.difficultythreshold;
    //Should I spawn something?
    if ([self dicerollWithPercentage:(i*100+20)] == YES){
        //What should I spawn?
        if ([self dicerollWithPercentage:5]){//5% chance to spawn butterfly
            if (self.model.player.gotfollower == false){
                Butterfly *butterfly = [self.model spawnButterfly];
                [self.gamescene addChild:butterfly];
                [self checkIntroduction:butterfly];
                self.model.player.currentbutterfly = butterfly;
            } else {
                TactileObject *haven = [self.model spawnHaven];
                [self.gamescene addChild:haven];
                [self checkIntroduction:haven];
            }
            
        }else if ([self dicerollWithPercentage:(2)]){ //2% chance of remaining chance to spawn pit
            TactileObject *pit = [self.model spawnPit];
            [self.gamescene addChild:pit];
            [self checkIntroduction:pit];
            
        } else if ([self dicerollWithPercentage:(50)]==YES){ //50% chance of remaining chance to spawn obsticle/entity
            [self spawnRandomObstacle];
        } else {
            [self spawnRandomEnemy];
        }
    }
}

- (bool) dicerollWithPercentage:(int)percentage {
    return arc4random_uniform(100) < percentage;
}

- (void) spawnRandomObstacle{
    TactileObject *spawn = [self.model spawnRandomObstacle];
    [self checkIntroduction:spawn];
    [self.gamescene addChild:spawn];
}

- (void) spawnRandomEnemy{
    Enemy *spawn = [self.model spawnRandomEnemy];
    [self checkIntroduction:spawn];
    [self.gamescene addChild:spawn];
    [spawn animateSelf];
}


-(void)checkPlayerPos{
    if (self.model.player.position.x < 0){
        [self.model placePlayer:0];
        [self.model.player setPosition:CGPointMake(-20, self.model.player.position.y)];
    } else if (self.model.player.position.x > [UIScreen mainScreen].bounds.size.width){
        [self.model placePlayer:0];
        [self.model.player setPosition:CGPointMake([UIScreen mainScreen].bounds.size.width, self.model.player.position.y)];
    }
}


-(void)checkIntroduction:(TactileObject*)Tobj{
    bool containsobjectofclass = false;
    for (int i = 0; i < self.spawnedobjects.count; i++) {
        if ([self.spawnedobjects[i] isKindOfClass:Tobj.class]){
            containsobjectofclass = true;
        }
    }
    if(containsobjectofclass == false){
        [Tobj introduction:self.view];
        [self.spawnedobjects addObject:Tobj];
    }
}

- (void) incrementScores{
    [self.model incrementScore:self.model.currentdifficulty * 10];
    [self.model incrementDifficultyScore:1];
    [self.model updateDifficulty];
    self.score.text = [NSString stringWithFormat:@"Score: %d", self.model.score];
}

- (void) quitSelf{
    self.motionManager = nil;
    self.swipeRecognizer = nil;
    self.doubleTapRecognizer = nil;
    self.closing = true;
    self.model = nil;
    [(SKView*)self.view presentScene:nil];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void) checkLives{
    [self.model.player takeLife];
    [self updateLifeIcons];
    if (self.model.player.lives == 0){
        [self.updatetimer invalidate];
        
        UIAlertView *youdied = [[UIAlertView alloc]
                                initWithTitle:@"Game Over!"
                                message:[NSString stringWithFormat:@"You've run out lives!\n\n Your Score: %d\n\n Enter your name:", [self.model score] ]
                                delegate:self
                                cancelButtonTitle:@"Submit"
                                otherButtonTitles:@"Submit and Share on Facebook", nil];
        youdied.alertViewStyle = UIAlertViewStylePlainTextInput;
        [youdied show];
        self.screenshot = [self getScreenShot];
    };
}

//You died alert redirects here: when you click OK quits
-(void)alertView:(UIAlertView *)youdied clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        UITextField *playername = [youdied textFieldAtIndex:0];
        [self saveScoreWithName:playername.text Score:[self.model score] Facebook:false];
        [self quitSelf];
    } else if (buttonIndex == 1){
        UITextField *playername = [youdied textFieldAtIndex:0];
        [self saveScoreWithName:playername.text Score:[self.model score] Facebook:true];
    
    }
    
}


- (void)saveScoreWithName:(NSString*)name Score:(int)s Facebook:(bool)f{
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableArray* maad = [[NSMutableArray alloc]initWithArray:ad.highscores];
    bool replaced = false;
    for (int i = 0; i < maad.count; i++){
        NSArray *delimitedarray = [[maad objectAtIndex:i] componentsSeparatedByString:@":  "];
        if ([(NSNumber *)delimitedarray.lastObject intValue] <= s){
            [maad insertObject:[NSString stringWithFormat:@"%@:  %i", name, s] atIndex:i];
            replaced = true;
            break;
        }
    }
    ad.highscores = [maad copy];
    if (f == true){
        [self ShareScoreonFacebook];
    }
}

-(void)ShareScoreonFacebook{

    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [controller addImage:self.screenshot];
    controller.completionHandler= ^(SLComposeViewControllerResult result) {
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                NSLog(@"Cancelled");
                [self quitSelf];
                break;
            case SLComposeViewControllerResultDone:
                NSLog(@"Posted");
                [self quitSelf];
                break;
        }};
    
    [self presentViewController:controller animated:YES completion:nil];
}

-(UIImage*)getScreenShot{
    SKView * skView = (SKView *)self.view;
    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, NO, [UIScreen mainScreen].scale);
    [skView drawViewHierarchyInRect:[UIScreen mainScreen].bounds afterScreenUpdates:YES];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}




- (void) updateLifeIcons{
    [self.model updateLives];
    for (int i=0; i<self.model.lives.count; i++) {
        SKSpriteNode *life = self.model.lives[i];
        if (life.parent == nil){
            [self.gamescene addChild:self.model.lives[i]];
        }
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


//Contact handling
- (void)didBeginContact:(SKPhysicsContact *)contact {
    if(self.model.player.lives > 0){//Dont compute contact if player is dead
        if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == enemyCategory){
            [self checkLives];
        }else if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == lethalpassableCategory){
            [self checkLives];
        }else if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == lethalimpassableCategory){
            [self checkLives];
            
            
        }else if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == bogCategory){
            [self.model.player collidedWithBog];
            
            
        }else if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == mushroomCategory){
            Mushroom* ms = (Mushroom*)contact.bodyB.node;
            ms.physicsBody.categoryBitMask = 0x1 << 9;//Stops over collision
            [self stopPlayerLeft];
            [self stopPlayerRight];
            [ms deathAnimation];
            [self.model.player collidedWithMushroom];
            
            
        }else if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == pitCategory){
            [self.updatetimer invalidate];
            [self movetoPitScene];
            
            
        } else if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == berryCategory){
            Berry* berry = (Berry*)contact.bodyB.node;
            berry.physicsBody.categoryBitMask = 0x1 << 9;//Stops over collision
            [berry deathAnimation];
            [self.model incrementScore:500*self.model.currentdifficulty];
            SKView * skView = (SKView *)self.view;
            if (skView.scene == self.challengescene) {
                [self moveBackToGameScene];
            }
            

        } else if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == butterflyCategory){
            TactileObject* butterfly = (TactileObject*)contact.bodyB.node;
            [self followPlayer:butterfly];
            [self.model.player setGotfollower:true];
            
            
            
        } else if (contact.bodyA.categoryBitMask == butterflyCategory && contact.bodyB.categoryBitMask == havenCategory){
            TactileObject* butterfly = (TactileObject*)contact.bodyA.node;
            [butterfly removeFromParent];
            [self.model.player setGotfollower:false];
            [self.model incrementScore:200*self.model.currentdifficulty];
        }
    }
}

-(void)followPlayer:(SKSpriteNode*)node{
    [node removeActionForKey:@"movingwithground"];
    [node removeActionForKey:@"followingplayer"];
    [node runAction:[SKAction repeatActionForever:
                     [SKAction sequence:@[
                                          [SKAction runBlock:^{
                                            [node.physicsBody setVelocity:CGVectorMake(((self.model.player.position.x-self.model.player.frame.size.width*1.5) - node.position.x), ((self.model.player.position.y+(self.model.player.position.y/2)) -node.position.y) )];
                                                }]
                                          ,[SKAction waitForDuration:1.0]]]]withKey:@"followingplayer"];
    
}

- (void)movetoPitScene{
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    self.challengescene = [GameScene unarchiveFromFile:@"GameScene"];
    self.challengescene.scaleMode = SKSceneScaleModeAspectFill;
    [self.challengescene setBoundsWithCategory:1];
    // Create and configure the scene.
    [self setChallengeBackground:1];
    // Present the scene.
    [skView presentScene:self.challengescene transition:[SKTransition fadeWithColor:[UIColor blackColor] duration:1]];
    [self.gamescene removeAllChildren];
    self.gamescene = nil;
    [self placePlayer:1];
    [self moveButterfly:false];
    [self.model.player stopAnimation];
    [self.challengescene.children[0] setZPosition:5];
    [self.challengescene.children[1] setZPosition:20];
    [self.challengescene buildPitScene];
    [self.challengescene.physicsWorld setContactDelegate:self];
    [self updateLifeIcons];
}

- (void)setChallengeBackground:(int)challenge{
    SKSpriteNode* sprite = [[SKSpriteNode alloc] init];
    CGFloat screenwidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenheight = [UIScreen mainScreen].bounds.size.height;
    switch (challenge) {
        case 1:
            sprite = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"level1-bonus"]];
            [sprite setSize:CGSizeMake(screenwidth + 10, screenheight+20)];
            sprite.position = CGPointMake(CGRectGetMidX(self.gamescene.frame), CGRectGetMidY(self.gamescene.frame));
            [self.model.player addLightNode];
            [self.challengescene addChild:sprite];
            break;
            
        default:
            break;
    }
}


- (void) moveBackToGameScene{
    // Configure the view.
    [self.model.player removeLightNode];
    [self.challengescene removeAllChildren];
    [self initialiseGameScene];
    [self GameStart];
    [self updaterfire];
    [self.model.player animateSelf];
    [self.gamescene.physicsWorld setContactDelegate:self];
    [self moveButterfly:true];
    [self updateLifeIcons];
}


-(void)moveButterfly:(bool)toOrfromMainLevel{
    if (toOrfromMainLevel == false) {//Move from main level to challenge level
        if (self.model.player.gotfollower == true){
            [self.model.player.currentbutterfly removeFromParent];
            [self.challengescene addChild:self.model.player.currentbutterfly];
        }
    } else { //Move from challenge level to main level
        if (self.model.player.gotfollower == true){
            [self.model.player.currentbutterfly removeFromParent];
            [self.gamescene addChild:self.model.player.currentbutterfly];
        }
    }

}


//PLAYER MOVEMENT


- (void)movePlayerLeft{
    if (self.model.player.inmushroom == false) {
        [self.model moveTactileObjectLeft:self.model.player speed:(int)0];
    } else {
        [self.model moveTactileObjectRight:self.model.player speed:(int)0];
    }
}

-(void)movePlayerRight{
    if (self.model.player.inmushroom == false) {
        [self.model moveTactileObjectRight:self.model.player speed:(int)0];
    } else {
        [self.model moveTactileObjectLeft:self.model.player speed:(int)0];
    }
}

- (void)stopPlayerLeft{
    if (self.model.player.inmushroom == false) {
        [self.model stopTactileObjectMovement:self.model.player Direction:0];
    } else {
        [self.model stopTactileObjectMovement:self.model.player Direction:1];
    }
    [self pausePlayerAnimation];
}

- (void)stopPlayerRight{
    if (self.model.player.inmushroom == false) {
        [self.model stopTactileObjectMovement:self.model.player Direction:1];
    } else {
        [self.model stopTactileObjectMovement:self.model.player Direction:0];
    }
    [self pausePlayerAnimation];
}

- (void)pausePlayerAnimation{
    SKView * skView = (SKView *)self.view;
    if (skView.scene == self.challengescene) {
        [self.model.player stopAnimation];
    }
}








//UI ELEMENTS
-(void)addListenersToButtons{
    [self.left addTarget:self action:@selector(holdLeft) forControlEvents:UIControlEventTouchDown];
    [self.right addTarget:self action:@selector(holdRight) forControlEvents:UIControlEventTouchDown];
    [self.left addTarget:self action:@selector(releaseLeft) forControlEvents:UIControlEventTouchUpInside];
    [self.right addTarget:self action:@selector(releaseRight) forControlEvents:UIControlEventTouchUpInside];
    [self.left addTarget:self action:@selector(releaseLeft) forControlEvents:UIControlEventTouchUpOutside];
    [self.right addTarget:self action:@selector(releaseRight) forControlEvents:UIControlEventTouchUpOutside];
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
    [self stopPlayerLeft];
}

-(void)releaseRight
{
    [self stopPlayerRight];
}

-(IBAction)leftPressed:(UIButton*)sender{
    
}
-(IBAction)rightPressed:(UIButton*)sender{
    
}
-(IBAction)quitPressed:(UIButton*)sender{
    [self quitSelf];
}


@end
