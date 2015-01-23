//
//  PlayerTest.m
//  Endless Runner
//
//  Created by acq14jp on 21/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Player.h"
#import "GameModel.h"

@interface PlayerTest : XCTestCase

@property Player *player;
@property Entity *ent;
@property GameModel *model;

@end

@implementation PlayerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.player = [[Player alloc] initWithTexture:self.ent.nodetexture];
}

//Jumpcount can be set to any Value
- (void)testJumpCount{
    [self.player setJumpcount:3];
    XCTAssertEqual(self.player.jumpcount, 3);
    //Reset JumpCount
    [self.player resetJumpCount];
    XCTAssertEqual(self.player.jumpcount, 0);
}

//Test if player runs into Mushroom
- (void)testInMushroom{
    //Default is False
    XCTAssertFalse(self.player.inmushroom);
    //Set to true
    [self.player setInmushroom:true];
    XCTAssertTrue(self.player.inmushroom);
}

//Test if player runs into Bog
- (void)testInBog{
    //Default is False
    XCTAssertFalse(self.player.inbog);
    //Set to true
    [self.player setInmushroom:true];
    XCTAssertTrue(self.player.inmushroom);
}

//Player starts with 3 lives
- (void)testLives{
    XCTAssertEqual(self.player.lives, 3);
}

//Invulnerable is set to False
- (void)testInvulnerable{
    XCTAssertFalse(self.player.invulnerable);
    //Set to true
    [self.player setInvulnerable:true];
     XCTAssertTrue(self.player.invulnerable);
    //If invulnerable is true, we can't remove lives
    [self.model removeLife];
    XCTAssertEqual(self.player.lives, 3);
}

//Invulnerable is set to False
- (void)testGotFollower{
    XCTAssertFalse(self.player.gotfollower);
    //Set to true
    [self.player setGotfollower:true];
    XCTAssertTrue(self.player.gotfollower);
    //If Gotfollower is set to true true, we can't remove lives
    [self.model removeLife];
    XCTAssertEqual(self.player.lives, 3);
}


- (void)testWalkAnimation{
    
}

- (void)testJumpAnimation{

}

- (void)testInjuredAnimation{
    
}

//Player animation set to false by default
- (void)testAnimated{
     XCTAssertFalse(self.player.animated);
    //start animating player
    [self.player animateSelf];
    XCTAssertTrue(self.player.animated);
    //stop animating player
    [self.player setAnimated:false];
    XCTAssertFalse(self.player.animated);
}


- (void)testCostumeArray{
    self.player.costumearray = [[NSMutableArray alloc] init];
    XCTAssertNotNil(self.player.costumearray);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

@end
