//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Jeff Poetker on 6/26/11.
//  Copyright 2011 Medplus, Inc. All rights reserved.
//

#import "CalculatorViewController.h"
#import "GraphAndZoomViewController.h"

@interface CalculatorViewController() 
@property (readonly) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Calculator";
    }
    return self;
}

- (CalculatorBrain *)brain
{
    if (!brain) brain = [[CalculatorBrain alloc] init];
    return brain;
}

- (GraphAndZoomViewController *) graphViewController
{
    if (!graphViewController) graphViewController = [[GraphAndZoomViewController alloc] init];
    return graphViewController;
}

-(void)updateExpressionInGrapView
{
    
    self.graphViewController.title = [[CalculatorBrain descriptionOfExpression:self.brain.expression] stringByAppendingString:@" y"];
    self.graphViewController.expression = self.brain.expression;
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = sender.titleLabel.text;
    
    if (userIsInTheMiddleOfTypingANumber)
    {
        display.text = [display.text stringByAppendingString:digit];
    }
    else
    {
        display.text = digit;
        userIsInTheMiddleOfTypingANumber = YES;
    }
}

- (void) updateMemoryDisplay {
    
    // update the memory display - only necessary for memory operations,
    // but I don't know what the harm is in always doing it
    if (self.brain.memory) {
        memoryDisplay.text = [NSString stringWithFormat:@"%g", brain.memory];
    } else {
        memoryDisplay.text = @"";
    }
}

- (IBAction)operationPressed:(UIButton *)sender
{
    NSString *operation = sender.titleLabel.text;
    
    if (userIsInTheMiddleOfTypingANumber) {
        [self.brain setOperand: [display.text doubleValue]];
        
        if (![@"MC" isEqual:operation]) {
            userIsInTheMiddleOfTypingANumber = NO;
        }
    }
    
    double result = [[self brain] performOperation:operation];
    
    if ([CalculatorBrain variablesInExpression:self.brain.expression]) {
        // We're updating an expression
        display.text = [CalculatorBrain descriptionOfExpression: self.brain.expression];
    } else {
        
        if (self.brain.errorMessage) {
            display.text = @"You suck at math.";
        } else {
            display.text = [NSString stringWithFormat:@"%g", result];
        }
    }
    [self updateMemoryDisplay];
}

- (IBAction)decimalPointPressed:(UIButton *)sender
{
    NSRange decimalLocation = [display.text rangeOfString:@"."];
    if ((!userIsInTheMiddleOfTypingANumber) || (decimalLocation.location == NSNotFound)) {
        [self digitPressed:sender];
    }
}

- (IBAction)variablePressed:(UIButton *)sender {
    NSString *variable = sender.titleLabel.text;
    
    if (userIsInTheMiddleOfTypingANumber) {
        [self.brain setOperand: [display.text doubleValue]];
    }
    
    [brain setVariableAsOperand:variable];
    
    display.text = [CalculatorBrain descriptionOfExpression: brain.expression];
}

- (NSDictionary *) generateTestVariables: (id) expression {
    NSMutableDictionary *testValues = nil;
    NSSet *vars = [CalculatorBrain  variablesInExpression: expression];
    
    for (NSString *term in vars) {
        if (!testValues) testValues = [[[NSMutableDictionary alloc] init] autorelease];
        [testValues setObject: [NSNumber numberWithInt: (rand() % 10)] forKey: term];
    }
    
    return testValues;
}

- (void) applyEqualsIfNeccesaryForSolve
{
    NSString *expression = [CalculatorBrain descriptionOfExpression: self.brain.expression];
    if (![@"=" isEqual: [expression substringFromIndex: ([expression length] - 1)]]) {
        [self.brain performOperation: @"="];
    }
    
}

- (IBAction)solvePressed {
    if (userIsInTheMiddleOfTypingANumber) {
        [self.brain setOperand: [display.text doubleValue]];
    }
    
    [self applyEqualsIfNeccesaryForSolve];

    [self updateExpressionInGrapView];
    
    if (self.graphViewController.view.window == nil) {
        [self.navigationController pushViewController: self.graphViewController animated:YES];
    }
    // I'm going to save the expression on solve
    
    [[NSUserDefaults standardUserDefaults] setObject: [CalculatorBrain expressionForPropertyList: self.brain.expression] forKey: @"graphViewExpression"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
{
    if (self.graphViewController.splitViewController == nil) {
        return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return YES;
    }
}

- (CGSize)contentSizeForViewInPopover
{
    CGRect viewFrame = CGRectZero;
    
    for(UIView *subview in self.view.subviews) {
        viewFrame = CGRectUnion(subview.frame, viewFrame);
    }
    
    viewFrame.size.width += 20;
    viewFrame.size.height += 20;
    
    return viewFrame.size;
}

-(void) viewDidLoad
{
    self.brain.expression = [CalculatorBrain expressionForPropertyList:[[NSUserDefaults standardUserDefaults] objectForKey:@"graphViewExpression"]];
    display.text = [CalculatorBrain descriptionOfExpression: self.brain.expression];
    [self updateExpressionInGrapView];
}
- (void)dealloc
{
    [brain release];
    [graphViewController release];
    [super dealloc];
}

@end
