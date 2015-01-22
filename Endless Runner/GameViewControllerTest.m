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

@interface GameViewControllerTest : XCTestCase

@end

@implementation GameViewControllerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTiltBool {
    GameViewController *tiltbool = [[GameModel alloc]init];
}

- (void)testBgTexture {
    
}

- (void)testGroundTexture {
    
}

- (void)testCostumeArray {
    
}

- (void)testClosing {
    
}

- (void)testGameStarted {
    
}

- (void)testStartedByTilt {
    
}

- (void)testYRotation {
    
}

- (void)testUpdateSpeed {
    
}

- (void)testUpdateTimer {
    
}

- (void)testSpawnedObjects {
    
}

//>>>>>>>>>>>>>>>>>>>>GESTURE RECOGNIZERS<<<<<<<<<<<<<<<<<<<<

//>>>>>>>>>>>>>>>>>>>>TILT SENSOR<<<<<<<<<<<<<<<<<<<<

//>>>>>>>>>>>>>>>>>>>>LOCATION MANAGER<<<<<<<<<<<<<<<<<<<<

//>>>>>>>>>>>>>>>>>>>>TEXTURE ATLASES<<<<<<<<<<<<<<<<<<<<

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
