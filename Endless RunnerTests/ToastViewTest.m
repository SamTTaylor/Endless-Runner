//
//  ToastViewTest.m
//  Endless Runner
//
//  Created by acq14jp on 23/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ToastView.h"

@interface ToastViewTest : XCTestCase

@property ToastView *toast;

@end

@implementation ToastViewTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.toast = [[ToastView alloc] initWithFrame:self.toast.frame];
}

-(void)testCreateToast {
    XCTAssertNotNil(self.toast);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

@end
