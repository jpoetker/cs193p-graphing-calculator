//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Jeff Poetker on 6/26/11.
//  Copyright 2011 Medplus, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorBrain.h"
#import "GraphAndZoomViewController.h"

@interface CalculatorViewController : UIViewController {
    IBOutlet UILabel *display;
    IBOutlet UILabel *memoryDisplay;
    CalculatorBrain *brain;
    BOOL userIsInTheMiddleOfTypingANumber;
    GraphAndZoomViewController *graphViewController;
}

@property (readonly) GraphAndZoomViewController *graphViewController;

- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)operationPressed:(UIButton *)sender;
- (IBAction)decimalPointPressed:(UIButton *)sender;
- (IBAction)variablePressed:(UIButton *)sender;
- (IBAction)solvePressed;

@end
