//
//  GraphAndZoomViewController.h
//  GraphingCalculator
//
//  Created by Jeff Poetker on 7/18/11.
//  Copyright 2011 Medplus, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"

@interface GraphAndZoomViewController : UIViewController <GraphViewDelegate, UISplitViewControllerDelegate> {
    
    GraphView *graphView;
    id expression;
    CGFloat scale;
    BOOL useLines;
    UISwitch *useLinesSwitch;
}

@property (nonatomic, retain) IBOutlet GraphView *graphView;
@property (nonatomic, retain) id expression;
@property (nonatomic) CGFloat scale;
@property (nonatomic) BOOL useLines;
@property (nonatomic, retain) IBOutlet UISwitch *useLinesSwitch;

- (IBAction)useLinesChange:(UISwitch *)sender;


@end
