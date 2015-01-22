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

@interface GameModelTest : XCTestCase {
    
    Player *player;
    float tiltsensitivity;
    NSMutableArray *enemies;
    NSMutableArray *obstacles;
    NSMutableArray *lives;
    int score;
    int difficultyscore;
    int difficultythreshold;
    int currentdifficulty;
    int groundspeed;
}

@end

@implementation GameModelTest


- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

-(void)testPlayer {
    player = [[Player alloc] init];
    XCTAssertNotNil(player);
}

-(void)testTiltSensitivity {
    XCTAssertEqual(tiltsensitivity, 0.0);
}

-(void)testGroundNode {

}


-(void)testEnemiesArray {
    enemies = [[NSMutableArray alloc] init];
    XCTAssertNotNil(enemies);
};

-(void)testObstaclesArray {
    obstacles = [[NSMutableArray alloc] init];
    XCTAssertNotNil(obstacles);
}

-(void)testLives {
    lives = [[NSMutableArray alloc] init];
    XCTAssertNotNil(lives);
}

-(void)testScore {
    XCTAssertEqual(score, 0);
}

-(void)testDifficultyScore {
    XCTAssertEqual(difficultyscore, 0);
}

-(void)testDifficultyThreshold {
    XCTAssertEqual(difficultythreshold, 0);
}

-(void)testCurrentDifficulty {
    XCTAssertEqual(currentdifficulty, 0);
}

-(void)testGroundSpeed {
    XCTAssertEqual(groundspeed, 0);
}

-(void)testGroundTexture {

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
