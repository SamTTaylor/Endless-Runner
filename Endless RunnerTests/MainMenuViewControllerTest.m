//
//  MainMenuViewControllerTest.m
//  Endless Runner
//
//  Created by acq14jp on 23/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MainMenuViewController.h"

@interface MainMenuViewControllerTest : XCTestCase

@property (nonatomic, strong) MainMenuViewController *mmvc;

@end

@implementation MainMenuViewControllerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.mmvc = [[MainMenuViewController alloc] init];
}

-(void)testCostumeAndBackgroundArray {
    
    [self.mmvc fillcostumearray];
    XCTAssertEqual(self.mmvc.costumearray.count, 7);
    [self.mmvc fillBackgroundArray];
    XCTAssertEqual(self.mmvc.backgroundarray.count, 3);
}

-(void)testLoadDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.mmvc.austria = [defaults boolForKey:@"austria"];
    XCTAssertNotNil(defaults);
};

-(void)testSaveDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:1 forKey:@"bgimageindex"];
    XCTAssertNotNil(defaults);
};

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
