//
//  TactileObjectTest.m
//  Endless Runner
//
//  Created by acq14jp on 21/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TactileObject.h"

@interface TactileObjectTest : XCTestCase

@property(nonatomic, strong) TactileObject *tact;

@end

@implementation TactileObjectTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.tact = [[TactileObject alloc] init];
}

-(void)testDifficultyLevel{
    XCTAssertEqual(self.tact.difficultylevel, 0);
}

-(void)testLight{
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

@end
