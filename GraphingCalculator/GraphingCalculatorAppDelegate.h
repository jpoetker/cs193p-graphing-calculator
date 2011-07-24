//
//  GraphingCalculatorAppDelegate.h
//  GraphingCalculator
//
//  Created by Jeff Poetker on 7/18/11.
//  Copyright 2011 Medplus, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorViewController.h"

@interface GraphingCalculatorAppDelegate : NSObject <UIApplicationDelegate> {
    @private
    UINavigationController *navController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (readonly) BOOL iPad;
@end
