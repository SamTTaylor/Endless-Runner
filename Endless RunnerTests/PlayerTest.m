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

@interface PlayerTest : XCTestCase {
    
    int jumpcount;
    bool inmushroom;
    bool inbog;
    int lives;
    bool invulnerable;
    SKAction *walkAnimation;
    SKAction *jumpAnimation;
    SKAction *injuredAnimation;
    bool animated;
    bool gotfollower;
    CGPoint costumeposition;
    NSMutableArray *costumearray;
}

@end

@implementation PlayerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testJumpCount{
    
}

- (void)testInMushroom{
    
}

- (void)testInBog{
    
}

- (void)testLives{
    
}

- (void)testInvulnerable{
    
}

- (void)testWalkAnimation{
    
}

- (void)testJumpAnimation{

}

- (void)testInjuredAnimation{
    
}

- (void)testAnimated{
    
}

- (void)testGotFollower{
    
}

- (void)testCurrentButterfly{
    
}

- (void)testCostume{
    
}

- (void)testCostumePosition{
    
}

- (void)testCostumeArray{
    
}

- (void)testAssignCostumePosition{
    
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
