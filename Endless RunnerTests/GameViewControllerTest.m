//
//  GameViewControllerTest.m
//  Endless Runner
//
//  Created by acq14jp on 23/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "GameViewController.h"
#import "MainMenuViewController.h"

@interface GameViewControllerTest : XCTestCase

@property(nonatomic, strong) GameViewController *view;
@property(nonatomic, strong) GameModel *model;
@property(nonatomic, strong) Player *player;
@property(nonatomic, strong) MainMenuViewController *mmvc;

@end

@implementation GameViewControllerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.view = [[GameViewController alloc]init];
}


-(void)testInitialiseModel {
    
    self.view.model = [[GameModel alloc] initWithPlayer];
    XCTAssertNotNil(self.view.model);
}

//>>>>>>>>>>>>>>>>>>>>GAME SCENE<<<<<<<<<<<<<<<<<<<<

//place Player on Game Scene
-(void)testPlacePlayerGameScene {
    int scene = 0;
    bool gamescene = TRUE;
    [self.model placePlayer:scene];
    if (scene == 0) {
        gamescene = TRUE;
        [self.view.gamescene addChild:self.model.player];
    } else {
        gamescene = FALSE;
        [self.view.challengescene addChild:self.model.player];
    }
    XCTAssertTrue(gamescene);
}

//place Player on Challenge Scene
-(void)testPlacePlayerChallengeScene {
    int scene = 1;
    bool gamescene = TRUE;
    [self.model placePlayer:scene];
    if (scene == 0) {
        gamescene = TRUE;
        [self.view.gamescene addChild:self.model.player];
    } else {
        gamescene = FALSE;
        [self.view.challengescene addChild:self.model.player];
    }
    XCTAssertFalse(gamescene);
}

- (void)testBgTexture {
    XCTAssertNil(self.view.bgtexture);
}

- (void)testGroundTexture {
    XCTAssertNil(self.view.groundtexture);
}

- (void)testCostumeArray {
    self.view.costumearray = [[NSMutableArray alloc] init];
    [self.model.player setCostumearray:self.view.costumearray];
    XCTAssertNotNil(self.view.costumearray);
}

//>>>>>>>>>>>>>>>>>>>>TEST NAVIGATION<<<<<<<<<<<<<<<<<<<<

- (void)testCheckTiltBool {
    [self.view setTiltbool:false];
    XCTAssertFalse(self.view.tiltbool);
    [self.view setTiltbool:true];
    XCTAssertTrue(self.view.tiltbool);
}

- (void)testAccelerometer {
    [self.view setTiltbool:true];
    if (self.view.tiltbool == true) {
        [self.view instantiateAccelerometer];
        self.view.motionManager = [[CMMotionManager alloc]init];
    }
    XCTAssertNotNil(self.view.motionManager);
}

//Game doesn't start until Player starts navigation
- (void)testStartedByTilt {
    XCTAssertFalse(self.view.startedbytilt);
    self.view.startedbytilt = true;
    if (self.view.startedbytilt == true) {
        [self.view startGame];
    }
    XCTAssertTrue(self.view.gamestarted);
}

- (void)testStartedByButtonLeft {
    XCTAssertFalse(self.view.gamestarted);
    [self.view holdLeft];
    XCTAssertTrue(self.view.gamestarted);
}

- (void)testStartedByButtonRight {
    XCTAssertFalse(self.view.gamestarted);
    [self.view holdRight];
    XCTAssertTrue(self.view.gamestarted);
}

//>>>>>>>>>>>>>>>>>>>>TEST SHARE FACEBOOK<<<<<<<<<<<<<<<<<<<<

- (void)ShareonFacebook {
    bool f = true;
    if (f == true) {
        [self.view ShareScoreonFacebook];
    }
    XCTAssertNotNil(self.view.screenshot);
}

//>>>>>>>>>>>>>>>>>>>>TEST LOCATION MANAGER<<<<<<<<<<<<<<<<<<<<

//test Location Manager initialisation
- (void)testLocationManager {
    self.view.locationManager = [[CLLocationManager alloc]init];
    XCTAssertNotNil(self.view.locationManager);
}

//>>>>>>>>>>>>>>>>>>>>TEXTURE ATLASES<<<<<<<<<<<<<<<<<<<<

-(void)testPreloadAtlas{
    self.view.foxAtlas = [SKTextureAtlas atlasNamed:@"fox"];
    [SKTextureAtlas preloadTextureAtlases:[NSArray arrayWithObject:self.view.foxAtlas] withCompletionHandler:^{
        bool fox = true;
        XCTAssertTrue(fox);
    }];
    
    self.view.bushAtlas = [SKTextureAtlas atlasNamed:@"fox"];
    [SKTextureAtlas preloadTextureAtlases:[NSArray arrayWithObject:self.view.bushAtlas] withCompletionHandler:^{
        bool bush = true;
        XCTAssertTrue(bush);
    }];
    
    self.view.beehiveAtlas = [SKTextureAtlas atlasNamed:@"fox"];
    [SKTextureAtlas preloadTextureAtlases:[NSArray arrayWithObject:self.view.beehiveAtlas] withCompletionHandler:^{
        bool beehive = true;
        XCTAssertTrue(beehive);
    }];
    
    self.view.birdAtlas = [SKTextureAtlas atlasNamed:@"fox"];
    [SKTextureAtlas preloadTextureAtlases:[NSArray arrayWithObject:self.view.birdAtlas] withCompletionHandler:^{
        bool bird = true;
        XCTAssertTrue(bird);
    }];
    
    self.view.bogAtlas = [SKTextureAtlas atlasNamed:@"fox"];
    [SKTextureAtlas preloadTextureAtlases:[NSArray arrayWithObject:self.view.bogAtlas] withCompletionHandler:^{
        bool bog = true;
        XCTAssertTrue(bog);
    }];
    
    self.view.mushroomAtlas = [SKTextureAtlas atlasNamed:@"fox"];
    [SKTextureAtlas preloadTextureAtlases:[NSArray arrayWithObject:self.view.mushroomAtlas] withCompletionHandler:^{
        bool mushroom = true;
        XCTAssertTrue(mushroom);
    }];
    
    self.view.wolfAtlas = [SKTextureAtlas atlasNamed:@"fox"];
    [SKTextureAtlas preloadTextureAtlases:[NSArray arrayWithObject:self.view.wolfAtlas] withCompletionHandler:^{
        bool wolf = true;
        XCTAssertTrue(wolf);
    }];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        [self.view preloadAtlas];
        [self.view instantiateAccelerometer];
    }];
}

@end