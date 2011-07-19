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
-(CGFloat) yValueGiven: (CGFloat) x for: (GraphView *)requestor;
@end

@interface GraphView : UIView {
    id <GraphViewDelegate> delegate;
}

@property (assign) id <GraphViewDelegate> delegate;
@property float scale;

@end
