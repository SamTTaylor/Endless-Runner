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
//Pulls blank Gamescene from the file
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

//All bit categories are kept as constants for easier reference
static const int playerCategory = 0x1 << 1, enemyCategory = 0x1 << 2, bogCategory = 0x1 << 5, lethalpassableCategory = 0x1 << 6, mushroomCategory = 0x1 << 7, lethalimpassableCategory = 0x1 << 8, pitCategory = 0x1 << 10, berryCategory = 0x1 << 11, butterflyCategory = 0x1 << 12, havenCategory = 0x1 << 13;


NSTimer *updatetimer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Load new game
    [self initialiseGameScene];//Starts main level for the first time
    [self initialiseModel];//Creates a fresh model
    [self GameStart];//Sets the game in motion
    [self.gamescene.physicsWorld setContactDelegate:self];//Used to read collision data from the main scene
    [self checkTiltBool];
    self.gamestarted = false;
    self.startedbytilt = false;
    [self addListenersToButtons];
    [self instantiateGestureRecognizers];
    self.spawnedobjects = [[NSMutableArray alloc] init];//No objects spawned at the start
    if (self.tiltbool == true){
        [self startGame];
    }
    [self updateLifeIcons];//Shows the life icons held in the Model's array
    [self dressPlayer];
    [self initialiseLocationManager];
    [self checkDate];
}






//>>>>>>>>>>>>>>>>>>>>INITIALISATION<<<<<<<<<<<<<<<<<<<<
- (void)initialiseGameScene{
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    // Create and configure the scene.
    self.gamescene = [GameScene unarchiveFromFile:@"GameScene"];
    self.gamescene.scaleMode = SKSceneScaleModeAspectFill;
    [self.gamescene setBoundsWithCategory:0];//Draw main scene bounds from GameScene method
}

- (void)initialiseModel{//Blank model with player created, model is told what the set ground texture is
    self.model = [[GameModel alloc] initWithPlayer];
    [self.model setGroundtexture:self.groundtexture];
}

//Puts the game in a state where it is displayed but update timer is paused until the player moves
-(void) GameStart{
    [self setGameBackground];//Adds scrolling background
    [self setGameGround];//Adds scrolling foreground
    [self placePlayer:0];//Adds player at bottom left
    // Present the scene.
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    //After all the initialisation is done, scene can be shown
    [skView presentScene:self.gamescene transition:[SKTransition fadeWithColor:[UIColor blackColor] duration:1]];
}

- (void)startGame{
    //Lets get going
    if (self.gamestarted == false) {//Stops the game being started multiple times
        self.gamestarted = true;
        self.updatespeed = 1;
        [self updaterfire];//Initialises and sets the updater timer going
    }
}

//Applies the player's current costume using the specific position it needs to be on the player from the AssignCostumePosition method, and then joining it to the player there in the current physicsworld
-(void)dressPlayer{
    SKView * skView = (SKView *)self.view;
    [self.model.player setCostume:self.playercostume];
    [self.model.player setCostumearray:self.costumearray];
    [self.model.player assignCostumePosition];
    
    CGPoint point = CGPointMake(0, 0);
    CGPoint point2 = [self.model.player assignCostumePosition];
    if (!CGPointEqualToPoint(point, point2)) {//Don't apply costume if it is the default model
        SKSpriteNode* node = [self.model dressPlayer];
        [skView.scene addChild:node];
        SKPhysicsJointFixed *joint = [SKPhysicsJointFixed jointWithBodyA:node.physicsBody bodyB:self.model.player.physicsBody anchor:CGPointMake(self.model.player.position.x, self.model.player.position.y)];
        
        [skView.scene.physicsWorld addJoint:joint];
    }
}


