//
//  LivingEntityTest.m
//  Endless Runner
//
//  Created by acq14jp on 21/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "LivingEntity.h"

@interface LivingEntityTest : XCTestCase {
    
    bool flying;
    float myspeed;
}

@end

@implementation LivingEntityTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

-(void)testFlying{
    XCTAssertFalse(flying);
}

-(void)testMySpeed{
    XCTAssertEqual(myspeed, 0);
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
