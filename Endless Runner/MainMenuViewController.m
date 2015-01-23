//
//  MainMenuViewController.m
//  Endless Runner
//
//  Created by acp14stt on 02/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "MainMenuViewController.h"
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

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fillcostumearray];
    [self fillBackgroundArray];
    [self loadDefaults];
    [self initialiseLocationManager];
    //Defaults the first time the game is loaded
    self.groundtexture = [SKTexture textureWithImageNamed:@"ground"];//Ground is always based on the bgimage so it is not stored as a string
}


//Makes sure that the main menu scrolling background is recreated when the view is reached by backing through the navigation controller
- (void) viewDidAppear:(BOOL)animated{
    [self saveDefaults];
    [self loadDefaults];
    [self loadAvatarandBG];
    [self initialiseMenuScene];
    self.svc = nil;
    self.gvc = nil;
}

-(void)fillcostumearray{
    self.costumearray = [[NSMutableArray alloc] initWithObjects:
                        [UIImage imageNamed:@"avatar.gif"],
                        [UIImage imageNamed:@"GuardHat"],
                        [UIImage imageNamed:@"MiningHat"],
                        [UIImage imageNamed:@"SuperLenny"],
                        [UIImage imageNamed:@"christmas"],
                        [UIImage imageNamed:@"dracula-avatar"],
                        [UIImage imageNamed:@"lederhosen"],nil];
}

-(void)fillBackgroundArray{
    self.backgroundarray = [[NSMutableArray alloc] initWithObjects:
                            [UIImage imageNamed:@"background"],
                            [UIImage imageNamed:@"EnglandBG"],
                            [UIImage imageNamed:@"austria"],nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Sends the relevant settings information to the other view controller when a segue occurs
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.menuscene removeAllChildren];
    if ([[segue identifier]isEqualToString:@"segueToSettings"]) {
        self.svc = [segue destinationViewController];
        [self.svc setTiltbool:self.tiltbool];
        [self.svc setCurrentbgimage:self.bgimage];
        [self.svc setCurrentcostumeimage:self.costumeimage];
        [self.svc setCostumearray:self.costumearray];
        [self.svc setBackgroundarray:self.backgroundarray];
    }
    if ([[segue identifier]isEqualToString:@"segueToGame"]) {
        self.gvc = [segue destinationViewController];
        [self.gvc setPlayercostume:self.costumeimage];
        [self.gvc setTiltbool:self.tiltbool];
        [self.gvc setGroundtexture:self.groundtexture];
        [self.gvc setBgtexture:self.bgtexture];
        [self.gvc setCostumearray:self.costumearray];
    }
}

//Creates the scrolling menu background from the currently selected background texture
- (void)setMenuBackground{
    SKAction* moveBg = [SKAction moveByX:-self.bgtexture.size.width y:0 duration:0.015 * self.bgtexture.size.width];
    SKAction* resetBg = [SKAction moveByX:self.bgtexture.size.width y:0 duration:0];
    SKAction* loopBgMovement = [SKAction repeatActionForever:[SKAction sequence:@[moveBg, resetBg]]];
    
    
    for( int i = 0; i < 3 ; ++i ) {
        SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:self.bgtexture];
        sprite.position = CGPointMake(i * sprite.size.width-(5*i), sprite.size.height/2);
        [sprite runAction:loopBgMovement];
        [self.menuscene addChild:sprite];
    }
}


- (void)initialiseMenuScene{
    // Configure  the view.
    SKView * skView = (SKView *)self.view;
    skView.ignoresSiblingOrder = YES;
    //Pulls a blank scene from the file
    self.menuscene = [GameScene unarchiveFromFile:@"MenuScene"];
    self.menuscene.scaleMode = SKSceneScaleModeAspectFill;
    // Present the scene.
    [skView presentScene:self.menuscene];
    [self setMenuBackground];
}


//Gets all the achievement and default image data from the user defaults
-(void)loadDefaults{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.england = [defaults boolForKey:@"england"];
    self.austria = [defaults boolForKey:@"austria"];
    self.christmas = [defaults boolForKey:@"christmas"];
    self.halloween = [defaults boolForKey:@"halloween"];
    self.pit = [defaults boolForKey:@"pit"];
    self.superlenny = [defaults boolForKey:@"superlenny"];
    self.tiltbool = [defaults boolForKey:@"tilt"];
    self.bgimageindex = (int)[defaults integerForKey:@"bgimageindex"];
    self.costumeimageindex = (int)[defaults integerForKey:@"costumeimageindex"];
}

//Saves current costume and background between sessions
-(void)saveDefaults{
    NSUserDefaults *defaults =
    [NSUserDefaults standardUserDefaults];
    [defaults setInteger:self.bgimageindex forKey:@"bgimageindex"];
    [defaults setInteger:self.costumeimageindex forKey:@"costumeimageindex"];
    [defaults setBool:self.tiltbool forKey:@"tilt"];
    [defaults synchronize];
}

//Sets all the necessary values for initialisation and consistency in backgrounds between views
-(void)loadAvatarandBG{
    //If currently selected BG's index is not in the array
    if (self.bgimageindex > self.backgroundarray.count-1 || self.bgimageindex <= 0) {
        //set to default
        self.bgimage = self.backgroundarray[0];
        self.bgtexture = [SKTexture textureWithImage:self.backgroundarray[0]];
    } else {//if it is
        //set necessary values to the value represented by the index
        self.bgimage = self.backgroundarray[self.bgimageindex];
        self.bgtexture = [SKTexture textureWithImage:self.backgroundarray[self.bgimageindex]];
    }
    //Same with costume
    if (![self.costumearray objectAtIndex:self.costumeimageindex]) {
        self.costumeimage = [UIImage imageNamed:@"avatar.gif"];
    } else {
        self.costumeimage = self.costumearray[self.costumeimageindex];
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
         }
     }];
}


- (void)checkLocation{
    //Checks player location and if they are in a designated country it unlocks content in the user defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"england"] == false && [self.Country isEqualToString:@"United Kingdom"]) {
        [ToastView createToast:self.view text:@"You have unlocked the England Background and Guard Hat!" duration:5.0];
        [defaults setBool:true forKey:@"england"];//Player unlocks england background and guard hat for playing from england
    }
    if ([defaults boolForKey:@"austria"] == false && [self.Country isEqualToString:@"Austria"]) {
        [ToastView createToast:self.view text:@"You have unlocked the Austria Background and Lederhosen!" duration:5.0];
        [defaults setBool:true forKey:@"england"];//Player unlocks austria background and lederhosen for playing from austria
    }
}

@end