//Compares todays date with key dates for unlocking achievements
- (void) checkDate{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"DD-MM"];
    NSString *christmas = @"25-12";
    NSString *halloween = @"31-10";
    NSString *today = [formatter stringFromDate:[NSDate date]];
    NSComparisonResult result = [today compare:christmas];
    switch (result) {
        case NSOrderedSame:
            //Dont unlock it twice
            if ([defaults boolForKey:@"christmas"] == false) {
                [ToastView createToast:self.view text:@"You have unlocked the Santa Hat!" duration:5.0];
                [self.model saveAchievement:@"christmas"];//Player unlocks santa hat for playing on christmas
            }
            break;
        default:
            break;
    }
    result = [today compare:halloween];
    switch (result) {
        case NSOrderedSame:
            //Dont unlock it twice
            if ([defaults boolForKey:@"halloween"] == false) {
                [ToastView createToast:self.view text:@"You have unlocked the Vampire Costume!" duration:5.0];
                [self.model saveAchievement:@"halloween"];//Player unlocks vampire costume for playong on halloween
            }
            break;
        default:
            break;
    }
}





//>>>>>>>>>>>>>>>>>>>>MOTION<<<<<<<<<<<<<<<<<<<<
- (void)instantiateAccelerometer{
    //Prepare the Accelerometer
    self.motionManager = [[CMMotionManager alloc]init];
    if (self.motionManager.accelerometerAvailable) {
        self.motionManager.accelerometerUpdateInterval = 0.01;
        [self.motionManager startAccelerometerUpdates];
        
        self.accelerometerHandler = ^(CMAccelerometerData *accData, NSError *error) {
            self.yRotation = accData.acceleration.y;
            if (self.yRotation > self.model.tiltsensitivity){//If you're tilting left over the threshold, move the player left
                [self movePlayerLeft];
                self.startedbytilt = true;//Allows the game to be started by the update timer
            }
            if (self.yRotation < -self.model.tiltsensitivity){//If you're tilting right over the threshold, move the player right
                [self movePlayerRight];
                self.startedbytilt = true;
            }
            if (self.yRotation < self.model.tiltsensitivity && self.yRotation > -self.model.tiltsensitivity){//If you are not over the threshold in any direction, stop the player moving
                [self stopPlayerLeft];
                [self stopPlayerRight];
            }
        };
        // fire off regular animation updates via a timer
        [self.motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc]init] withHandler:self.accelerometerHandler];
    }
    else {
        //No accelerometer detected
        self.motionManager = nil;
    }
}

//Shows buttons if the tilt movement is not requested by user, else it hides them and starts the accelerometer
- (void)checkTiltBool{
    if (self.tiltbool == true){
        self.left.hidden = true;
        self.right.hidden = true;
        [self instantiateAccelerometer];
        [ToastView createToast:self.view text:@"Tilt to begin, tap to jump!" duration:5.0];//Toast for instruction
    } else {
        [ToastView createToast:self.view text:@"Press movement buttons to begin, tap to jump!" duration:5.0];
        self.left.hidden = false;
        self.right.hidden = false;
    }
}








//>>>>>>>>>>>>>>>>>>>>ENVIRONMENT<<<<<<<<<<<<<<<<<<<<
- (void)setGameBackground{
    int distance = self.bgtexture.size.width*0.55;
    //Move the background picture far offscreen, then reset it and move it across again
    SKAction* moveBg = [SKAction moveByX:-distance y:0 duration:0.01 * distance];
    SKAction* resetBg = [SKAction moveByX:distance y:0 duration:0];
    SKAction* loopBgMovement = [SKAction repeatActionForever:[SKAction sequence:@[moveBg, resetBg]]];
    
    //Create many layers of pictures for a seemless effect
    for( int i = 0; i < 3; ++i ) {//3 copies are made for seemless loops
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

//Move game ground in the same way but a little faster to give the illusion of depth
- (void)setGameGround{
    for( int i = 0; i < 3; ++i ) {
        // Create the sprite
        SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:self.groundtexture];
        sprite.yScale = 0.4;
        sprite.position = CGPointMake(i * sprite.size.width-(30*i),sprite.size.height/2);
        [self.model moveNodeWithGround:sprite Repeat:true];
        [self.gamescene addChild:sprite];
    }
    
    //Adds an invisible tactile node for everything to stand on in the physical world
    self.model.groundnode = [SKNode node];
    self.model.groundnode.position = CGPointMake(0, 20);
    self.model.groundnode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.gamescene.size.width*4, 50)];
    self.model.groundnode.physicsBody.dynamic = NO;
    self.model.groundnode.physicsBody.categoryBitMask = 0x1 << 3;
    self.model.groundnode.physicsBody.collisionBitMask = 0x1 << 2;
    self.model.groundnode.physicsBody.contactTestBitMask = 0x1 << 2;
    [self.gamescene addChild:self.model.groundnode];
}


