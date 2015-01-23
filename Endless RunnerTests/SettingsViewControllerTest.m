//
//  SettingsViewControllerTest.m
//  Endless Runner
//
//  Created by acq14jp on 21/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SettingsViewController.h"

@interface SettingsViewControllerTest : XCTestCase

@property(nonatomic, strong) SettingsViewController *svc;

@end

@implementation SettingsViewControllerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.svc = [[SettingsViewController alloc]init];
}


//If buttons are selected, set Tiltbool to false
-(void)testTiltBoolZero {
    
    self.svc.tiltcontrol.selectedSegmentIndex = 0;
    if (self.svc.tiltcontrol.selectedSegmentIndex == 0) {
        [self.svc setTiltbool:false];
    }
    XCTAssertFalse(self.svc.tiltbool);
}

//Inititate BackgroundArray and check if available
- (void)testBackgroundArray {
    self.svc.backgroundarray = [[NSMutableArray alloc] init];
    XCTAssertNotNil(self.svc.backgroundarray);
}

//Inititate BackgroundArray and check if available
- (void)testCostumeArray {
    self.svc.costumearray = [[NSMutableArray alloc] init];
    XCTAssertNotNil(self.svc.costumearray);
}

//Check if backgroundArray and customeArray are unlocked
-(void)checkContentAvailableFalse {
    self.svc.unlocked = YES;
    XCTAssertFalse([self.svc checkContentAvailable:self.svc.content]);
}

-(void)checkContentAvailableTrue {
    self.svc.unlocked = NO;
    XCTAssertTrue([self.svc checkContentAvailable:self.svc.content]);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

@end
