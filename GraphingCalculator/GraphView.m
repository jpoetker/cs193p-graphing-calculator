//
//  GraphView.m
//  GraphingCalculator
//
//  Created by Jeff Poetker on 7/18/11.
//  Copyright 2011 Medplus, Inc. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"


@implementation GraphView

@synthesize delegate;
@synthesize scale;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (double) convertXPixelToGraphValueX: (CGFloat) x originAtPoint: (CGPoint) midPoint scale: (CGFloat) s
{
    return ((x - (midPoint.x * self.contentScaleFactor)) / (self.contentScaleFactor * s));
}

- (CGFloat) convertYValueToYPixel: (double) y originAtPoint: (CGPoint) midPoint scale: (CGFloat) s
{
    return (-1 * y * (self.contentScaleFactor * s) + (midPoint.y * self.contentScaleFactor));
}
- (void)drawRect:(CGRect)rect
{
    if (!self.scale) self.scale = 14;
    
    CGPoint midPoint;
    midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
//    [[UIColor grayColor] setStroke];
//    
    // Drawing code
    NSLog(@"Drawing axis for scale %f", self.scale); 
    [AxesDrawer drawAxesInRect:rect originAtPoint:midPoint scale:self.scale];
//    
    int widthInPx = self.bounds.size.width * self.contentScaleFactor;
//    int heightInPx = self.bounds.size.width * self.contentScaleFactor;
//    
    for(int x = 0;x<widthInPx;x++) {
        CGFloat xValue = [self convertXPixelToGraphValueX:x originAtPoint:midPoint scale:self.scale];
        CGFloat yValue = [delegate yValueGiven: xValue for: self];
        CGFloat y = [self convertYValueToYPixel:yValue originAtPoint:midPoint scale:self.scale];
//        NSLog(@"%f = %f", xValue, yValue);
//        NSLog(@"Pixels: (%d, %f)", x, y);
        
        CGPoint graphPoint;
        graphPoint.x = x/self.contentScaleFactor;
        graphPoint.y = y/self.contentScaleFactor;
        
        if (CGRectContainsPoint(self.bounds, graphPoint)) {
            CGRect point = CGRectMake(graphPoint.x, graphPoint.y, .5, .5);
            CGContextAddRect(context, point);
            CGContextStrokePath(context);
        }
    }
    
}

- (void)dealloc
{
    [super dealloc];
}

@end