//Passes player placement to the relevant method in the model, the scene in corresponds to the correct position int in the model's method so the player is always put in the right position for the scene selected
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










//>>>>>>>>>>>>>>>>>>>>TOUCHG & GESTURE HANDLING<<<<<<<<<<<<<<<<<<<<
//Tidy method for all gesture recognizers
-(void) instantiateGestureRecognizers{
    [self instantiateSwipeRecognizer];
    [self instantiateDoubleTapRecognizer];
}

//Stops gesture recognizers from delaying input if the user is trying to use the movement buttons
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ((touch.view == self.left || touch.view == self.right)) {
        return NO;
    }
    return YES;
}

//Recognizes double taps
- (void)instantiateDoubleTapRecognizer{
    self.doubleTapRecognizer =
    [[UITapGestureRecognizer alloc]initWithTarget:self
                                           action:@selector(handleDoubleTap)];
    self.doubleTapRecognizer.numberOfTapsRequired = 2;
    [self.doubleTapRecognizer setDelegate:self];
    [self.doubleTapRecognizer requireGestureRecognizerToFail:self.swipeRecognizer];//Swipe recognizer takes precedence
    [self.view addGestureRecognizer:self.doubleTapRecognizer];
}

//If a double tap is recognized, check the class of the node it occurred in, if it is a beehive, destroy it & give the player a little reward depending on the current difficulty level
-(void)handleDoubleTap {
    if([self getNodeTouched:(UITouch*)self.doubleTapRecognizer].class == NSClassFromString(@"Beehive")){
            [(Beehive*)[self getNodeTouched:(UITouch*)self.doubleTapRecognizer] deathAnimation];
            [self.model incrementScore:self.model.currentdifficulty * 10];
    }
    
}

//Recognizes swipes
- (void)instantiateSwipeRecognizer{
    self.swipeRecognizer =
    [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
    [self.swipeRecognizer setDelegate:self];
    [self.view addGestureRecognizer:self.swipeRecognizer];
}

//If a swipe is recognized, check the class of the node it started in, if it is a bush, destroy it & give the player a little reward depending on the current difficulty level
-(void)handleSwipe:(UISwipeGestureRecognizer*)sender{
    if([self.gamescene nodeAtPoint:CGPointMake([sender locationInView:self.gamescene.view].x, ([sender locationInView:self.gamescene.view].y-self.gamescene.view.frame.size.height)*-1)].class== NSClassFromString(@"Bush")){
            [(Bush*)[self getNodeTouched:(UITouch*)self.swipeRecognizer] deathAnimation];
            [self.model incrementScore:self.model.currentdifficulty * 10];
    }
}

//Every touch that is registered inside the SKView is caught and will make the player jump unless its inside a beehive, as causing the player to jump when they want to double tap a beehive often causes death
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        if ([self getNodeTouched:touch].class != NSClassFromString(@"Beehive")){
            [self.model jumpEntity:self.model.player];
        }
    }
}

//Returns the node touched at the point, the touch and node coordinates need to be "converted" from their respective views to match up.
-(SKNode*) getNodeTouched:(UITouch*)touch{
    return [self.gamescene nodeAtPoint:CGPointMake([touch locationInView:self.gamescene.view].x, ([touch locationInView:self.gamescene.view].y-self.gamescene.view.frame.size.height)*-1)];
}












//>>>>>>>>>>>>>>>>>>>>TIMERS<<<<<<<<<<<<<<<<<<<<
//Instanciates and fires the updater timer based on the updatespeed set on initialisation
- (void)updaterfire{
    self.updatetimer = [NSTimer scheduledTimerWithTimeInterval:self.updatespeed target:self selector:@selector(updaterFireMethod:) userInfo:nil repeats:YES];
    [updatetimer fire];
}

