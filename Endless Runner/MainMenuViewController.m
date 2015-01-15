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
    // Do any additional setup after loading the view.
    self.tiltbool = false;
    [self setBgimagestring:@"background"];
    [self setAvatarimagestring:@"avatar.gif"];
    self.bgtexture = [SKTexture textureWithImageNamed:self.bgimagestring];
    self.groundtexture = [SKTexture textureWithImageNamed:@"ground"];
    self.svc = nil;
    self.gvc = nil;
}

- (void) viewDidAppear:(BOOL)animated{
    [self setAvatarimagestring:@"avatar.gif"];
    [self setBgimagestring:@"background"];
    [self initialiseMenuScene];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [(SKView*)self.view presentScene:nil];
    if ([[segue identifier]isEqualToString:@"segueToSettings"]) {
        self.svc = [segue destinationViewController];
        [self.svc setTiltbool:self.tiltbool];
        [self.svc setBgimagestring:self.bgimagestring];
        [self.svc setAvatarimagestring:self.avatarimagestring];
    }
    if ([[segue identifier]isEqualToString:@"segueToGame"]) {
        self.gvc = [segue destinationViewController];
        [self.gvc setTiltbool:self.tiltbool];
        [self.gvc setGroundtexture:self.groundtexture];
        [self.gvc setBgtexture:self.bgtexture];
    }
}

- (void)setMenuBackground{
    SKAction* moveBg = [SKAction moveByX:-self.bgtexture.size.width*2 y:0 duration:0.015 * self.bgtexture.size.width*2];
    SKAction* resetBg = [SKAction moveByX:self.bgtexture.size.width*2 y:0 duration:0];
    SKAction* loopBgMovement = [SKAction repeatActionForever:[SKAction sequence:@[moveBg, resetBg]]];
    
    
    for( int i = 0; i < 2 + self.menuscene.frame.size.width; ++i ) {
        SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:self.bgtexture];
        [sprite setScale:0.55];
        sprite.position = CGPointMake(i * sprite.size.width-(5*i), sprite.size.height/2);
        [sprite runAction:loopBgMovement];
        [self.menuscene addChild:sprite];
    }
}

- (void)initialiseMenuScene{
    // Configure  jthe view.
    SKView * skView = (SKView *)self.view;
    skView.ignoresSiblingOrder = YES;
    self.menuscene = [GameScene unarchiveFromFile:@"MenuScene"];
    self.menuscene.scaleMode = SKSceneScaleModeAspectFill;
    [self setMenuBackground];
    // Present the scene.
    [skView presentScene:self.menuscene];
}

@end
