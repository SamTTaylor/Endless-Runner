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
    XCTAssertEqual(jumpcount, 0);
}

- (void)testInMushroom{
    XCTAssertFalse(inmushroom);
}

- (void)testInBog{
    XCTAssertFalse(inbog);
}

- (void)testLives{
    XCTAssertEqual(lives, 0);
}

- (void)testInvulnerable{
    XCTAssertFalse(invulnerable);
}

- (void)testWalkAnimation{
    
}

- (void)testJumpAnimation{

}

- (void)testInjuredAnimation{
    
}

- (void)testAnimated{
     XCTAssertTrue(animated);
}

- (void)testGotFollower{
    XCTAssertFalse(gotfollower);
}

- (void)testCostumePosition{
    
}

- (void)testCostumeArray{
    costumearray = [[NSMutableArray alloc] init];
    XCTAssertNotNil(costumearray);
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