//Stops the player wandering off screen, runs the spawn an object method and increments score & difficulty every tick (if tilt is enabled, it waits for the startedbytilt variable to be enabled before it takes action)
- (void)updaterFireMethod:(NSTimer *)updatetimer{
    [self checkPlayerPos];
    if (self.startedbytilt == true || self.tiltbool == false) {
        [self spawnSomething];
        [self incrementScores];
    }
}

//Spawns (or doesn't spawn) a random object, used by the update timer
- (void)spawnSomething{
    //Used to get a % reprisentation of progress through the current level
    float i = (double)self.model.difficultyscore/(double)self.model.difficultythreshold;
    //If the dice rolls YES to the % reprisentation then an object is spawned
    //+20% is added so that the player doesn't have to wait forever to see the first minion each level
    if ([self dicerollWithPercentage:(i*100+20)] == YES){
        //What should I spawn?
        if ([self dicerollWithPercentage:5]){//5% chance to spawn butterfly or haven in the first instance
            if (self.model.player.gotfollower == false){//If there is no butterfly present one is spawned
                Butterfly *butterfly = [self.model spawnButterfly];
                [self.gamescene addChild:butterfly];
                [self checkIntroduction:butterfly];//Intro text tells the player what to do
                self.model.player.currentbutterfly = butterfly;
            } else {//If a butterfly is present a haven is spawned in its place
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

//Rolls a dice with success chance of the passed int as a percentage
- (bool) dicerollWithPercentage:(int)percentage {
    return arc4random_uniform(100) < percentage;
}


//Uses the model's spawn method to add a random obstacle node to the game scene
- (void) spawnRandomObstacle{
    TactileObject *spawn = [self.model spawnRandomObstacle];
    [self.gamescene addChild:spawn];
    [self checkIntroduction:spawn];//If one has not been spawned before it introduces it
}

//Uses the model's spawn method to add a random enemy node to the game scene
- (void) spawnRandomEnemy{
    Enemy *spawn = [self.model spawnRandomEnemy];
    [self.gamescene addChild:spawn];
    [self checkIntroduction:spawn];
    [spawn animateSelf];//Asks the enemy to perform any relevant animations it has
    
}

//Stops player from running off screen, called by the updater timer
-(void)checkPlayerPos{
    if (self.model.player.position.x < 0){//if player is off to the left
        [self.model placePlayer:0];//Places player bottom left using the model method
        //Then shuffles him even further to the left so the "ping back" isn't as jarring
        [self.model.player setPosition:CGPointMake(-20, self.model.player.position.y)];
    } else if (self.model.player.position.x > [UIScreen mainScreen].bounds.size.width){//If player is off to the right
        [self.model placePlayer:0];//Places player in default position
        [self.model.player setPosition:CGPointMake([UIScreen mainScreen].bounds.size.width, self.model.player.position.y)];//Then moves him to just off of the screen to the right
    }
}

//If an object of each class has not been spawned yet, this calls their introduciton toast
-(void)checkIntroduction:(TactileObject*)Tobj{
    bool containsobjectofclass = false;//Innocent until proven guilty
    for (int i = 0; i < self.spawnedobjects.count; i++) {//Cycles through the array
        if ([self.spawnedobjects[i] isKindOfClass:Tobj.class]){//Checks their class against the passed Tobj
            containsobjectofclass = true;
        }
    }
    if(containsobjectofclass == false){//If it is not in the array, it puts the toast in the current view
        [Tobj introduction:self.view];
        [self.spawnedobjects addObject:Tobj];//And adds it to the array so it will not be introduced again
    }
}

//Increments score, difficulty in the model & UI label, and calls for a difficulty update check from the model all at once
- (void) incrementScores{
    [self.model incrementScore:self.model.currentdifficulty * 10];
    [self.model incrementDifficultyScore:1];
    [self.model updateDifficulty];
    self.score.text = [NSString stringWithFormat:@"Score: %d", self.model.score];
}

//Shuts everything down & returns to the main menu view controller
- (void) quitSelf{
    [self.updatetimer invalidate];
    self.motionManager = nil;
    self.swipeRecognizer = nil;
    self.doubleTapRecognizer = nil;
    self.closing = true;
    self.model = nil;
    [(SKView*)self.view presentScene:nil];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

//Tries to take a life off of the player using it's own method, and then calls for an update on the life icons to represent any change
- (void) checkLives{
    [self.model.player takeLife];
    [self updateLifeIcons];
    
    //If the player is at 0 lives (dead), game over alert dialogue is shown & update timer is stopped
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
        //Screenshot of the victim is taken upon death
        self.screenshot = [self getScreenShot];
    };
}

//You died alert redirects here: if you click Submit it quits & records your score, if you click submit to facebook, it lets the save method know to trigger the facebook share when it's done
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


//Takes the player's name and score, then compares the score against the current highscore array by copying it into a new array and splitting each string in that array using the delimiter ":  " and taking the last object, which can only be the score itself, before comparing it. If the current score is higher than any of them, it is inserted at that position, pushing the rest down a peg
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
    ad.highscores = [maad copy]; //Copies the local mutable array into the highscores array
    
    //Now write highscores array to plist
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    [ad.highscores writeToFile:[documentsDirectory stringByAppendingPathComponent:@"LennyHighScores.plist"] atomically:YES];
    
    if (f == true){//If share on facebook is selected the method is triggered
        [self ShareScoreonFacebook];
    }
}


//Instantiates the facebook sharing view controller and passes it the screenshot to upload as proof of the score, lets the user type in any message they want before posting
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
        }};//No matter the outcome, the user is returned to the main menu afterward
    
    [self presentViewController:controller animated:YES completion:nil];
}



