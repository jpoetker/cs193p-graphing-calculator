//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Jeff Poetker on 6/26/11.
//  Copyright 2011 Medplus, Inc. All rights reserved.
//

#import "CalculatorViewController.h"

@interface CalculatorViewController() 
@property (readonly) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

- (CalculatorBrain *)brain
{
    if (!brain) brain = [[CalculatorBrain alloc] init];
    return brain;
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
    
    id expression = self.brain.expression;
    NSDictionary *variables = [self generateTestVariables: expression];
    
    NSLog(@"Solving %@ with %@", expression, variables);
    
    double answer = [CalculatorBrain evaluateExpression:expression usingVariables:variables];
    
    display.text = [NSString stringWithFormat:@"%@ %g", [CalculatorBrain descriptionOfExpression:expression], answer];
    
}

- (void)dealloc
{
    [brain release];
    [super dealloc];
}

@end
