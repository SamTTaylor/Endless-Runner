//
//  EntityTest.m
//  Endless Runner
//
//  Created by acq14jp on 21/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Entity.h"

@interface EntityTest : XCTestCase

@property(nonatomic, strong) Entity *ent;

@end

@implementation EntityTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.ent = [[Entity alloc] initWithTexture:self.ent.nodetexture];
}

- (void)testNodeTexture{
    XCTAssertNotNil(self.ent);
}

//>>>>>>>>>>>>>>>>>>>>TEST COLLISION<<<<<<<<<<<<<<<<<<<<
- (void)testCollisionBoundingBox{
    CGRect testrect = CGRectInset(self.ent.frame, 2, 0);
    CGRect realrect = [self.ent collisionBoundingBox];
    XCTAssertTrue(CGRectEqualToRect(testrect, realrect));
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
