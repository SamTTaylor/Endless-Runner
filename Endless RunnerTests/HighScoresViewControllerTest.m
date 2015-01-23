//
//  HighScoresViewControllerTest.m
//  Endless Runner
//
//  Created by acq14jp on 21/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "HighScoresViewController.h"
#import "AppDelegate.h"

@interface HighScoresViewControllerTest : XCTestCase

@property (nonatomic, strong) HighScoresViewController *hsvc;
@property (nonatomic, strong) AppDelegate *app;
@property (nonatomic, strong) GameViewController *view;

@end

@implementation HighScoresViewControllerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.hsvc = [[HighScoresViewController alloc] init];
    self.app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

//Fill HighScoreArray with Dummy Value and check if value is saved
-(void)testHighScoreArray {
    [self.view saveScoreWithName:@"Jennifer" Score:10000 Facebook:NO];
    XCTAssertNotNil(self.app.highscores);
    bool highscoresaved;
    NSUInteger scoreIndex = [self.app.highscores indexOfObject: @"Jennifer"];
    if (scoreIndex == (int)nan) {
        highscoresaved = false;
    } else {
        highscoresaved = true;
    }
    XCTAssertTrue(highscoresaved);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        [self.hsvc viewDidLoad];
    }];
}

@end
