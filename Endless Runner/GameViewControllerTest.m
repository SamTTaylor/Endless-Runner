//
//  GameViewControllerTest.m
//  Endless Runner
//
//  Created by acq14jp on 21/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "GameViewController.h"

@interface GameViewControllerTest : XCTestCase {
    
    bool tiltbool;
    SKTexture* bgtexture;
    SKTexture* groundtexture;
    NSMutableArray* costumearray;
    bool closing;
    bool gamestarted;
    bool startedbytilt;
    double yRotation;
    float updatespeed;
    NSTimer* updatetimer;
    NSMutableArray *spawnedobjects;
}

@end

@implementation GameViewControllerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testTiltBool {
    XCTAssertFalse(tiltbool);
}

- (void)testBgTexture {
    
}

- (void)testGroundTexture {
    
}

- (void)testCostumeArray {
    costumearray = [[NSMutableArray alloc] init];
    XCTAssertNotNil(costumearray);
}

- (void)testClosing {
    XCTAssertFalse(closing);
}

- (void)testGameStarted {
    XCTAssertFalse(gamestarted);
}

- (void)testStartedByTilt {
    XCTAssertFalse(startedbytilt);
}

- (void)testYRotation {
    
}

- (void)testUpdateSpeed {
    
}

- (void)testUpdateTimer {
    
}

- (void)testSpawnedObjects {
    spawnedobjects = [[NSMutableArray alloc] init];
    XCTAssertNotNil(spawnedobjects);
}

//>>>>>>>>>>>>>>>>>>>>GESTURE RECOGNIZERS<<<<<<<<<<<<<<<<<<<<

//>>>>>>>>>>>>>>>>>>>>TILT SENSOR<<<<<<<<<<<<<<<<<<<<

//>>>>>>>>>>>>>>>>>>>>LOCATION MANAGER<<<<<<<<<<<<<<<<<<<<

//>>>>>>>>>>>>>>>>>>>>TEXTURE ATLASES<<<<<<<<<<<<<<<<<<<<

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