//Pulls a screenshot of the current SKView inside the screens bounds
-(UIImage*)getScreenShot{
    SKView * skView = (SKView *)self.view;
    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, NO, [UIScreen mainScreen].scale);
    [skView drawViewHierarchyInRect:[UIScreen mainScreen].bounds afterScreenUpdates:YES];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}



//Updates the model's Lives array, then runs through it and adds each of the nodes to the gamescene if they are not there already
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










//>>>>>>>>>>>>>>>>>>>>CONTACT HANDLING<<<<<<<<<<<<<<<<<<<<<<<
//Checks every relevant combination of contact to the game and performs actions based on it, when contact occurs. If the player is dead (lives < 0), no contact is computed because the game is over.
- (void)didBeginContact:(SKPhysicsContact *)contact {
    if(self.model.player.lives > 0){//Dont compute contact if player is dead
        
        //Kill player contact combinations, seperated for clarity & in case distinction is made later.
        //Player vs any enemy
        if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == enemyCategory){
            [self checkLives];//Check lives tries to take a life from the player
        //Player vs any lethal solid object
        }else if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == lethalpassableCategory){
            [self checkLives];
        //Player vs any lethal intangible object
        }else if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == lethalimpassableCategory){
            [self checkLives];
            
        //Player vs Bog
        }else if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == bogCategory){
            [self.model.player collidedWithBog]; //Calls the reaction from the player class
            
        //Player vs mushroom
        }else if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == mushroomCategory){
            Mushroom* ms = (Mushroom*)contact.bodyB.node;
            ms.physicsBody.categoryBitMask = 0x1 << 9;//Stops over collision
            [self stopPlayerLeft];//Stops player movement so they dont get too confused by the change
            [self stopPlayerRight];
            [ms deathAnimation]; //Asks mushroom to kill itself after performing any relevant animations
            [self.model.player collidedWithMushroom];//Calls the reaction from the player class
            
        //Player vs Pit
        }else if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == pitCategory){
            [self.updatetimer invalidate];//Timer is invalidated in order to pause progress of the game during the challenge
            [self movetoPitScene]; //Moves player to the pit challenge scene
            
        //Player vs Berry
        } else if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == berryCategory){
            Berry* berry = (Berry*)contact.bodyB.node;
            berry.physicsBody.categoryBitMask = 0x1 << 9;//Stops over collision
            [berry deathAnimation];//Asks berry to kill itself after performing any relevant animations
            [self.model incrementScore:500*self.model.currentdifficulty];//Give player a bunch of points
            
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            //Dont unlock twice
            if ([defaults boolForKey:@"pit"] == false) {
                [self.model saveAchievement:@"pit"];//Player unlocks mining helmet for beating the pit
                
            }
            
            SKView * skView = (SKView *)self.view;
            if (skView.scene == self.challengescene) {
                [self moveBackToGameScene];//Transport player back to main game
            }
            
        //Player vs Butterfly
        } else if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == butterflyCategory){
            TactileObject* butterfly = (TactileObject*)contact.bodyB.node;
            [self.model followPlayer:butterfly];//Tells the butterfly to follow the player
            [self.model.player setGotfollower:true]; //Player is only allowed 1 follower, this bool is used to make sure of that
            
            
        //Butterfly vs Haven
        } else if (contact.bodyA.categoryBitMask == butterflyCategory && contact.bodyB.categoryBitMask == havenCategory){
            TactileObject* butterfly = (TactileObject*)contact.bodyA.node;
            [butterfly removeFromParent]; //Destroy the butterfly, no animation
            [self.model.player setGotfollower:false];//Player no longer has a follower, allows butterflies to be spawned again
            [self.model incrementScore:200*self.model.currentdifficulty];//Give player a decent amount of points for their trouble
        }
    }
}


