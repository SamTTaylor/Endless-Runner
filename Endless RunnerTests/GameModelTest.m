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
    
    GameModel *model;
    Player *player;
    NSMutableArray *enemies;
    NSMutableArray *obstacles;
    NSMutableArray *lives;
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

}

-(void)testDifficultyScore {

}

-(void)testDifficultyThreshold {

}

-(void)testCurrentDifficulty {

}

-(void)testGroundSpeed {

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
