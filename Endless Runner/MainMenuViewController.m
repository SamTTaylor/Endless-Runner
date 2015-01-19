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
    [self loadDefaults];
    //Defaults the first time the game is loaded
    self.tiltbool = false;
    self.groundtexture = [SKTexture textureWithImageNamed:@"ground"];//Ground is always based on the bgimage so it is not stored as a string
    self.svc = nil;
    self.gvc = nil;
    [self fillcostumearray];
    [self fillBackgroundArray];
}


//Makes sure that the main menu scrolling background is recreated when the view is reached by backing through the navigation controller
- (void) viewDidAppear:(BOOL)animated{
    self.groundtexture = [SKTexture textureWithImageNamed:@"ground"];
    [self saveDefaults];
    [self loadDefaults];
    [self loadAvatarandBG];
    [self initialiseMenuScene];
}

-(void)fillcostumearray{
    self.costumearray = [[NSMutableArray alloc] initWithObjects:
                        [UIImage imageNamed:@"avatar.gif"],
                        [UIImage imageNamed:@"GuardHat"],
                        [UIImage imageNamed:@"MiningHat"],
                        [UIImage imageNamed:@"SuperLenny"],
                        [UIImage imageNamed:@"Christmas"],
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
    [(SKView*)self.view presentScene:nil];
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
    SKAction* moveBg = [SKAction moveByX:-self.bgtexture.size.width*0.55 y:0 duration:0.015 * self.bgtexture.size.width*0.55];
    SKAction* resetBg = [SKAction moveByX:self.bgtexture.size.width*0.55 y:0 duration:0];
    SKAction* loopBgMovement = [SKAction repeatActionForever:[SKAction sequence:@[moveBg, resetBg]]];
    
    
    for( int i = 0; i < 3 ; ++i ) {
        SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:self.bgtexture];
        [sprite setScale:0.55];
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
    [self setMenuBackground];
    // Present the scene.
    [skView presentScene:self.menuscene];
}


-(void)loadDefaults{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.england = [defaults boolForKey:@"england"];
    self.austria = [defaults boolForKey:@"austria"];
    self.christmas = [defaults boolForKey:@"christmas"];
    self.halloween = [defaults boolForKey:@"halloween"];
    self.pit = [defaults boolForKey:@"pit"];
    self.superlenny = [defaults boolForKey:@"superlenny"];
    self.bgimageindex = [defaults integerForKey:@"bgimageindex"];
    self.costumeimageindex = [defaults integerForKey:@"costumeimageindex"];
}

-(void)saveDefaults{
    NSUserDefaults *defaults =
    [NSUserDefaults standardUserDefaults];
    [defaults setInteger:self.bgimageindex forKey:@"bgimageindex"];
    [defaults setInteger:self.costumeimageindex forKey:@"costumeimageindex"];
    [defaults synchronize];
}

-(void)loadAvatarandBG{
    if (self.bgimageindex > self.backgroundarray.count || self.bgimageindex <= 0) {
        self.bgimage = [UIImage imageNamed:@"background"];
        self.bgtexture = [SKTexture textureWithImageNamed:@"background"];
    } else {
        self.bgimage = self.backgroundarray[self.bgimageindex];
        self.bgtexture = [SKTexture textureWithImage:self.backgroundarray[self.bgimageindex]];
    }
    if (![self.costumearray objectAtIndex:self.costumeimageindex]) {
        self.costumeimage = [UIImage imageNamed:@"avatar.gif"];
    } else {
        self.costumeimage = self.costumearray[self.costumeimageindex];
    }
}

@end
