//
//  CalculatorBrainTests.m
//  Calculator
//
//  Created by Jeff Poetker on 7/13/11.
//  Copyright 2011 Medplus, Inc. All rights reserved.
//

#import "CalculatorBrainTests.h"
#import "CalculatorBrain.h"

@implementation CalculatorBrainTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    brain = [[CalculatorBrain alloc] init];
}

- (void)tearDown
{
    // Tear-down code here.
    [brain release];
    
    [super tearDown];
}

- (void)testExpressionIsNil
{
    id localExpression = brain.expression;
    STAssertNil(localExpression, @"Expression is expected to be nil when nothing has happened");
}

- (void)testStoreAnOperandInExpression
{
    [brain setOperand: 8];
    
    NSArray *localExpression = brain.expression;
    
    STAssertNotNil(localExpression, @"The expression is nil");
    STAssertTrue([localExpression count] == 1, @"There should be 1 element in the expression, found %d", [localExpression count]);
    STAssertEqualObjects([localExpression objectAtIndex: 0], [NSNumber numberWithInt: 8], @"The operand stored in the expression is not 8");
}

- (void) testStoreAnOperationInExpression {
    [brain performOperation: @"+"];
    
    id localExpression = brain.expression;
    
    STAssertNotNil(localExpression, @"The expression is nil");
    STAssertTrue([localExpression count] == 1, @"There should be 1 element in the expression, found %d", [localExpression count]);
    STAssertEqualObjects([localExpression objectAtIndex: 0], @"+", @"The operation stored in the expression is not +");
    
}

- (void)testExpressionIsNotMutable
{
    // set some values in the expression array
    [brain setOperand: 42];
    
    id localExpression = brain.expression;
    
    STAssertNotNil(localExpression, @"The expression is nil");
    STAssertFalse([localExpression isMemberOfClass: [NSMutableArray class]], @"The returned array is mutable");
    STAssertTrue([localExpression isKindOfClass: [NSArray class]], @"The expression is not a kind of NSArray");
}

- (void)testMixedOperationAndOperandExpression
{
    [brain performOperation:@"C"]; 
    [brain setOperand:4]; 
    [brain performOperation:@"+"]; 
    [brain setOperand:3];
    [brain performOperation:@"="];
    
    NSArray* localExpression = brain.expression;
    STAssertNotNil(localExpression, @"The expression is nil");
    STAssertTrue([localExpression count] == 4, @"There should be 4 element in the expression, found %d", [localExpression count]);
    
    STAssertFalse([localExpression containsObject: @"C"], @"C should not be in the expression");
}
- (void)testSetVariableAsOperand
{
    [brain setVariableAsOperand: @"x"];
    
    NSArray *localExpression = brain.expression;
    
    STAssertNotNil(localExpression, @"The expression is nil");
    STAssertTrue([localExpression count] == 1, @"There should be 1 element in the expression");
    STAssertEqualObjects([localExpression objectAtIndex: 0], @"_x", @"The item in the expression is not _x");
}
- (void)testVariablesInExpression
{
    [brain setOperand: 4];
    [brain performOperation: @"+"];
    [brain setVariableAsOperand: @"x"];
    
    id localExpression = brain.expression;
    
    NSSet *variables = [CalculatorBrain variablesInExpression:localExpression];
    
    STAssertNotNil(variables, @"The set of variables is nil");
    STAssertTrue([variables count] == 1, @"There should be 1 variable in the set");
    STAssertEqualObjects([variables anyObject], @"x", @"The variable is not x");
}
- (void)testNoVariablesInExpression
{
    [brain setOperand: 42];
    [brain performOperation: @"+"];
    [brain setOperand: 2];
    
    STAssertNil([CalculatorBrain variablesInExpression: brain.expression], @"variablesInExpression did not return nil when no variables where in the expression");
}
-(void)testVariablesInNillExpression
{
    STAssertNil([CalculatorBrain variablesInExpression: nil], @"should have returned nil");
}