//Lots of setup required to move to the Pit Scene
- (void)movetoPitScene{
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    //Get blank scene from the file
    self.challengescene = [GameScene unarchiveFromFile:@"GameScene"];
    self.challengescene.scaleMode = SKSceneScaleModeAspectFill;
    [self.challengescene setBoundsWithCategory:1];//Set bounds relevant to the pit using the scene method
    // Create and configure the scene.
    [self setChallengeBackground:1];//Set pit texture as background
    // Present the scene with a fade to black transition
    [skView presentScene:self.challengescene transition:[SKTransition fadeWithColor:[UIColor blackColor] duration:1]];
    //Used to remove any mid-animation nodes from the gamescene and free up memory
    [self.gamescene removeAllChildren];
    self.gamescene = nil;
    [self placePlayer:1];//Place player in position relevant to the pit scene
    [self moveButterfly:false];//Move the butterfly to the new scene to maintain the node
    [self.model.player stopAnimation];//Player is no longer running so needs to stop to take a rest
    [self.challengescene.children[0] setZPosition:5];//Some layer troubles needed to be reinforced
    [self.challengescene.children[1] setZPosition:20];
    [self.challengescene buildPitScene];//Build the scene using the method in the GameScene class
    [self.challengescene.physicsWorld setContactDelegate:self]; //Look for contact in this scene
    [self updateLifeIcons];
    [self dressPlayer];
}


//Will be expanded upon for each background, for now, it just sets the background to the pit level texture & fits it with fine tuned positioning
- (void)setChallengeBackground:(int)challenge{
    SKSpriteNode* sprite = [[SKSpriteNode alloc] init];
    CGFloat screenwidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenheight = [UIScreen mainScreen].bounds.size.height;
    switch (challenge) {
        case 1:
            sprite = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"level1-bonus"]];
            [sprite setSize:CGSizeMake(screenwidth + 10, screenheight+20)];
            sprite.position = CGPointMake(CGRectGetMidX(self.gamescene.frame), CGRectGetMidY(self.gamescene.frame));
            [self.model.player addLightNode];//Adds a light node to the player for realism
            [self.challengescene addChild:sprite];
            break;
            
        default:
            break;
    }
}


//Destroys the current challenge scene and moves back to the main game
- (void) moveBackToGameScene{
    // Configure the view.
    [self.model.player removeLightNode]; //Its bright outside, no need for that
    [self.challengescene removeAllChildren];
    [self initialiseGameScene]; //(re)initialise
    [self GameStart];//(re)start
    [self updaterfire];//Start counting scores again
    [self.model.player animateSelf];//Player is running again
    [self.gamescene.physicsWorld setContactDelegate:self];//Listen for collisions in the main game
    [self moveButterfly:true]; //Butterfly follows to main level
    [self updateLifeIcons];//Refresh life icons
    [self dressPlayer];
}

//Moves any present butterfly to where the player is going
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

