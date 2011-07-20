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
@end

@interface GraphView : UIView {
    id <GraphViewDelegate> delegate;
    float scale;
    BOOL useLines;
}

@property (assign) id <GraphViewDelegate> delegate;
@property float scale;
@property BOOL useLines;

@end
