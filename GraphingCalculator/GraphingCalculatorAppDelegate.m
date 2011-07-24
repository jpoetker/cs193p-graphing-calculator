//
//  GraphingCalculatorAppDelegate.m
//  GraphingCalculator
//
//  Created by Jeff Poetker on 7/18/11.
//  Copyright 2011 Medplus, Inc. All rights reserved.
//

#import "GraphingCalculatorAppDelegate.h"
#import "CalculatorViewController.h"


@implementation GraphingCalculatorAppDelegate


@synthesize window=_window;

- (BOOL)iPad {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

- (void)storeApplicationData
{
    [[NSUserDefaults standardUserDefaults] setFloat:calcController.graphViewController.origin.x forKey:@"graphViewOriginX"];
    [[NSUserDefaults standardUserDefaults] setFloat:calcController.graphViewController.origin.y forKey:@"graphViewOriginY"];
    [[NSUserDefaults standardUserDefaults] setFloat:calcController.graphViewController.scale forKey:@"graphViewScale"];
    [[NSUserDefaults standardUserDefaults] setObject: [CalculatorBrain propertyListForExpression: calcController.graphViewController.expression] forKey:@"grapViewExpression"];
    
}

-(void)loadApplicationData
{
    CGFloat originX = [[NSUserDefaults standardUserDefaults] floatForKey:@"graphViewOriginX"];
    CGFloat originY = [[NSUserDefaults standardUserDefaults] floatForKey:@"graphViewOriginY"];
    calcController.graphViewController.origin = CGPointMake(originX, originY);
    
    calcController.graphViewController.scale = [[NSUserDefaults standardUserDefaults] floatForKey:@"graphViewScale"];
    calcController.graphViewController.expression = [CalculatorBrain expressionForPropertyList:[[NSUserDefaults standardUserDefaults] objectForKey:@"graphViewExpression"]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    navController = [[UINavigationController alloc]  init];
    calcController = [[CalculatorViewController alloc] init];
    
    [navController pushViewController:calcController animated:NO];
    
    [self loadApplicationData];
    
    if (self.iPad) {
        UISplitViewController *svc = [[UISplitViewController alloc] init];
        UINavigationController *rightNav = [[UINavigationController alloc] init];
        [rightNav pushViewController:calcController.graphViewController animated:NO];
        
        svc.delegate = calcController.graphViewController;
        svc.viewControllers = [NSArray arrayWithObjects: navController, rightNav, nil];
        [navController release]; [rightNav release];
        
        [self.window addSubview:svc.view];
    } else {
        [self.window addSubview:navController.view];                                          
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    [self storeApplicationData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    [self storeApplicationData];
}

- (void)dealloc
{
    [_window release];
    [calcController release];
    [navController release];
    [super dealloc];
}

@end