- (void) testSetSemanticsVariablesInExpression
{
    [brain setVariableAsOperand: @"x"];
    [brain performOperation: @"+"];
    [brain setVariableAsOperand: @"x"];
    
    id localExpression = brain.expression;
    
    STAssertNotNil(localExpression, @"The expression is nil");
    
    NSSet *variables = [CalculatorBrain variablesInExpression:localExpression];
    
    STAssertNotNil(variables, @"The set of variables is nil");
    STAssertTrue([variables count] == 1, @"There should be 1 variable in the set");
    STAssertEqualObjects([variables anyObject], @"x", @"The variable is not x");
}
- (void) testEvaluateNilExpression {
    double answer = [CalculatorBrain evaluateExpression: nil usingVariables: nil];
    STAssertTrue(answer == 0, @"The answer is not 0");
}
- (void) testSimpleExpression {
    [brain setOperand: 42];
    [brain performOperation: @"+"];
    [brain setOperand: 2];
    [brain performOperation: @"="];
    
    double answer = [CalculatorBrain evaluateExpression: brain.expression usingVariables:nil];
    
    STAssertTrue(answer == 44, @"The answer is not 44");
}

- (void) testSimpleExpression2 {
    [brain setOperand: 40];
    [brain performOperation: @"*"];
    [brain setOperand: 2];
    [brain performOperation: @"+"];
    [brain setOperand: 50];
    [brain performOperation: @"="];
    
    double answer = [CalculatorBrain evaluateExpression: brain.expression usingVariables:nil];
    
    STAssertTrue(answer == (40*2+50), @"The answer is not %d", (40*2+50));
    
}
- (void) testSingleDigitExpression {
    // should we get the value out?
    [brain setOperand: 40];
    
    double answer = [CalculatorBrain evaluateExpression: brain.expression usingVariables:nil];
    
    STAssertTrue(answer == (40), @"The answer is not %d", (40));
}
- (void) testEvaluateExpressionWithVariableNoValues {
    [brain setOperand: 40];
    [brain performOperation: @"*"];
    [brain setVariableAsOperand: @"x"];
    [brain performOperation: @"+"];
    [brain setOperand: 50];
    [brain performOperation: @"="];
    
    double answer = [CalculatorBrain evaluateExpression: brain.expression usingVariables:nil];
    
    STAssertTrue(answer == (40*0+50), @"The answer is not %d, it is %d", (40*0+50), answer);
    
}
- (void) testEvaluateExpressionWithVariableValues {
    [brain setOperand: 40];
    [brain performOperation: @"*"];
    [brain setVariableAsOperand: @"x"];
    [brain performOperation: @"+"];
    [brain setOperand: 50];
    [brain performOperation: @"-"];
    [brain setVariableAsOperand: @"y"];
    [brain performOperation: @"="];
    
    NSDictionary* values = [NSDictionary dictionaryWithObjects: 
                            [NSArray arrayWithObjects: [NSNumber numberWithDouble: 30], [NSNumber numberWithDouble:20],nil] 
                                                       forKeys:[NSArray arrayWithObjects: @"x", @"y", nil]];
    
    double answer = [CalculatorBrain evaluateExpression: brain.expression usingVariables:values];
    
    STAssertTrue(answer == (40*30+50-20), @"The answer is not %d, it is %d", (40*30+50-20), answer);
    
}

-(void) testDescribeExpression
{
    [brain setOperand: 40];
    [brain performOperation: @"*"];
    [brain setVariableAsOperand: @"x"];
    [brain performOperation: @"+"];
    [brain setOperand: 50];
    [brain performOperation: @"-"];
    [brain setVariableAsOperand: @"y"];
    [brain performOperation: @"="];
    
    NSString* description = [CalculatorBrain descriptionOfExpression: brain.expression];
    
    STAssertNotNil(description, @"description is nil");
    STAssertEqualObjects(description, @"40 * x + 50 - y =", @"The description doesn't match what is expected");
}

-(void) testPropertyListForExpression {
    [brain setOperand: 40];
    [brain performOperation: @"*"];
    [brain setVariableAsOperand: @"x"];
    [brain performOperation: @"+"];
    [brain setOperand: 50];
    [brain performOperation: @"-"];
    [brain setVariableAsOperand: @"y"];
    [brain performOperation: @"="];
    
    id myExpression = brain.expression;
    
    STAssertNotNil(myExpression, @"The expression is nil");
    
    id propertyList = [CalculatorBrain propertyListForExpression: myExpression];
    
    STAssertNotNil(propertyList, @"The property is nil");
    
}

@end
