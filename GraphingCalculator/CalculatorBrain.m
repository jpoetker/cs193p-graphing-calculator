//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Jeff Poetker on 6/26/11.
//  Copyright 2011 Medplus, Inc. All rights reserved.
//

#import "CalculatorBrain.h"

#define VARIABLE_PREFIX @"_"

@interface CalculatorBrain() 
@property (retain) NSString *waitingOperation;
@property double waitingOperand;
@end

@implementation CalculatorBrain

@synthesize memory, errorMessage;
@synthesize waitingOperation;
@synthesize waitingOperand;

- (void) addTermToExpression: (id) term
{
    if (!internalExpression) {
        internalExpression = [[NSMutableArray alloc] init ];
    }
    [internalExpression addObject: term];
    
    NSLog(@"%@", internalExpression);
}

- (void) releaseInternalExpression
{
    [internalExpression release];
    internalExpression = nil;
}

- (id) expression
{
    return [[internalExpression copy] autorelease];
}

- (double) operand
{
    return operand;
}

- (void) setOperand: (double) aDouble
{
    [self addTermToExpression: [NSNumber numberWithDouble: aDouble]];
    operand = aDouble;
}

- (void)setVariableAsOperand:(NSString *)variableName
{
    [self addTermToExpression: [VARIABLE_PREFIX stringByAppendingString: variableName]];
}

- (void)performWaitingOperation
{
    if ([@"+" isEqual:self.waitingOperation])
    {
        operand = self.waitingOperand + operand;
    } 
    else if ([@"*" isEqual:self.waitingOperation])
    {
        operand = self.waitingOperand * operand;
    }
    else if ([@"-" isEqual:self.waitingOperation]) 
    {
        operand = self.waitingOperand - operand;
    }
    else if ([@"/" isEqual:self.waitingOperation]) 
    {
        if (operand) {
            operand = self.waitingOperand / operand;
        } else {
            errorMessage = @"Division by zero";
        }
    }
    
}

- (double)performOperation:(NSString *)operation
{
    errorMessage = nil;
    // I'm going to try this here, and see what happens
    // It may prove to be a very bad idea
    [self addTermToExpression: operation];
    
    if ([operation isEqual: @"sqrt"]) {
        if (operand >= 0) {
            operand = sqrt(operand);
        } else {
            errorMessage = @"Not a number";
        }
    } else if ([@"+/-" isEqual:operation]) {
        operand = - operand;
    } else if ([@"1/x" isEqual:operation]) {
        if (operand) {
            operand = 1 / operand;
        } else {
            errorMessage = @"Division by zero";
        }
    } else if ([@"sin" isEqual:operation]) {       
        operand = sin(operand);
    } else if ([@"cos" isEqual:operation]) {
        operand = cos(operand);
    } else if ([@"Store" isEqual:operation]) {
        memory = operand;
    } else if ([@"Recall" isEqual:operation]) {
        operand = memory;
    } else if ([@"Mem+" isEqual:operation]) {
        memory += operand;
    } else if ([@"π" isEqual:operation]) {
        operand = M_PI;
    } else if ([@"MC" isEqual:operation]) {
        memory = 0;
    } else if ([@"C" isEqual:operation]) {
        memory = 0;
        operand = 0;
        self.waitingOperation = nil;
        [self releaseInternalExpression];
        self.waitingOperand = 0;
    } else {
        [self performWaitingOperation];
        self.waitingOperation = operation;
        
        waitingOperand = operand;
    }
    return operand;
}

- (void) dealloc
{
    self.waitingOperation = nil;
    [self releaseInternalExpression];
    
    [super dealloc];
}

+ (BOOL) isVariableRepresentation: (id)value
{
    BOOL answer = NO;
    if ([value isKindOfClass: [NSString class]]) {
        NSRange range = [value rangeOfString: VARIABLE_PREFIX];
        answer = ((range.location != NSNotFound) && ([value length] > [VARIABLE_PREFIX length]));
    }
    return answer;
}

+ (NSString *) variableFromInternalRepresentation: (NSString *) stringValue
{
    return [stringValue substringFromIndex: [VARIABLE_PREFIX length]];
}

+ (double)evaluateExpression:(id) anExpression
              usingVariables: (NSDictionary *) variables
{
    double answer = 0;
    CalculatorBrain *myBrain;
    
    if (anExpression) {
        myBrain = [[CalculatorBrain alloc] init];
        
        for (id expressionValue in anExpression) {
            if ([expressionValue isKindOfClass: [NSNumber class]]) {
                [myBrain setOperand: [(NSNumber *) expressionValue doubleValue]];
            } else if ([expressionValue isKindOfClass: [NSString class]]) {
                NSString *stringValue = (NSString *) expressionValue;
                if ([CalculatorBrain isVariableRepresentation: stringValue]) {
                    NSString* varname = [CalculatorBrain variableFromInternalRepresentation: stringValue];
                    id value = [variables objectForKey: varname];
                    if ([value respondsToSelector: @selector(doubleValue)]) {
                        [myBrain setOperand: [value doubleValue]];
                    } else { 
                        [myBrain setOperand: 0];
                    }
                } else {
                    [myBrain performOperation: stringValue];
                }
            }
        }
        
        answer = [myBrain operand];
        [myBrain release];
    }
    return answer;
    
}

+ (NSSet *)variablesInExpression: (id) anExpression
{
    NSMutableSet *variables = nil;
    
    if ([anExpression isKindOfClass: [NSArray class]]) {
        for (id value in anExpression) {
            if ([value isKindOfClass: [NSString class]]) {
                NSString *stringValue = (NSString *) value;
                if ([CalculatorBrain isVariableRepresentation: stringValue]) {
                    if (!variables) variables = [[[NSMutableSet alloc] init ] autorelease];
                    [variables addObject: [CalculatorBrain  variableFromInternalRepresentation: stringValue]];
                }
            }
        }
    }
    
    return variables;
}

+ (NSString *)descriptionOfExpression: (id) anExpression 
{
    NSMutableString* buffer = [[[NSMutableString alloc] init] autorelease];
    
    if (anExpression) {
        for(id value in anExpression) {
            if ([buffer length] > 0) {
                [buffer appendString: @" "];
            }
            if ([CalculatorBrain isVariableRepresentation: value]) {
                [buffer appendString: [CalculatorBrain variableFromInternalRepresentation:value]];
            } else {
                [buffer appendFormat: @"%@", value];
            }
        }
    }
    
    return buffer;
}

+ (id)propertyListForExpression: (id)anExpression
{
    return [[anExpression retain] autorelease];
}

+ (id)expressionForPropertyList: (id)propertyList
{
    return [[propertyList retain] autorelease];
}
@end
