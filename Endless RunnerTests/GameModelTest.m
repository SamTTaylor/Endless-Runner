//
//  GameModelTest.m
//  Endless Runner
//
//  Created by acq14jp on 21/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "GameModel.h"

@interface GameModelTest : XCTestCase

@end

@implementation GameModelTest


- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testPlayer {
    GameModel *player = [[GameModel alloc] initWithPlayer];
}

-(void)testGroundNode {

}

-(void)testTiltSensitivity {
    GameModel *tiltsensitivity = [[GameModel alloc] init];
    float test_sensitivity = 0.08;
    
    XCTAssertEqual(tiltsensitivity, test_sensitivity);
}

-(void)testEnemies {
    GameModel *enemies = [[GameModel alloc] init];
}

-(void)testObstacles {
    GameModel *obstacles = [[GameModel alloc] init];
}

-(void)testLives {
    GameModel *lives = [[GameModel alloc] init];
}

-(void)testScore {
    GameModel *score = [[GameModel alloc] init];
}

-(void)testDifficultyScore {
    GameModel *difficultyscore = [[GameModel alloc] init];
}

-(void)testDifficultyThreshold {
    GameModel *difficultythresold = [[GameModel alloc] init];
}

-(void)testCurrentDifficulty {
    GameModel *currentdifficulty = [[GameModel alloc] init];
}

-(void)testGroundSpeed {
    GameModel *groundspeed = [[GameModel alloc] init];
}

-(void)testGroundTexture {
    GameModel *groundTexture = [[GameModel alloc] init];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
