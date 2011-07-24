//
//  GraphView.h
//  GraphingCalculator
//
//  Created by Jeff Poetker on 7/18/11.
//  Copyright 2011 Medplus, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphView;

@protocol GraphViewDelegate
-(double) yValueGiven: (double) x for: (GraphView *)requestor;
-(void) originMovedTo: (CGPoint) origin for: (GraphView *)requestor;
-(void) scaleChangedTo: (CGFloat) scale for: (GraphView *)requestor;

@end

@interface GraphView : UIView {
    id <GraphViewDelegate> delegate;
    float scale;
    BOOL useLines;
    CGPoint origin;
}

@property (assign) id <GraphViewDelegate> delegate;
@property CGFloat scale;
@property BOOL useLines;
@property CGPoint origin;

-(void)pan:(UIPanGestureRecognizer *)sender;
-(void)pinch:(UIPinchGestureRecognizer *)sender;
-(void)tap:(UITapGestureRecognizer *)sender;

@end
