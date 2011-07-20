//
//  GraphAndZoomViewController.h
//  GraphingCalculator
//
//  Created by Jeff Poetker on 7/18/11.
//  Copyright 2011 Medplus, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"

@interface GraphAndZoomViewController : UIViewController <GraphViewDelegate> {
    
    GraphView *graphView;
    id expression;
    float scale;
    BOOL useLines;
    UISwitch *useLinesSwitch;
}

@property (nonatomic, retain) IBOutlet GraphView *graphView;
@property (retain) id expression;
@property float scale;
@property BOOL useLines;
@property (nonatomic, retain) IBOutlet UISwitch *useLinesSwitch;

- (IBAction)zoomButtonPressed:(UIButton *)sender;
- (IBAction)useLinesChange:(UISwitch *)sender;


@end