//Move player left if not affected by a mushroom, else move them right, using the method in the model
- (void)movePlayerLeft{
    if (self.model.player.inmushroom == false) {
        [self.model moveTactileObjectLeft:self.model.player speed:(int)0];
    } else {
        [self.model moveTactileObjectRight:self.model.player speed:(int)0];
    }
}

//Opposite of movePlayerLeft
-(void)movePlayerRight{
    if (self.model.player.inmushroom == false) {
        [self.model moveTactileObjectRight:self.model.player speed:(int)0];
    } else {
        [self.model moveTactileObjectLeft:self.model.player speed:(int)0];
    }
}

//stop player moving & check if you should pause the animation
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


//If the player is in a challenge, stop running animation while he is not moving
- (void)pausePlayerAnimation{
    SKView * skView = (SKView *)self.view;
    if (skView.scene == self.challengescene) {
        [self.model.player stopAnimation];
    }
}













//>>>>>>>>>>>>>>>>>>>>LOCATION HANDLING<<<<<<<<<<<<<<<<<<<<
-(void)initialiseLocationManager{
    // create a location manager if we don't have one
    if (self.locationManager==nil)
        self.locationManager = [[CLLocationManager alloc]init];
    // this object will act as the delegate
    self.locationManager.delegate = self;
    // set the desired accuracy of location estimates
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    // set the movement threshold for new events
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    //RequestPermission
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    // start the service
    [self.locationManager startUpdatingLocation];

}

//Receiving location updates
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.location = [locations objectAtIndex:0];
    [self.locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:self.location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             self.Country = [[NSString alloc]initWithString:placemark.country];
             [self.locationManager stopUpdatingLocation];
             [self checkLocation];
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
         }}];
}


- (void)checkLocation{
    //Checks player location and if they are in a designated country it unlocks content in the user defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"england"] == false && [self.Country isEqualToString:@"United Kingdom"]) {
        [ToastView createToast:self.view text:@"You have unlocked the England Background and Guard Hat!" duration:5.0];
        [self.model saveAchievement:@"england"];//Player unlocks england background and guard hat for playing from england
    }
    if ([defaults boolForKey:@"austria"] == false && [self.Country isEqualToString:@"Austria"]) {
        [ToastView createToast:self.view text:@"You have unlocked the Austria Background and Lederhosen!" duration:5.0];
        [self.model saveAchievement:@"austria"];//Player unlocks austria background and lederhosen for playing from austria 
    }
}


//>>>>>>>>>>>>>>>>>>>>UI ELEMENTS<<<<<<<<<<<<<<<<<<<<
//These listeners allow for a more responsive and fluid control of the player using the buttons
-(void)addListenersToButtons{
    [self.left addTarget:self action:@selector(holdLeft) forControlEvents:UIControlEventTouchDown];
    [self.right addTarget:self action:@selector(holdRight) forControlEvents:UIControlEventTouchDown];
    [self.left addTarget:self action:@selector(releaseLeft) forControlEvents:UIControlEventTouchUpInside];
    [self.right addTarget:self action:@selector(releaseRight) forControlEvents:UIControlEventTouchUpInside];
    [self.left addTarget:self action:@selector(releaseLeft) forControlEvents:UIControlEventTouchUpOutside];
    [self.right addTarget:self action:@selector(releaseRight) forControlEvents:UIControlEventTouchUpOutside];
}

//If the game is not started, start it, and move player left, while the button is held down
-(void)holdLeft
{
    [self startGame];
    [self movePlayerLeft];
}

//If the game is not started, start it, and move player right, while the button is held down
-(void)holdRight
{
    [self startGame];
    [self movePlayerRight];
}

//Stop player moving left when left button is released
-(void)releaseLeft
{
    [self stopPlayerLeft];
}
//Stop the player from moving right when the right button is released
-(void)releaseRight
{
    [self stopPlayerRight];
}

//Methods take care of movement, IBAction is too clumsy
-(IBAction)leftPressed:(UIButton*)sender{
    
}
-(IBAction)rightPressed:(UIButton*)sender{
    
}

//Quit self if quit button is pressed
-(IBAction)quitPressed:(UIButton*)sender{
    [self quitSelf];
}


@end
