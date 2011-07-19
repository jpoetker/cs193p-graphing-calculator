//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Jeff Poetker on 6/26/11.
//  Copyright 2011 Medplus, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CalculatorBrain : NSObject {
    double operand;
    NSString *waitingOperation;
    double waitingOperand;
    double memory;
    NSString *errorMessage;
    NSMutableArray *internalExpression;
}

@property (readonly) double memory;
@property (readonly) NSString *errorMessage;
@property (readonly) id expression;

- (void)setOperand:(double) aDouble;
- (void)setVariableAsOperand:(NSString *)variableName;
- (double)performOperation:(NSString *)operation;


+ (double)evaluateExpression:(id) anExpression
              usingVariables: (NSDictionary *) variables;
+ (NSSet *)variablesInExpression: (id) anExpression;
+ (NSString *)descriptionOfExpression: (id) anExpression;

+ (id)propertyListForExpression: (id)anExpression;
+ (id)expressionForPropertyList: (id)propertyList;

@end
